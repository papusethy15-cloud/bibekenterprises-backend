"""add core revenue flow models

Revision ID: 91baaab49547
Revises: 
Create Date: 2026-05-29 18:56:42.896319

REWRITTEN: Original used op.create_table() which raises DuplicateTableError when
the VPS DB already has these tables (created before Alembic tracking was in place).
All CREATE TABLE statements now use IF NOT EXISTS so this migration is fully
idempotent — safe no-op on any DB that already has the schema.
Enum types also use CREATE TYPE IF NOT EXISTS.
"""
from typing import Sequence, Union
from alembic import op
import sqlalchemy as sa


revision: str = '91baaab49547'
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Create enum types (IF NOT EXISTS requires PG 9.5+ — we're on PG 14+)
    op.execute("CREATE TYPE IF NOT EXISTS userrole AS ENUM ('SUPER_ADMIN','ADMIN','CCO','TECHNICIAN','CUSTOMER','ACCOUNTANT','INVENTORY_MANAGER')")
    op.execute("CREATE TYPE IF NOT EXISTS technicianstatus AS ENUM ('ACTIVE','INACTIVE','ON_LEAVE','SUSPENDED')")
    op.execute("CREATE TYPE IF NOT EXISTS bookingstatus AS ENUM ('PENDING','CONFIRMED','ASSIGNED','ACCEPTED','EN_ROUTE','ARRIVED','INSPECTING','IN_PROGRESS','COMPLETED','CANCELLED','RESCHEDULED','NO_SHOW')")
    op.execute("CREATE TYPE IF NOT EXISTS bookingsource AS ENUM ('WEBSITE','MOBILE_APP','CALL_CENTER','WALK_IN','FRANCHISE')")
    op.execute("CREATE TYPE IF NOT EXISTS assignmenttype AS ENUM ('AUTO','MANUAL')")
    op.execute("CREATE TYPE IF NOT EXISTS assignmentstatus AS ENUM ('ASSIGNED','ACCEPTED','REJECTED','TIMEOUT','REASSIGNED')")
    op.execute("CREATE TYPE IF NOT EXISTS quotationstatus AS ENUM ('DRAFT','SUBMITTED','APPROVED','REJECTED','REVISED','EXPIRED','CONVERTED_TO_INVOICE')")
    op.execute("CREATE TYPE IF NOT EXISTS invoicetype AS ENUM ('GST_B2C','GST_B2B','NON_GST')")
    op.execute("CREATE TYPE IF NOT EXISTS invoicestatus AS ENUM ('DRAFT','GENERATED','PAID','PARTIALLY_PAID','CANCELLED','REFUNDED')")
    op.execute("CREATE TYPE IF NOT EXISTS paymentmethod AS ENUM ('RAZORPAY','UPI','CASH','BANK_TRANSFER','WALLET')")
    op.execute("CREATE TYPE IF NOT EXISTS paymentstatus AS ENUM ('PENDING','SUCCESS','FAILED','REFUNDED','PARTIALLY_REFUNDED')")
    op.execute("CREATE TYPE IF NOT EXISTS partsource AS ENUM ('OFFICE_STOCK','MARKET_PURCHASE')")

    op.execute("""
        CREATE TABLE IF NOT EXISTS assignment_rules (
            name VARCHAR(100) NOT NULL,
            strategy VARCHAR(100),
            max_active_bookings INTEGER,
            prefer_same_city BOOLEAN,
            require_skill_match BOOLEAN,
            prefer_high_rating BOOLEAN,
            prefer_low_workload BOOLEAN,
            response_timeout_minutes INTEGER,
            notes TEXT,
            id UUID NOT NULL,
            created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
            updated_at TIMESTAMP WITHOUT TIME ZONE,
            is_active BOOLEAN,
            PRIMARY KEY (id),
            UNIQUE (name)
        )
    """)

    op.execute("""
        CREATE TABLE IF NOT EXISTS service_categories (
            name VARCHAR(150) NOT NULL,
            description TEXT,
            icon VARCHAR(500),
            sort_order INTEGER,
            id UUID NOT NULL,
            created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
            updated_at TIMESTAMP WITHOUT TIME ZONE,
            is_active BOOLEAN,
            PRIMARY KEY (id)
        )
    """)

    op.execute("""
        CREATE TABLE IF NOT EXISTS users (
            name VARCHAR(150) NOT NULL,
            mobile VARCHAR(20) NOT NULL,
            email VARCHAR(200),
            password_hash VARCHAR(255),
            role userrole NOT NULL,
            city VARCHAR(100),
            profile_image VARCHAR(500),
            is_verified BOOLEAN,
            id UUID NOT NULL,
            created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
            updated_at TIMESTAMP WITHOUT TIME ZONE,
            is_active BOOLEAN,
            PRIMARY KEY (id),
            UNIQUE (email),
            UNIQUE (mobile)
        )
    """)

    op.execute("""
        CREATE TABLE IF NOT EXISTS customers (
            user_id UUID NOT NULL REFERENCES users(id),
            name VARCHAR(150) NOT NULL,
            mobile VARCHAR(20) NOT NULL,
            email VARCHAR(200),
            alternate_mobile VARCHAR(20),
            notes TEXT,
            customer_code VARCHAR(30),
            total_bookings VARCHAR(10),
            id UUID NOT NULL,
            created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
            updated_at TIMESTAMP WITHOUT TIME ZONE,
            is_active BOOLEAN,
            PRIMARY KEY (id),
            UNIQUE (customer_code),
            UNIQUE (user_id)
        )
    """)

    op.execute("""
        CREATE TABLE IF NOT EXISTS services (
            category_id UUID NOT NULL REFERENCES service_categories(id),
            name VARCHAR(200) NOT NULL,
            description TEXT,
            base_price FLOAT NOT NULL,
            gst_percent FLOAT,
            duration_mins INTEGER,
            is_visible BOOLEAN,
            sort_order INTEGER,
            id UUID NOT NULL,
            created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
            updated_at TIMESTAMP WITHOUT TIME ZONE,
            is_active BOOLEAN,
            PRIMARY KEY (id)
        )
    """)

    op.execute("""
        CREATE TABLE IF NOT EXISTS technicians (
            user_id UUID NOT NULL REFERENCES users(id),
            name VARCHAR(150) NOT NULL,
            mobile VARCHAR(20) NOT NULL,
            email VARCHAR(200),
            technician_code VARCHAR(30),
            city VARCHAR(100),
            area VARCHAR(200),
            status technicianstatus,
            experience_years INTEGER,
            rating FLOAT,
            total_jobs INTEGER,
            profile_image VARCHAR(500),
            id_proof VARCHAR(500),
            address TEXT,
            id UUID NOT NULL,
            created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
            updated_at TIMESTAMP WITHOUT TIME ZONE,
            is_active BOOLEAN,
            PRIMARY KEY (id),
            UNIQUE (technician_code),
            UNIQUE (user_id)
        )
    """)

    op.execute("""
        CREATE TABLE IF NOT EXISTS customer_addresses (
            customer_id UUID NOT NULL REFERENCES customers(id),
            label VARCHAR(50),
            address_line1 VARCHAR(300) NOT NULL,
            address_line2 VARCHAR(300),
            city VARCHAR(100) NOT NULL,
            state VARCHAR(100) NOT NULL,
            pincode VARCHAR(10) NOT NULL,
            latitude FLOAT,
            longitude FLOAT,
            is_default BOOLEAN,
            id UUID NOT NULL,
            created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
            updated_at TIMESTAMP WITHOUT TIME ZONE,
            is_active BOOLEAN,
            PRIMARY KEY (id)
        )
    """)

    op.execute("""
        CREATE TABLE IF NOT EXISTS technician_skills (
            technician_id UUID NOT NULL REFERENCES technicians(id),
            service_id UUID NOT NULL REFERENCES services(id),
            proficiency VARCHAR(20),
            id UUID NOT NULL,
            created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
            updated_at TIMESTAMP WITHOUT TIME ZONE,
            is_active BOOLEAN,
            PRIMARY KEY (id)
        )
    """)

    op.execute("""
        CREATE TABLE IF NOT EXISTS bookings (
            booking_number VARCHAR(30) NOT NULL,
            customer_id UUID NOT NULL REFERENCES customers(id),
            technician_id UUID REFERENCES technicians(id),
            service_id UUID NOT NULL REFERENCES services(id),
            address_id UUID NOT NULL REFERENCES customer_addresses(id),
            status bookingstatus,
            source bookingsource,
            scheduled_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
            scheduled_slot VARCHAR(30),
            notes TEXT,
            appliance_brand VARCHAR(100),
            appliance_model VARCHAR(100),
            base_amount FLOAT,
            discount_amount FLOAT,
            gst_amount FLOAT,
            total_amount FLOAT,
            priority VARCHAR(20),
            cancelled_reason TEXT,
            id UUID NOT NULL,
            created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
            updated_at TIMESTAMP WITHOUT TIME ZONE,
            is_active BOOLEAN,
            PRIMARY KEY (id),
            UNIQUE (booking_number)
        )
    """)

    op.execute("""
        CREATE TABLE IF NOT EXISTS assignment_history (
            booking_id UUID NOT NULL REFERENCES bookings(id),
            technician_id UUID NOT NULL REFERENCES technicians(id),
            assigned_by UUID REFERENCES users(id),
            assignment_type assignmenttype NOT NULL,
            status assignmentstatus NOT NULL,
            score FLOAT,
            notes TEXT,
            id UUID NOT NULL,
            created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
            updated_at TIMESTAMP WITHOUT TIME ZONE,
            is_active BOOLEAN,
            PRIMARY KEY (id)
        )
    """)

    op.execute("""
        CREATE TABLE IF NOT EXISTS booking_status_logs (
            booking_id UUID NOT NULL REFERENCES bookings(id),
            status bookingstatus NOT NULL,
            changed_by UUID REFERENCES users(id),
            notes TEXT,
            id UUID NOT NULL,
            created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
            updated_at TIMESTAMP WITHOUT TIME ZONE,
            is_active BOOLEAN,
            PRIMARY KEY (id)
        )
    """)

    op.execute("""
        CREATE TABLE IF NOT EXISTS quotations (
            quotation_number VARCHAR(30) NOT NULL,
            booking_id UUID NOT NULL REFERENCES bookings(id),
            created_by UUID NOT NULL REFERENCES users(id),
            original_quotation_id UUID REFERENCES quotations(id),
            version INTEGER,
            status quotationstatus,
            labour_charges FLOAT,
            service_charges FLOAT,
            services_total FLOAT,
            parts_total FLOAT,
            discount_amount FLOAT,
            adjustment_amount FLOAT,
            subtotal_amount FLOAT,
            tax_percent FLOAT,
            tax_amount FLOAT,
            total_amount FLOAT,
            remarks TEXT,
            submitted_at TIMESTAMP WITHOUT TIME ZONE,
            approved_at TIMESTAMP WITHOUT TIME ZONE,
            approved_by UUID REFERENCES users(id),
            rejection_reason TEXT,
            id UUID NOT NULL,
            created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
            updated_at TIMESTAMP WITHOUT TIME ZONE,
            is_active BOOLEAN,
            PRIMARY KEY (id),
            UNIQUE (quotation_number)
        )
    """)

    op.execute("""
        CREATE TABLE IF NOT EXISTS invoices (
            invoice_number VARCHAR(30) NOT NULL,
            booking_id UUID NOT NULL REFERENCES bookings(id),
            quotation_id UUID NOT NULL REFERENCES quotations(id),
            generated_by UUID NOT NULL REFERENCES users(id),
            invoice_type invoicetype,
            status invoicestatus,
            business_name VARCHAR(200),
            business_address TEXT,
            gstin VARCHAR(50),
            taxable_amount FLOAT,
            cgst_amount FLOAT,
            sgst_amount FLOAT,
            igst_amount FLOAT,
            total_amount FLOAT,
            balance_amount FLOAT,
            notes TEXT,
            pdf_url VARCHAR(500),
            sent_email_at TIMESTAMP WITHOUT TIME ZONE,
            sent_whatsapp_at TIMESTAMP WITHOUT TIME ZONE,
            paid_at TIMESTAMP WITHOUT TIME ZONE,
            id UUID NOT NULL,
            created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
            updated_at TIMESTAMP WITHOUT TIME ZONE,
            is_active BOOLEAN,
            PRIMARY KEY (id),
            UNIQUE (invoice_number),
            UNIQUE (quotation_id)
        )
    """)

    op.execute("""
        CREATE TABLE IF NOT EXISTS quotation_part_items (
            quotation_id UUID NOT NULL REFERENCES quotations(id),
            part_name VARCHAR(200) NOT NULL,
            part_source partsource,
            quantity INTEGER,
            unit_price FLOAT,
            total_price FLOAT,
            vendor_name VARCHAR(200),
            bill_number VARCHAR(100),
            notes TEXT,
            id UUID NOT NULL,
            created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
            updated_at TIMESTAMP WITHOUT TIME ZONE,
            is_active BOOLEAN,
            PRIMARY KEY (id)
        )
    """)

    op.execute("""
        CREATE TABLE IF NOT EXISTS quotation_service_items (
            quotation_id UUID NOT NULL REFERENCES quotations(id),
            service_id UUID NOT NULL REFERENCES services(id),
            service_name VARCHAR(200) NOT NULL,
            quantity INTEGER,
            unit_price FLOAT,
            total_price FLOAT,
            id UUID NOT NULL,
            created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
            updated_at TIMESTAMP WITHOUT TIME ZONE,
            is_active BOOLEAN,
            PRIMARY KEY (id)
        )
    """)

    op.execute("""
        CREATE TABLE IF NOT EXISTS quotation_status_logs (
            quotation_id UUID NOT NULL REFERENCES quotations(id),
            status quotationstatus NOT NULL,
            changed_by UUID REFERENCES users(id),
            notes TEXT,
            id UUID NOT NULL,
            created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
            updated_at TIMESTAMP WITHOUT TIME ZONE,
            is_active BOOLEAN,
            PRIMARY KEY (id)
        )
    """)

    op.execute("""
        CREATE TABLE IF NOT EXISTS payment_transactions (
            transaction_number VARCHAR(30) NOT NULL,
            invoice_id UUID NOT NULL REFERENCES invoices(id),
            booking_id UUID NOT NULL REFERENCES bookings(id),
            created_by UUID REFERENCES users(id),
            verified_by UUID REFERENCES users(id),
            method paymentmethod NOT NULL,
            status paymentstatus,
            amount FLOAT,
            currency VARCHAR(10),
            provider_order_id VARCHAR(100),
            provider_payment_id VARCHAR(100),
            provider_signature VARCHAR(255),
            reference_number VARCHAR(100),
            payment_link VARCHAR(500),
            qr_payload TEXT,
            notes TEXT,
            paid_at TIMESTAMP WITHOUT TIME ZONE,
            id UUID NOT NULL,
            created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
            updated_at TIMESTAMP WITHOUT TIME ZONE,
            is_active BOOLEAN,
            PRIMARY KEY (id),
            UNIQUE (transaction_number)
        )
    """)


def downgrade() -> None:
    op.drop_table('payment_transactions')
    op.drop_table('quotation_status_logs')
    op.drop_table('quotation_service_items')
    op.drop_table('quotation_part_items')
    op.drop_table('invoices')
    op.drop_table('quotations')
    op.drop_table('booking_status_logs')
    op.drop_table('assignment_history')
    op.drop_table('bookings')
    op.drop_table('technician_skills')
    op.drop_table('customer_addresses')
    op.drop_table('technicians')
    op.drop_table('services')
    op.drop_table('customers')
    op.drop_table('users')
    op.drop_table('service_categories')
    op.drop_table('assignment_rules')
