from logging.config import fileConfig
import asyncio
from sqlalchemy import pool, text
from sqlalchemy.ext.asyncio import create_async_engine
from alembic import context
from app.core.config import settings
from app.models.base import BaseModel
import app.models  # noqa: F401

config = context.config

_DB_URL = settings.DATABASE_URL.replace("postgresql://", "postgresql+asyncpg://")

if config.config_file_name is not None:
    fileConfig(config.config_file_name)

target_metadata = BaseModel.metadata


def run_migrations_offline():
    context.configure(
        url=_DB_URL,
        target_metadata=target_metadata,
        literal_binds=True,
    )
    with context.begin_transaction():
        context.run_migrations()


async def _stamp_baseline_async():
    """
    SEPARATE async function that runs BEFORE Alembic's run_sync bridge.

    Uses its own engine + connection + explicit commit so the alembic_version
    UPDATE is fully persisted to PostgreSQL before Alembic opens its own
    connection and calls upgrade(). This is the only reliable way to pre-set
    alembic_version: any write done inside run_sync(do_run_migrations) shares
    a transaction with Alembic's own version-stamp writes, causing one or the
    other to be lost depending on transaction nesting order.

    FINAL_MIGRATION: the revision we want to reach after this startup.
    STAMP_AT:        one step before — we reset alembic_version here so
                     Alembic runs exactly FINAL_MIGRATION on upgrade head.
    """
    FINAL_MIGRATION = "054"
    STAMP_AT        = "053"

    engine = create_async_engine(_DB_URL, poolclass=pool.NullPool)
    try:
        async with engine.begin() as conn:   # begin() auto-commits on exit
            # Check alembic_version table exists
            has_table = (await conn.execute(text(
                "SELECT EXISTS (SELECT 1 FROM information_schema.tables "
                "WHERE table_name = 'alembic_version')"
            ))).scalar()

            # Check real schema exists (not a blank DB)
            has_users = (await conn.execute(text(
                "SELECT EXISTS (SELECT 1 FROM information_schema.tables "
                "WHERE table_name = 'users')"
            ))).scalar()

            if not has_users:
                return  # fresh empty DB — let Alembic run from scratch

            current = set()
            if has_table:
                rows = (await conn.execute(
                    text("SELECT version_num FROM alembic_version")
                )).fetchall()
                current = {r[0] for r in rows}

            if FINAL_MIGRATION in current:
                return  # already up to date — permanent no-op

            print(
                f"[INFO] env.py: {FINAL_MIGRATION} not yet applied "
                f"(current={current}) — resetting to {STAMP_AT}"
            )

            if not has_table:
                await conn.execute(text(
                    "CREATE TABLE alembic_version "
                    "(version_num VARCHAR(32) NOT NULL, "
                    "CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num))"
                ))
            else:
                await conn.execute(text("DELETE FROM alembic_version"))

            await conn.execute(
                text(f"INSERT INTO alembic_version (version_num) VALUES ('{STAMP_AT}')")
            )
            # engine.begin() commits here automatically on __aexit__

        print(
            f"[INFO] env.py: alembic_version committed to {STAMP_AT} "
            f"— upgrade will now run {FINAL_MIGRATION}"
        )
    finally:
        await engine.dispose()


async def run_async_migrations():
    # Step 1: pre-stamp alembic_version in its own committed transaction
    await _stamp_baseline_async()

    # Step 2: run Alembic upgrade — picks up from STAMP_AT, runs FINAL_MIGRATION
    engine = create_async_engine(_DB_URL, poolclass=pool.NullPool)
    async with engine.connect() as connection:
        await connection.run_sync(do_run_migrations)
    await engine.dispose()


def do_run_migrations(connection):
    context.configure(connection=connection, target_metadata=target_metadata)
    with context.begin_transaction():
        context.run_migrations()


if context.is_offline_mode():
    run_migrations_offline()
else:
    asyncio.run(run_async_migrations())
