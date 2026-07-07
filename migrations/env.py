from logging.config import fileConfig
import asyncio
from sqlalchemy import pool
from sqlalchemy.ext.asyncio import async_engine_from_config, create_async_engine
from alembic import context
from app.core.config import settings
from app.models.base import BaseModel
import app.models  # noqa: F401

config = context.config

# NOTE: We intentionally do NOT use config.set_main_option() to set the DB URL.
# The password contains %-encoded characters (e.g. %40, %23) which Python's
# configparser misinterprets as interpolation syntax and raises ValueError.
# Instead we build the URL directly and pass it to the engine, bypassing
# configparser entirely.
_DB_URL = settings.DATABASE_URL.replace("postgresql://", "postgresql+asyncpg://")

if config.config_file_name is not None:
    fileConfig(config.config_file_name)

target_metadata = BaseModel.metadata

def run_migrations_offline():
    # Pass URL directly — never through config.get_main_option()
    context.configure(
        url=_DB_URL,
        target_metadata=target_metadata,
        literal_binds=True,
    )
    with context.begin_transaction():
        context.run_migrations()

async def run_async_migrations():
    # Build the engine directly from the URL string, not from configparser section
    connectable = create_async_engine(_DB_URL, poolclass=pool.NullPool)
    async with connectable.connect() as connection:
        await connection.run_sync(do_run_migrations)
    await connectable.dispose()


def _maybe_stamp_baseline(connection):
    """
    If the DB already has the core schema (users table exists) but has no
    Alembic version recorded, it was set up before Alembic tracking was
    introduced.  Stamping at revision 046 tells Alembic that all migrations
    up to that point are already applied, so upgrade() only runs the genuinely
    new ones (047 onward) instead of trying to CREATE TABLE on existing tables.
    """
    from sqlalchemy import text
    has_version_table = connection.execute(text(
        "SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'alembic_version')"
    )).scalar()

    current_versions = set()
    if has_version_table:
        rows = connection.execute(text("SELECT version_num FROM alembic_version")).fetchall()
        current_versions = {r[0] for r in rows}

    has_users = connection.execute(text(
        "SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'users')"
    )).scalar()

    if has_users and not current_versions:
        print("[INFO] env.py: DB has schema but no alembic_version — stamping baseline at 046")
        if not has_version_table:
            connection.execute(text("CREATE TABLE alembic_version (version_num VARCHAR(32) NOT NULL, CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num))"))
        connection.execute(text("INSERT INTO alembic_version (version_num) VALUES ('046')"))
        connection.commit()
        print("[INFO] env.py: stamped at 046, upgrade will now apply only new migrations")


def do_run_migrations(connection):
    _maybe_stamp_baseline(connection)
    context.configure(connection=connection, target_metadata=target_metadata)
    with context.begin_transaction():
        context.run_migrations()

if context.is_offline_mode():
    run_migrations_offline()
else:
    asyncio.run(run_async_migrations())
