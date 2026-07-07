--
-- PostgreSQL database dump
--

\restrict kVaOoktnfHonooi8taZdfzyejaqrYKsr4e3AqiBygdwUaQzSQeuE9aOeb4ermHN

-- Dumped from database version 16.14 (Ubuntu 16.14-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.14 (Ubuntu 16.14-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: assignmentstatus; Type: TYPE; Schema: public; Owner: bibek_user
--

CREATE TYPE public.assignmentstatus AS ENUM (
    'ASSIGNED',
    'ACCEPTED',
    'REJECTED',
    'TIMEOUT',
    'REASSIGNED'
);


ALTER TYPE public.assignmentstatus OWNER TO bibek_user;

--
-- Name: assignmenttype; Type: TYPE; Schema: public; Owner: bibek_user
--

CREATE TYPE public.assignmenttype AS ENUM (
    'AUTO',
    'MANUAL'
);


ALTER TYPE public.assignmenttype OWNER TO bibek_user;

--
-- Name: bookingsource; Type: TYPE; Schema: public; Owner: bibek_user
--

CREATE TYPE public.bookingsource AS ENUM (
    'WEBSITE',
    'MOBILE_APP',
    'CALL_CENTER',
    'WALK_IN',
    'FRANCHISE'
);


ALTER TYPE public.bookingsource OWNER TO bibek_user;

--
-- Name: bookingstatus; Type: TYPE; Schema: public; Owner: bibek_user
--

CREATE TYPE public.bookingstatus AS ENUM (
    'PENDING',
    'CONFIRMED',
    'ASSIGNED',
    'ACCEPTED',
    'EN_ROUTE',
    'ARRIVED',
    'INSPECTING',
    'IN_PROGRESS',
    'COMPLETED',
    'CANCELLED',
    'RESCHEDULED',
    'NO_SHOW',
    'PENDING_VERIFICATION',
    'TECHNICIAN_ACCEPTED',
    'INVOICE_GENERATED',
    'PAYMENT_PENDING',
    'WORK_STARTED',
    'WORK_PAUSED',
    'REFUND_INITIATED',
    'PAID',
    'CLOSED',
    'SETTLED',
    'QUOTATION_APPROVED'
);


ALTER TYPE public.bookingstatus OWNER TO bibek_user;

--
-- Name: callbackstatus; Type: TYPE; Schema: public; Owner: bibek_user
--

CREATE TYPE public.callbackstatus AS ENUM (
    'PENDING',
    'CALLED',
    'RESOLVED',
    'SKIPPED'
);


ALTER TYPE public.callbackstatus OWNER TO bibek_user;

--
-- Name: cashcollectionstatus; Type: TYPE; Schema: public; Owner: bibek_user
--

CREATE TYPE public.cashcollectionstatus AS ENUM (
    'PENDING',
    'COLLECTED'
);


ALTER TYPE public.cashcollectionstatus OWNER TO bibek_user;

--
-- Name: claimstatus; Type: TYPE; Schema: public; Owner: bibek_user
--

CREATE TYPE public.claimstatus AS ENUM (
    'PENDING',
    'APPROVED',
    'REJECTED',
    'RESOLVED'
);


ALTER TYPE public.claimstatus OWNER TO bibek_user;

--
-- Name: escalationstatus; Type: TYPE; Schema: public; Owner: bibek_user
--

CREATE TYPE public.escalationstatus AS ENUM (
    'OPEN',
    'IN_PROGRESS',
    'ESCALATED',
    'RESOLVED',
    'CLOSED'
);


ALTER TYPE public.escalationstatus OWNER TO bibek_user;

--
-- Name: invoicestatus; Type: TYPE; Schema: public; Owner: bibek_user
--

CREATE TYPE public.invoicestatus AS ENUM (
    'DRAFT',
    'GENERATED',
    'PAID',
    'PARTIALLY_PAID',
    'CANCELLED',
    'REFUNDED'
);


ALTER TYPE public.invoicestatus OWNER TO bibek_user;

--
-- Name: invoicetype; Type: TYPE; Schema: public; Owner: bibek_user
--

CREATE TYPE public.invoicetype AS ENUM (
    'GST_B2C',
    'GST_B2B',
    'NON_GST'
);


ALTER TYPE public.invoicetype OWNER TO bibek_user;

--
-- Name: partsource; Type: TYPE; Schema: public; Owner: bibek_user
--

CREATE TYPE public.partsource AS ENUM (
    'OFFICE_STOCK',
    'MARKET_PURCHASE'
);


ALTER TYPE public.partsource OWNER TO bibek_user;

--
-- Name: paymentmethod; Type: TYPE; Schema: public; Owner: bibek_user
--

CREATE TYPE public.paymentmethod AS ENUM (
    'RAZORPAY',
    'UPI',
    'CASH',
    'BANK_TRANSFER',
    'WALLET',
    'PAY_LATER'
);


ALTER TYPE public.paymentmethod OWNER TO bibek_user;

--
-- Name: paymentstatus; Type: TYPE; Schema: public; Owner: bibek_user
--

CREATE TYPE public.paymentstatus AS ENUM (
    'PENDING',
    'SUCCESS',
    'FAILED',
    'REFUNDED',
    'PARTIALLY_REFUNDED',
    'CANCELLED'
);


ALTER TYPE public.paymentstatus OWNER TO bibek_user;

--
-- Name: quotationstatus; Type: TYPE; Schema: public; Owner: bibek_user
--

CREATE TYPE public.quotationstatus AS ENUM (
    'DRAFT',
    'SUBMITTED',
    'APPROVED',
    'REJECTED',
    'REVISED',
    'EXPIRED',
    'CONVERTED_TO_INVOICE'
);


ALTER TYPE public.quotationstatus OWNER TO bibek_user;

--
-- Name: technicianstatus; Type: TYPE; Schema: public; Owner: bibek_user
--

CREATE TYPE public.technicianstatus AS ENUM (
    'ACTIVE',
    'INACTIVE',
    'ON_LEAVE',
    'SUSPENDED'
);


ALTER TYPE public.technicianstatus OWNER TO bibek_user;

--
-- Name: userrole; Type: TYPE; Schema: public; Owner: bibek_user
--

CREATE TYPE public.userrole AS ENUM (
    'SUPER_ADMIN',
    'ADMIN',
    'CCO',
    'TECHNICIAN',
    'CUSTOMER',
    'ACCOUNTANT',
    'INVENTORY_MANAGER'
);


ALTER TYPE public.userrole OWNER TO bibek_user;

--
-- Name: warrantystatus; Type: TYPE; Schema: public; Owner: bibek_user
--

CREATE TYPE public.warrantystatus AS ENUM (
    'ACTIVE',
    'EXPIRED',
    'CLAIMED'
);


ALTER TYPE public.warrantystatus OWNER TO bibek_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO bibek_user;

--
-- Name: amc_plans; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.amc_plans (
    name character varying(100) NOT NULL,
    plan_type character varying(30),
    price double precision NOT NULL,
    duration_months integer,
    visit_count integer NOT NULL,
    description text,
    appliance_types text,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.amc_plans OWNER TO bibek_user;

--
-- Name: amc_subscriptions; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.amc_subscriptions (
    customer_id uuid NOT NULL,
    plan_id uuid NOT NULL,
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone NOT NULL,
    visits_remaining integer,
    amount_paid double precision,
    status character varying(20),
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.amc_subscriptions OWNER TO bibek_user;

--
-- Name: amc_visits; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.amc_visits (
    amc_id uuid NOT NULL,
    scheduled_date timestamp without time zone NOT NULL,
    technician_id uuid,
    notes text,
    status character varying(20),
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.amc_visits OWNER TO bibek_user;

--
-- Name: appliance_brands; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.appliance_brands (
    id uuid NOT NULL,
    name character varying(100) NOT NULL,
    logo_url character varying(500),
    is_active boolean,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.appliance_brands OWNER TO bibek_user;

--
-- Name: appliance_service_history; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.appliance_service_history (
    id uuid NOT NULL,
    appliance_id uuid NOT NULL,
    booking_id uuid,
    service_date timestamp with time zone DEFAULT now(),
    issue_reported text,
    work_done text,
    technician_id uuid,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.appliance_service_history OWNER TO bibek_user;

--
-- Name: appliance_types; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.appliance_types (
    id uuid NOT NULL,
    name character varying(100) NOT NULL,
    category character varying(100),
    appliance_category_id uuid,
    brand_id uuid,
    is_active boolean,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.appliance_types OWNER TO bibek_user;

--
-- Name: areas; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.areas (
    city_id uuid NOT NULL,
    zone_id uuid,
    name character varying(150) NOT NULL,
    pincode character varying(20),
    latitude double precision,
    longitude double precision,
    surge_multiplier double precision,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.areas OWNER TO bibek_user;

--
-- Name: assignment_history; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.assignment_history (
    booking_id uuid NOT NULL,
    technician_id uuid NOT NULL,
    assigned_by uuid,
    assignment_type public.assignmenttype NOT NULL,
    status public.assignmentstatus NOT NULL,
    score double precision,
    notes text,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.assignment_history OWNER TO bibek_user;

--
-- Name: assignment_rules; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.assignment_rules (
    name character varying(100) NOT NULL,
    strategy character varying(100),
    max_active_bookings integer,
    prefer_same_city boolean,
    require_skill_match boolean,
    prefer_high_rating boolean,
    prefer_low_workload boolean,
    response_timeout_minutes integer,
    notes text,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.assignment_rules OWNER TO bibek_user;

--
-- Name: attendance; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.attendance (
    id uuid NOT NULL,
    technician_id uuid NOT NULL,
    date date NOT NULL,
    check_in timestamp with time zone,
    check_out timestamp with time zone,
    check_in_lat double precision,
    check_in_lng double precision,
    status character varying(20),
    notes text,
    approved_by uuid,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.attendance OWNER TO bibek_user;

--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.audit_logs (
    id uuid NOT NULL,
    user_id uuid,
    user_name character varying(150),
    user_role character varying(50),
    action character varying(100) NOT NULL,
    resource_type character varying(100),
    resource_id character varying(200),
    description character varying(500),
    old_data jsonb,
    new_data jsonb,
    ip_address character varying(50),
    user_agent character varying(500),
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE public.audit_logs OWNER TO bibek_user;

--
-- Name: booking_part_usage; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.booking_part_usage (
    id uuid NOT NULL,
    booking_id uuid NOT NULL,
    item_id uuid NOT NULL,
    technician_id uuid,
    warehouse_id uuid,
    quantity integer NOT NULL,
    unit_cost double precision,
    unit_price double precision,
    total_amount double precision,
    notes text,
    created_by uuid,
    is_active boolean,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.booking_part_usage OWNER TO bibek_user;

--
-- Name: booking_status_logs; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.booking_status_logs (
    booking_id uuid NOT NULL,
    status public.bookingstatus NOT NULL,
    changed_by uuid,
    notes text,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.booking_status_logs OWNER TO bibek_user;

--
-- Name: bookings; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.bookings (
    booking_number character varying(30) NOT NULL,
    customer_id uuid NOT NULL,
    technician_id uuid,
    service_id uuid,
    address_id uuid,
    service_name character varying(200),
    address_line text,
    city character varying(100),
    pincode character varying(10),
    coupon_id uuid,
    coupon_code character varying(50),
    coupon_discount double precision,
    status public.bookingstatus,
    source public.bookingsource,
    scheduled_date timestamp without time zone NOT NULL,
    scheduled_slot character varying(30),
    notes text,
    appliance_brand character varying(100),
    appliance_model character varying(100),
    base_amount double precision,
    discount_amount double precision,
    gst_amount double precision,
    total_amount double precision,
    priority character varying(20),
    cancelled_reason text,
    domain_id uuid,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.bookings OWNER TO bibek_user;

--
-- Name: brand_categories; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.brand_categories (
    id uuid NOT NULL,
    brand_id uuid NOT NULL,
    appliance_category_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.brand_categories OWNER TO bibek_user;

--
-- Name: callback_requests; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.callback_requests (
    mobile character varying(20) NOT NULL,
    name character varying(150),
    message text,
    source character varying(30),
    status public.callbackstatus,
    admin_notes text,
    called_at timestamp without time zone,
    domain_id uuid,
    page_url character varying(500),
    ip_address character varying(64),
    user_agent character varying(500),
    location character varying(255),
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.callback_requests OWNER TO bibek_user;

--
-- Name: cash_collection_records; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.cash_collection_records (
    payment_transaction_id uuid NOT NULL,
    booking_id uuid NOT NULL,
    invoice_id uuid NOT NULL,
    technician_id uuid NOT NULL,
    customer_id uuid NOT NULL,
    amount double precision NOT NULL,
    status public.cashcollectionstatus NOT NULL,
    collected_by uuid,
    collected_at timestamp without time zone,
    notes text,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.cash_collection_records OWNER TO bibek_user;

--
-- Name: cities; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.cities (
    name character varying(100) NOT NULL,
    state character varying(100) NOT NULL,
    country character varying(100),
    base_travel_charge double precision,
    surge_multiplier double precision,
    sort_order integer,
    latitude double precision,
    longitude double precision,
    is_serviceable boolean,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.cities OWNER TO bibek_user;

--
-- Name: city_settings; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.city_settings (
    city_id uuid NOT NULL,
    min_booking_amount double precision,
    max_booking_amount double precision,
    booking_advance_days integer,
    cancellation_window_hrs integer,
    auto_assign_enabled boolean,
    notes text,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.city_settings OWNER TO bibek_user;

--
-- Name: commission_group_assignments; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.commission_group_assignments (
    id uuid NOT NULL,
    technician_id uuid NOT NULL,
    group_id uuid NOT NULL,
    assigned_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.commission_group_assignments OWNER TO bibek_user;

--
-- Name: commission_group_part_rules; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.commission_group_part_rules (
    id uuid NOT NULL,
    group_id uuid NOT NULL,
    part_name_match character varying(200),
    part_source_filter character varying(30),
    commission_type character varying(20) NOT NULL,
    rate double precision NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.commission_group_part_rules OWNER TO bibek_user;

--
-- Name: commission_group_rules; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.commission_group_rules (
    id uuid NOT NULL,
    group_id uuid NOT NULL,
    service_id uuid NOT NULL,
    domain_id uuid,
    commission_type character varying(20) NOT NULL,
    rate double precision NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.commission_group_rules OWNER TO bibek_user;

--
-- Name: commission_groups; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.commission_groups (
    id uuid NOT NULL,
    name character varying(150) NOT NULL,
    description character varying(500),
    is_active boolean,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.commission_groups OWNER TO bibek_user;

--
-- Name: commission_rules; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.commission_rules (
    id uuid NOT NULL,
    name character varying(100) NOT NULL,
    role character varying(50),
    commission_type character varying(20),
    rate double precision,
    applies_to character varying(50),
    is_active boolean,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.commission_rules OWNER TO bibek_user;

--
-- Name: commissions; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.commissions (
    id uuid NOT NULL,
    technician_id uuid NOT NULL,
    booking_id uuid,
    rule_id uuid,
    base_amount double precision,
    commission_amount double precision,
    status character varying(20),
    payout_date timestamp with time zone,
    notes text,
    item_type character varying(20),
    item_name character varying(300),
    item_quantity integer,
    part_source character varying(30),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.commissions OWNER TO bibek_user;

--
-- Name: coupon_usages; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.coupon_usages (
    id uuid NOT NULL,
    coupon_id uuid NOT NULL,
    customer_id uuid,
    booking_id uuid,
    discount_amount double precision,
    is_active boolean,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.coupon_usages OWNER TO bibek_user;

--
-- Name: coupons; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.coupons (
    id uuid NOT NULL,
    domain_id uuid,
    code character varying(50) NOT NULL,
    description text,
    discount_type character varying(20),
    discount_value double precision NOT NULL,
    min_order_amount double precision,
    max_discount_amount double precision,
    usage_limit integer,
    used_count integer,
    valid_from timestamp with time zone,
    valid_until timestamp with time zone,
    is_active boolean,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.coupons OWNER TO bibek_user;

--
-- Name: crm_followups; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.crm_followups (
    customer_id uuid NOT NULL,
    created_by uuid NOT NULL,
    subject character varying(200) NOT NULL,
    notes text,
    due_date timestamp without time zone NOT NULL,
    status character varying(20),
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.crm_followups OWNER TO bibek_user;

--
-- Name: crm_notes; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.crm_notes (
    customer_id uuid NOT NULL,
    added_by uuid NOT NULL,
    note text NOT NULL,
    note_type character varying(30),
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.crm_notes OWNER TO bibek_user;

--
-- Name: crm_tasks; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.crm_tasks (
    created_by uuid NOT NULL,
    customer_id uuid,
    title character varying(200) NOT NULL,
    description text,
    due_date timestamp without time zone,
    priority character varying(20),
    status character varying(20),
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.crm_tasks OWNER TO bibek_user;

--
-- Name: customer_addresses; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.customer_addresses (
    customer_id uuid NOT NULL,
    label character varying(50),
    address_line1 character varying(300) NOT NULL,
    address_line2 character varying(300),
    city character varying(100) NOT NULL,
    state character varying(100) NOT NULL,
    pincode character varying(10) NOT NULL,
    latitude double precision,
    longitude double precision,
    is_default boolean,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.customer_addresses OWNER TO bibek_user;

--
-- Name: customer_appliances; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.customer_appliances (
    id uuid NOT NULL,
    customer_id uuid NOT NULL,
    brand_id uuid,
    type_id uuid,
    appliance_category_id uuid,
    category character varying(100),
    model character varying(200),
    serial_number character varying(200),
    purchase_date timestamp with time zone,
    installation_date timestamp with time zone,
    warranty_expiry timestamp with time zone,
    status character varying(30),
    notes text,
    image_url character varying(500),
    is_active boolean,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.customer_appliances OWNER TO bibek_user;

--
-- Name: customers; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.customers (
    user_id uuid NOT NULL,
    name character varying(150) NOT NULL,
    mobile character varying(20) NOT NULL,
    email character varying(200),
    alternate_mobile character varying(20),
    notes text,
    customer_code character varying(30),
    total_bookings character varying(10),
    gst_number character varying(20),
    gst_name character varying(200),
    gst_address text,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.customers OWNER TO bibek_user;

--
-- Name: direct_sales; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.direct_sales (
    id uuid NOT NULL,
    sale_no character varying(30) NOT NULL,
    warehouse_id uuid NOT NULL,
    customer_id uuid,
    customer_name character varying(200),
    customer_mobile character varying(20),
    booking_id uuid,
    items_json text NOT NULL,
    subtotal double precision,
    gst_amount double precision,
    total_amount double precision,
    payment_method character varying(30),
    payment_status character varying(20),
    notes text,
    sold_by uuid,
    is_active boolean,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.direct_sales OWNER TO bibek_user;

--
-- Name: domain_categories; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.domain_categories (
    domain_id uuid NOT NULL,
    category_id uuid NOT NULL,
    sort_order integer,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.domain_categories OWNER TO bibek_user;

--
-- Name: domain_cities; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.domain_cities (
    domain_id uuid NOT NULL,
    city_id uuid NOT NULL,
    sort_order integer,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.domain_cities OWNER TO bibek_user;

--
-- Name: domain_profiles; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.domain_profiles (
    domain_id uuid NOT NULL,
    logo_url character varying(500),
    logo_dark_url character varying(500),
    favicon_url character varying(500),
    og_image_url character varying(500),
    banner_url character varying(500),
    facebook_url character varying(500),
    instagram_url character varying(500),
    twitter_url character varying(500),
    youtube_url character varying(500),
    linkedin_url character varying(500),
    whatsapp_number character varying(20),
    support_phone character varying(30),
    support_email character varying(200),
    office_address text,
    office_city character varying(100),
    office_state character varying(100),
    office_pincode character varying(10),
    office_country character varying(100),
    google_maps_url character varying(500),
    business_legal_name character varying(200),
    gstin character varying(20),
    pan_number character varying(20),
    invoice_prefix character varying(20),
    bank_account_name character varying(200),
    bank_account_number character varying(50),
    bank_ifsc character varying(20),
    bank_name character varying(100),
    bank_branch character varying(200),
    upi_id character varying(100),
    tagline character varying(300),
    about_short text,
    copyright_text character varying(300),
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.domain_profiles OWNER TO bibek_user;

--
-- Name: domain_seo; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.domain_seo (
    domain_id uuid NOT NULL,
    meta_title character varying(200),
    meta_description text,
    meta_keywords text,
    og_title character varying(200),
    og_description text,
    og_image_url character varying(500),
    canonical_url character varying(500),
    robots character varying(100),
    schema_json text,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.domain_seo OWNER TO bibek_user;

--
-- Name: domain_service_overrides; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.domain_service_overrides (
    domain_service_id uuid NOT NULL,
    image_url character varying(500),
    thumbnail_url character varying(500),
    meta_title character varying(200),
    meta_description text,
    meta_keywords text,
    og_title character varying(200),
    og_description text,
    og_image_url character varying(500),
    includes_json text,
    excludes_json text,
    faqs_json text,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.domain_service_overrides OWNER TO bibek_user;

--
-- Name: domain_services; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.domain_services (
    domain_id uuid NOT NULL,
    service_id uuid NOT NULL,
    is_featured boolean,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.domain_services OWNER TO bibek_user;

--
-- Name: domains; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.domains (
    name character varying(150) NOT NULL,
    slug character varying(100) NOT NULL,
    description text,
    logo_url character varying(500),
    primary_color character varying(20),
    meta_title character varying(200),
    meta_desc text,
    sort_order integer,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.domains OWNER TO bibek_user;

--
-- Name: escalations; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.escalations (
    created_by uuid NOT NULL,
    booking_id uuid,
    subject character varying(300) NOT NULL,
    description text NOT NULL,
    priority character varying(20),
    status public.escalationstatus,
    assigned_to uuid,
    resolved_by uuid,
    resolved_at timestamp without time zone,
    resolution_notes text,
    escalation_level integer,
    escalation_notes text,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.escalations OWNER TO bibek_user;

--
-- Name: franchises; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.franchises (
    id uuid NOT NULL,
    name character varying(200) NOT NULL,
    owner_user_id uuid,
    city character varying(100),
    state character varying(100),
    address text,
    phone character varying(20),
    email character varying(200),
    commission_rate double precision,
    is_active boolean,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.franchises OWNER TO bibek_user;

--
-- Name: gst_settings; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.gst_settings (
    gst_enabled boolean NOT NULL,
    default_rate double precision NOT NULL,
    allow_b2b boolean NOT NULL,
    allow_b2c boolean NOT NULL,
    allow_non_gst boolean NOT NULL,
    gstin_validation_enabled boolean NOT NULL,
    company_gstin character varying(50),
    company_name character varying(200),
    company_address text,
    hsn_code character varying(30),
    invoice_prefix character varying(20) NOT NULL,
    state_code character varying(10),
    updated_by uuid,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.gst_settings OWNER TO bibek_user;

--
-- Name: inventory_brands; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.inventory_brands (
    id uuid NOT NULL,
    name character varying(100) NOT NULL,
    is_active boolean,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.inventory_brands OWNER TO bibek_user;

--
-- Name: inventory_categories; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.inventory_categories (
    id uuid NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    icon character varying(10),
    sort_order integer,
    is_active boolean,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.inventory_categories OWNER TO bibek_user;

--
-- Name: inventory_items; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.inventory_items (
    id uuid NOT NULL,
    name character varying(200) NOT NULL,
    sku character varying(100),
    barcode character varying(100),
    category_id uuid,
    brand_id uuid,
    unit character varying(20),
    description text,
    image_url character varying(500),
    hsn_code character varying(20),
    gst_percent double precision,
    cost_price double precision,
    selling_price double precision,
    mrp double precision,
    current_stock integer,
    reserved_stock integer,
    min_stock_level integer,
    reorder_qty integer,
    is_active boolean,
    is_consumable boolean,
    is_serialised boolean,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.inventory_items OWNER TO bibek_user;

--
-- Name: inventory_reorder_rules; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.inventory_reorder_rules (
    id uuid NOT NULL,
    item_id uuid NOT NULL,
    warehouse_id uuid,
    reorder_level integer NOT NULL,
    reorder_qty integer NOT NULL,
    preferred_vendor_id uuid,
    is_active boolean,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.inventory_reorder_rules OWNER TO bibek_user;

--
-- Name: invoices; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.invoices (
    invoice_number character varying(30) NOT NULL,
    booking_id uuid NOT NULL,
    domain_id uuid,
    quotation_id uuid NOT NULL,
    generated_by uuid NOT NULL,
    invoice_type public.invoicetype,
    status public.invoicestatus,
    business_name character varying(200),
    business_address text,
    gstin character varying(50),
    taxable_amount double precision,
    cgst_amount double precision,
    sgst_amount double precision,
    igst_amount double precision,
    total_amount double precision,
    balance_amount double precision,
    notes text,
    pdf_url character varying(500),
    sent_email_at timestamp without time zone,
    sent_whatsapp_at timestamp without time zone,
    paid_at timestamp without time zone,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.invoices OWNER TO bibek_user;

--
-- Name: leave_requests; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.leave_requests (
    id uuid NOT NULL,
    technician_id uuid NOT NULL,
    leave_type character varying(30),
    from_date date NOT NULL,
    to_date date NOT NULL,
    reason text,
    status character varying(20),
    approved_by uuid,
    reviewed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.leave_requests OWNER TO bibek_user;

--
-- Name: notification_templates; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.notification_templates (
    id uuid NOT NULL,
    name character varying(100) NOT NULL,
    title character varying(200) NOT NULL,
    body text NOT NULL,
    channel character varying(20),
    is_active boolean,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.notification_templates OWNER TO bibek_user;

--
-- Name: notifications; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.notifications (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    title character varying(200) NOT NULL,
    body text NOT NULL,
    channel character varying(20),
    is_read boolean,
    data jsonb,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.notifications OWNER TO bibek_user;

--
-- Name: payment_transactions; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.payment_transactions (
    transaction_number character varying(30) NOT NULL,
    invoice_id uuid NOT NULL,
    booking_id uuid NOT NULL,
    created_by uuid,
    verified_by uuid,
    method public.paymentmethod NOT NULL,
    status public.paymentstatus,
    amount double precision,
    currency character varying(10),
    provider_order_id character varying(100),
    provider_payment_id character varying(100),
    provider_signature character varying(255),
    reference_number character varying(100),
    payment_link character varying(500),
    qr_payload text,
    notes text,
    paid_at timestamp without time zone,
    collected_by_role character varying(30),
    cash_collection_status public.cashcollectionstatus,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean,
    due_collect_at timestamp with time zone,
    last_reminder_at timestamp with time zone
);


ALTER TABLE public.payment_transactions OWNER TO bibek_user;

--
-- Name: permissions; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.permissions (
    code character varying(100) NOT NULL,
    module character varying(50) NOT NULL,
    name character varying(150) NOT NULL,
    description text,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.permissions OWNER TO bibek_user;

--
-- Name: quotation_appliances; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.quotation_appliances (
    quotation_id uuid NOT NULL,
    appliance_id uuid,
    appliance_label character varying(300) NOT NULL,
    is_repeat_complaint boolean,
    repeat_booking_id uuid,
    repeat_confirmed_at timestamp without time zone,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.quotation_appliances OWNER TO bibek_user;

--
-- Name: quotation_part_items; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.quotation_part_items (
    quotation_id uuid NOT NULL,
    part_name character varying(200) NOT NULL,
    part_source public.partsource,
    quantity integer,
    unit_price double precision,
    purchase_price double precision,
    total_price double precision,
    vendor_name character varying(200),
    bill_number character varying(100),
    notes text,
    inventory_item_id uuid,
    is_pending_verify integer,
    is_repeat_complaint boolean,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.quotation_part_items OWNER TO bibek_user;

--
-- Name: quotation_service_items; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.quotation_service_items (
    quotation_id uuid NOT NULL,
    service_id uuid,
    service_name character varying(200) NOT NULL,
    quantity integer,
    unit_price double precision,
    total_price double precision,
    appliance_label character varying(300),
    is_repeat_complaint boolean,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean,
    is_pending_verify integer DEFAULT 0 NOT NULL,
    custom_service_name text,
    tech_commission_override double precision
);


ALTER TABLE public.quotation_service_items OWNER TO bibek_user;

--
-- Name: quotation_status_logs; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.quotation_status_logs (
    quotation_id uuid NOT NULL,
    status public.quotationstatus NOT NULL,
    changed_by uuid,
    notes text,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.quotation_status_logs OWNER TO bibek_user;

--
-- Name: quotations; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.quotations (
    quotation_number character varying(30) NOT NULL,
    booking_id uuid NOT NULL,
    domain_id uuid,
    created_by uuid NOT NULL,
    original_quotation_id uuid,
    version integer,
    status public.quotationstatus,
    labour_charges double precision,
    service_charges double precision,
    services_total double precision,
    parts_total double precision,
    discount_amount double precision,
    adjustment_amount double precision,
    subtotal_amount double precision,
    tax_percent double precision,
    tax_amount double precision,
    total_amount double precision,
    remarks text,
    coupon_id uuid,
    coupon_code character varying(50),
    coupon_discount double precision,
    submitted_at timestamp without time zone,
    approved_at timestamp without time zone,
    approved_by uuid,
    rejection_reason text,
    tax_mode character varying(10) NOT NULL,
    customer_gst_number character varying(20),
    customer_gst_name character varying(200),
    customer_gst_address text,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.quotations OWNER TO bibek_user;

--
-- Name: referral_codes; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.referral_codes (
    user_id uuid NOT NULL,
    code character varying(20) NOT NULL,
    total_referrals integer,
    total_earned double precision,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.referral_codes OWNER TO bibek_user;

--
-- Name: referral_rewards; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.referral_rewards (
    user_id uuid NOT NULL,
    referral_id uuid,
    amount double precision NOT NULL,
    type character varying(30),
    status character varying(20),
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.referral_rewards OWNER TO bibek_user;

--
-- Name: referrals; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.referrals (
    referrer_id uuid NOT NULL,
    referee_id uuid NOT NULL,
    reward_amount double precision,
    status character varying(20),
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.referrals OWNER TO bibek_user;

--
-- Name: refunds; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.refunds (
    id uuid NOT NULL,
    booking_id uuid NOT NULL,
    payment_id uuid,
    amount double precision NOT NULL,
    reason text NOT NULL,
    status character varying(20),
    refund_method character varying(30),
    processed_by uuid,
    processed_at timestamp with time zone,
    gateway_refund_id character varying(200),
    notes text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.refunds OWNER TO bibek_user;

--
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.role_permissions (
    role_id uuid NOT NULL,
    permission_id uuid NOT NULL,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.role_permissions OWNER TO bibek_user;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.roles (
    code character varying(50) NOT NULL,
    name character varying(150) NOT NULL,
    description text,
    is_system boolean NOT NULL,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.roles OWNER TO bibek_user;

--
-- Name: service_categories; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.service_categories (
    name character varying(150) NOT NULL,
    description text,
    icon character varying(500),
    sort_order integer,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.service_categories OWNER TO bibek_user;

--
-- Name: service_city_prices; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.service_city_prices (
    service_id uuid NOT NULL,
    city_id uuid NOT NULL,
    price double precision NOT NULL,
    is_available boolean,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.service_city_prices OWNER TO bibek_user;

--
-- Name: services; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.services (
    category_id uuid NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    base_price double precision NOT NULL,
    gst_percent double precision,
    duration_mins integer,
    is_visible boolean,
    sort_order integer,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean,
    is_pending_verify integer DEFAULT 0 NOT NULL,
    suggested_by_tech uuid
);


ALTER TABLE public.services OWNER TO bibek_user;

--
-- Name: sla_breaches; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.sla_breaches (
    id uuid NOT NULL,
    booking_id uuid NOT NULL,
    policy_id uuid,
    breach_type character varying(30),
    breached_at timestamp with time zone DEFAULT now(),
    notes text
);


ALTER TABLE public.sla_breaches OWNER TO bibek_user;

--
-- Name: sla_policies; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.sla_policies (
    id uuid NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    response_time_minutes integer,
    resolution_time_hours integer,
    priority character varying(20),
    is_active boolean,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.sla_policies OWNER TO bibek_user;

--
-- Name: stock_movements; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.stock_movements (
    id uuid NOT NULL,
    item_id uuid NOT NULL,
    movement_type character varying(30) NOT NULL,
    quantity integer NOT NULL,
    from_warehouse_id uuid,
    to_warehouse_id uuid,
    technician_id uuid,
    booking_id uuid,
    reference_no character varying(100),
    batch_no character varying(100),
    reason character varying(300),
    notes text,
    unit_cost double precision,
    performed_by uuid,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.stock_movements OWNER TO bibek_user;

--
-- Name: system_settings; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.system_settings (
    "group" character varying(50) NOT NULL,
    key character varying(100) NOT NULL,
    value text,
    is_secret boolean,
    label character varying(200),
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.system_settings OWNER TO bibek_user;

--
-- Name: technician_availability; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.technician_availability (
    technician_id uuid NOT NULL,
    day_of_week integer NOT NULL,
    start_time character varying(8) NOT NULL,
    end_time character varying(8) NOT NULL,
    is_available boolean,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.technician_availability OWNER TO bibek_user;

--
-- Name: technician_ratings; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.technician_ratings (
    technician_id uuid NOT NULL,
    booking_id uuid,
    customer_id uuid,
    rating double precision NOT NULL,
    review text,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.technician_ratings OWNER TO bibek_user;

--
-- Name: technician_skills; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.technician_skills (
    technician_id uuid NOT NULL,
    service_id uuid NOT NULL,
    proficiency character varying(20),
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.technician_skills OWNER TO bibek_user;

--
-- Name: technician_stock; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.technician_stock (
    id uuid NOT NULL,
    technician_id uuid NOT NULL,
    item_id uuid NOT NULL,
    quantity integer,
    assigned_qty integer,
    consumed_qty integer,
    returned_qty integer,
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.technician_stock OWNER TO bibek_user;

--
-- Name: technician_stock_logs; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.technician_stock_logs (
    id uuid NOT NULL,
    technician_id uuid NOT NULL,
    item_id uuid NOT NULL,
    booking_id uuid,
    warehouse_id uuid,
    status character varying(30) NOT NULL,
    quantity integer NOT NULL,
    notes text,
    performed_by uuid,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.technician_stock_logs OWNER TO bibek_user;

--
-- Name: technicians; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.technicians (
    user_id uuid NOT NULL,
    name character varying(150) NOT NULL,
    mobile character varying(20) NOT NULL,
    email character varying(200),
    alternate_mobile character varying(20),
    technician_code character varying(30),
    dob date,
    gender character varying(10),
    city character varying(100),
    area character varying(200),
    pincode character varying(10),
    address text,
    experience_years integer,
    status public.technicianstatus,
    rating double precision,
    total_jobs integer,
    profile_image character varying(500),
    id_proof character varying(500),
    identity_type character varying(50),
    identity_number character varying(50),
    emergency_contact_name character varying(150),
    emergency_contact_mobile character varying(20),
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean,
    is_online boolean DEFAULT false NOT NULL,
    fcm_token character varying(500),
    last_lat double precision,
    last_lng double precision,
    last_seen_at timestamp with time zone,
    auto_assign_eligible boolean DEFAULT true NOT NULL
);


ALTER TABLE public.technicians OWNER TO bibek_user;

--
-- Name: tracking_locations; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.tracking_locations (
    technician_id uuid NOT NULL,
    booking_id uuid,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    accuracy double precision,
    speed double precision,
    heading double precision,
    source character varying(50) NOT NULL,
    recorded_at timestamp without time zone NOT NULL,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.tracking_locations OWNER TO bibek_user;

--
-- Name: transfer_challans; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.transfer_challans (
    id uuid NOT NULL,
    challan_no character varying(30) NOT NULL,
    from_warehouse_id uuid,
    to_warehouse_id uuid,
    to_technician_id uuid,
    items_json text NOT NULL,
    total_qty integer,
    total_value double precision,
    status character varying(20),
    notes text,
    reference_no character varying(100),
    dispatched_at timestamp with time zone,
    received_at timestamp with time zone,
    created_by uuid,
    received_by uuid,
    is_active boolean,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.transfer_challans OWNER TO bibek_user;

--
-- Name: user_permissions; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.user_permissions (
    user_id uuid NOT NULL,
    permission_id uuid NOT NULL,
    is_granted boolean NOT NULL,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.user_permissions OWNER TO bibek_user;

--
-- Name: users; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.users (
    name character varying(150) NOT NULL,
    mobile character varying(20) NOT NULL,
    email character varying(200),
    password_hash character varying(255),
    role public.userrole NOT NULL,
    city character varying(100),
    profile_image character varying(500),
    is_verified boolean,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean,
    id_proof_url character varying(500),
    address_proof_url character varying(500),
    id_proof_type character varying(50),
    address_proof_type character varying(50),
    fcm_token character varying(500),
    firebase_uid character varying(128)
);


ALTER TABLE public.users OWNER TO bibek_user;

--
-- Name: vendor_transactions; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.vendor_transactions (
    vendor_id uuid NOT NULL,
    amount double precision NOT NULL,
    type character varying(30) NOT NULL,
    notes text,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.vendor_transactions OWNER TO bibek_user;

--
-- Name: vendors; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.vendors (
    name character varying(200) NOT NULL,
    contact_person character varying(150),
    mobile character varying(20),
    email character varying(200),
    gstin character varying(20),
    address text,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.vendors OWNER TO bibek_user;

--
-- Name: wallet_transactions; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.wallet_transactions (
    id uuid NOT NULL,
    wallet_id uuid NOT NULL,
    transaction_type character varying(30),
    amount double precision NOT NULL,
    balance_before double precision,
    balance_after double precision,
    reference_id character varying(200),
    description text,
    status character varying(20),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.wallet_transactions OWNER TO bibek_user;

--
-- Name: wallets; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.wallets (
    id uuid NOT NULL,
    user_id uuid,
    technician_id uuid,
    balance double precision,
    total_earned double precision,
    total_withdrawn double precision,
    is_active boolean,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.wallets OWNER TO bibek_user;

--
-- Name: warehouse_stock; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.warehouse_stock (
    id uuid NOT NULL,
    warehouse_id uuid NOT NULL,
    item_id uuid NOT NULL,
    quantity integer,
    reserved_qty integer,
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.warehouse_stock OWNER TO bibek_user;

--
-- Name: warehouses; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.warehouses (
    id uuid NOT NULL,
    name character varying(200) NOT NULL,
    code character varying(20),
    address text,
    city_id uuid,
    city character varying(100),
    manager_id uuid,
    phone character varying(20),
    is_active boolean,
    is_default boolean,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.warehouses OWNER TO bibek_user;

--
-- Name: warranties; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.warranties (
    customer_id uuid NOT NULL,
    booking_id uuid,
    warranty_type character varying(30),
    description text NOT NULL,
    expiry_date timestamp without time zone NOT NULL,
    parts_covered text,
    status public.warrantystatus,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.warranties OWNER TO bibek_user;

--
-- Name: warranty_claims; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.warranty_claims (
    warranty_id uuid NOT NULL,
    claimed_by uuid NOT NULL,
    booking_id uuid,
    description text NOT NULL,
    status public.claimstatus,
    approved_by uuid,
    rejected_by uuid,
    notes text,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.warranty_claims OWNER TO bibek_user;

--
-- Name: zones; Type: TABLE; Schema: public; Owner: bibek_user
--

CREATE TABLE public.zones (
    city_id uuid NOT NULL,
    name character varying(150) NOT NULL,
    description text,
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.zones OWNER TO bibek_user;

--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: amc_plans amc_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.amc_plans
    ADD CONSTRAINT amc_plans_pkey PRIMARY KEY (id);


--
-- Name: amc_subscriptions amc_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.amc_subscriptions
    ADD CONSTRAINT amc_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: amc_visits amc_visits_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.amc_visits
    ADD CONSTRAINT amc_visits_pkey PRIMARY KEY (id);


--
-- Name: appliance_brands appliance_brands_name_key; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.appliance_brands
    ADD CONSTRAINT appliance_brands_name_key UNIQUE (name);


--
-- Name: appliance_brands appliance_brands_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.appliance_brands
    ADD CONSTRAINT appliance_brands_pkey PRIMARY KEY (id);


--
-- Name: appliance_service_history appliance_service_history_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.appliance_service_history
    ADD CONSTRAINT appliance_service_history_pkey PRIMARY KEY (id);


--
-- Name: appliance_types appliance_types_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.appliance_types
    ADD CONSTRAINT appliance_types_pkey PRIMARY KEY (id);


--
-- Name: areas areas_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (id);


--
-- Name: assignment_history assignment_history_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.assignment_history
    ADD CONSTRAINT assignment_history_pkey PRIMARY KEY (id);


--
-- Name: assignment_rules assignment_rules_name_key; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.assignment_rules
    ADD CONSTRAINT assignment_rules_name_key UNIQUE (name);


--
-- Name: assignment_rules assignment_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.assignment_rules
    ADD CONSTRAINT assignment_rules_pkey PRIMARY KEY (id);


--
-- Name: attendance attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_pkey PRIMARY KEY (id);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: booking_part_usage booking_part_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.booking_part_usage
    ADD CONSTRAINT booking_part_usage_pkey PRIMARY KEY (id);


--
-- Name: booking_status_logs booking_status_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.booking_status_logs
    ADD CONSTRAINT booking_status_logs_pkey PRIMARY KEY (id);


--
-- Name: bookings bookings_booking_number_key; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_booking_number_key UNIQUE (booking_number);


--
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- Name: brand_categories brand_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.brand_categories
    ADD CONSTRAINT brand_categories_pkey PRIMARY KEY (id);


--
-- Name: callback_requests callback_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.callback_requests
    ADD CONSTRAINT callback_requests_pkey PRIMARY KEY (id);


--
-- Name: cash_collection_records cash_collection_records_payment_transaction_id_key; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.cash_collection_records
    ADD CONSTRAINT cash_collection_records_payment_transaction_id_key UNIQUE (payment_transaction_id);


--
-- Name: cash_collection_records cash_collection_records_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.cash_collection_records
    ADD CONSTRAINT cash_collection_records_pkey PRIMARY KEY (id);


--
-- Name: cities cities_name_key; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_name_key UNIQUE (name);


--
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: city_settings city_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.city_settings
    ADD CONSTRAINT city_settings_pkey PRIMARY KEY (id);


--
-- Name: commission_group_assignments commission_group_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.commission_group_assignments
    ADD CONSTRAINT commission_group_assignments_pkey PRIMARY KEY (id);


--
-- Name: commission_group_assignments commission_group_assignments_technician_id_group_id_key; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.commission_group_assignments
    ADD CONSTRAINT commission_group_assignments_technician_id_group_id_key UNIQUE (technician_id, group_id);


--
-- Name: commission_group_part_rules commission_group_part_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.commission_group_part_rules
    ADD CONSTRAINT commission_group_part_rules_pkey PRIMARY KEY (id);


--
-- Name: commission_group_rules commission_group_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.commission_group_rules
    ADD CONSTRAINT commission_group_rules_pkey PRIMARY KEY (id);


--
-- Name: commission_groups commission_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.commission_groups
    ADD CONSTRAINT commission_groups_pkey PRIMARY KEY (id);


--
-- Name: commission_rules commission_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.commission_rules
    ADD CONSTRAINT commission_rules_pkey PRIMARY KEY (id);


--
-- Name: commissions commissions_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.commissions
    ADD CONSTRAINT commissions_pkey PRIMARY KEY (id);


--
-- Name: coupon_usages coupon_usages_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.coupon_usages
    ADD CONSTRAINT coupon_usages_pkey PRIMARY KEY (id);


--
-- Name: coupons coupons_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.coupons
    ADD CONSTRAINT coupons_pkey PRIMARY KEY (id);


--
-- Name: crm_followups crm_followups_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.crm_followups
    ADD CONSTRAINT crm_followups_pkey PRIMARY KEY (id);


--
-- Name: crm_notes crm_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.crm_notes
    ADD CONSTRAINT crm_notes_pkey PRIMARY KEY (id);


--
-- Name: crm_tasks crm_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.crm_tasks
    ADD CONSTRAINT crm_tasks_pkey PRIMARY KEY (id);


--
-- Name: customer_addresses customer_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.customer_addresses
    ADD CONSTRAINT customer_addresses_pkey PRIMARY KEY (id);


--
-- Name: customer_appliances customer_appliances_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.customer_appliances
    ADD CONSTRAINT customer_appliances_pkey PRIMARY KEY (id);


--
-- Name: customers customers_customer_code_key; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_customer_code_key UNIQUE (customer_code);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: customers customers_user_id_key; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_user_id_key UNIQUE (user_id);


--
-- Name: direct_sales direct_sales_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.direct_sales
    ADD CONSTRAINT direct_sales_pkey PRIMARY KEY (id);


--
-- Name: domain_categories domain_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.domain_categories
    ADD CONSTRAINT domain_categories_pkey PRIMARY KEY (id);


--
-- Name: domain_cities domain_cities_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.domain_cities
    ADD CONSTRAINT domain_cities_pkey PRIMARY KEY (id);


--
-- Name: domain_profiles domain_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.domain_profiles
    ADD CONSTRAINT domain_profiles_pkey PRIMARY KEY (id);


--
-- Name: domain_seo domain_seo_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.domain_seo
    ADD CONSTRAINT domain_seo_pkey PRIMARY KEY (id);


--
-- Name: domain_service_overrides domain_service_overrides_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.domain_service_overrides
    ADD CONSTRAINT domain_service_overrides_pkey PRIMARY KEY (id);


--
-- Name: domain_services domain_services_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.domain_services
    ADD CONSTRAINT domain_services_pkey PRIMARY KEY (id);


--
-- Name: domains domains_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.domains
    ADD CONSTRAINT domains_pkey PRIMARY KEY (id);


--
-- Name: domains domains_slug_key; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.domains
    ADD CONSTRAINT domains_slug_key UNIQUE (slug);


--
-- Name: escalations escalations_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.escalations
    ADD CONSTRAINT escalations_pkey PRIMARY KEY (id);


--
-- Name: franchises franchises_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.franchises
    ADD CONSTRAINT franchises_pkey PRIMARY KEY (id);


--
-- Name: gst_settings gst_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.gst_settings
    ADD CONSTRAINT gst_settings_pkey PRIMARY KEY (id);


--
-- Name: inventory_brands inventory_brands_name_key; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.inventory_brands
    ADD CONSTRAINT inventory_brands_name_key UNIQUE (name);


--
-- Name: inventory_brands inventory_brands_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.inventory_brands
    ADD CONSTRAINT inventory_brands_pkey PRIMARY KEY (id);


--
-- Name: inventory_categories inventory_categories_name_key; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.inventory_categories
    ADD CONSTRAINT inventory_categories_name_key UNIQUE (name);


--
-- Name: inventory_categories inventory_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.inventory_categories
    ADD CONSTRAINT inventory_categories_pkey PRIMARY KEY (id);


--
-- Name: inventory_items inventory_items_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT inventory_items_pkey PRIMARY KEY (id);


--
-- Name: inventory_reorder_rules inventory_reorder_rules_item_id_key; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.inventory_reorder_rules
    ADD CONSTRAINT inventory_reorder_rules_item_id_key UNIQUE (item_id);


--
-- Name: inventory_reorder_rules inventory_reorder_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.inventory_reorder_rules
    ADD CONSTRAINT inventory_reorder_rules_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_invoice_number_key; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_invoice_number_key UNIQUE (invoice_number);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_quotation_id_key; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_quotation_id_key UNIQUE (quotation_id);


--
-- Name: leave_requests leave_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_pkey PRIMARY KEY (id);


--
-- Name: notification_templates notification_templates_name_key; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.notification_templates
    ADD CONSTRAINT notification_templates_name_key UNIQUE (name);


--
-- Name: notification_templates notification_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.notification_templates
    ADD CONSTRAINT notification_templates_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: payment_transactions payment_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.payment_transactions
    ADD CONSTRAINT payment_transactions_pkey PRIMARY KEY (id);


--
-- Name: payment_transactions payment_transactions_transaction_number_key; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.payment_transactions
    ADD CONSTRAINT payment_transactions_transaction_number_key UNIQUE (transaction_number);


--
-- Name: permissions permissions_code_key; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_code_key UNIQUE (code);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: quotation_appliances quotation_appliances_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.quotation_appliances
    ADD CONSTRAINT quotation_appliances_pkey PRIMARY KEY (id);


--
-- Name: quotation_part_items quotation_part_items_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.quotation_part_items
    ADD CONSTRAINT quotation_part_items_pkey PRIMARY KEY (id);


--
-- Name: quotation_service_items quotation_service_items_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.quotation_service_items
    ADD CONSTRAINT quotation_service_items_pkey PRIMARY KEY (id);


--
-- Name: quotation_status_logs quotation_status_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.quotation_status_logs
    ADD CONSTRAINT quotation_status_logs_pkey PRIMARY KEY (id);


--
-- Name: quotations quotations_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_pkey PRIMARY KEY (id);


--
-- Name: quotations quotations_quotation_number_key; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_quotation_number_key UNIQUE (quotation_number);


--
-- Name: referral_codes referral_codes_code_key; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.referral_codes
    ADD CONSTRAINT referral_codes_code_key UNIQUE (code);


--
-- Name: referral_codes referral_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.referral_codes
    ADD CONSTRAINT referral_codes_pkey PRIMARY KEY (id);


--
-- Name: referral_codes referral_codes_user_id_key; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.referral_codes
    ADD CONSTRAINT referral_codes_user_id_key UNIQUE (user_id);


--
-- Name: referral_rewards referral_rewards_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.referral_rewards
    ADD CONSTRAINT referral_rewards_pkey PRIMARY KEY (id);


--
-- Name: referrals referrals_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.referrals
    ADD CONSTRAINT referrals_pkey PRIMARY KEY (id);


--
-- Name: refunds refunds_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.refunds
    ADD CONSTRAINT refunds_pkey PRIMARY KEY (id);


--
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (id);


--
-- Name: roles roles_code_key; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_code_key UNIQUE (code);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: service_categories service_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.service_categories
    ADD CONSTRAINT service_categories_pkey PRIMARY KEY (id);


--
-- Name: service_city_prices service_city_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.service_city_prices
    ADD CONSTRAINT service_city_prices_pkey PRIMARY KEY (id);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: sla_breaches sla_breaches_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.sla_breaches
    ADD CONSTRAINT sla_breaches_pkey PRIMARY KEY (id);


--
-- Name: sla_policies sla_policies_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.sla_policies
    ADD CONSTRAINT sla_policies_pkey PRIMARY KEY (id);


--
-- Name: stock_movements stock_movements_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_pkey PRIMARY KEY (id);


--
-- Name: system_settings system_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT system_settings_pkey PRIMARY KEY (id);


--
-- Name: technician_availability technician_availability_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.technician_availability
    ADD CONSTRAINT technician_availability_pkey PRIMARY KEY (id);


--
-- Name: technician_ratings technician_ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.technician_ratings
    ADD CONSTRAINT technician_ratings_pkey PRIMARY KEY (id);


--
-- Name: technician_skills technician_skills_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.technician_skills
    ADD CONSTRAINT technician_skills_pkey PRIMARY KEY (id);


--
-- Name: technician_stock_logs technician_stock_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.technician_stock_logs
    ADD CONSTRAINT technician_stock_logs_pkey PRIMARY KEY (id);


--
-- Name: technician_stock technician_stock_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.technician_stock
    ADD CONSTRAINT technician_stock_pkey PRIMARY KEY (id);


--
-- Name: technicians technicians_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.technicians
    ADD CONSTRAINT technicians_pkey PRIMARY KEY (id);


--
-- Name: technicians technicians_technician_code_key; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.technicians
    ADD CONSTRAINT technicians_technician_code_key UNIQUE (technician_code);


--
-- Name: technicians technicians_user_id_key; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.technicians
    ADD CONSTRAINT technicians_user_id_key UNIQUE (user_id);


--
-- Name: tracking_locations tracking_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.tracking_locations
    ADD CONSTRAINT tracking_locations_pkey PRIMARY KEY (id);


--
-- Name: transfer_challans transfer_challans_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.transfer_challans
    ADD CONSTRAINT transfer_challans_pkey PRIMARY KEY (id);


--
-- Name: city_settings uq_city_settings; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.city_settings
    ADD CONSTRAINT uq_city_settings UNIQUE (city_id);


--
-- Name: domain_categories uq_domain_category; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.domain_categories
    ADD CONSTRAINT uq_domain_category UNIQUE (domain_id, category_id);


--
-- Name: domain_cities uq_domain_city; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.domain_cities
    ADD CONSTRAINT uq_domain_city UNIQUE (domain_id, city_id);


--
-- Name: domain_profiles uq_domain_profile; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.domain_profiles
    ADD CONSTRAINT uq_domain_profile UNIQUE (domain_id);


--
-- Name: domain_seo uq_domain_seo; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.domain_seo
    ADD CONSTRAINT uq_domain_seo UNIQUE (domain_id);


--
-- Name: domain_services uq_domain_service; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.domain_services
    ADD CONSTRAINT uq_domain_service UNIQUE (domain_id, service_id);


--
-- Name: domain_service_overrides uq_domain_service_override; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.domain_service_overrides
    ADD CONSTRAINT uq_domain_service_override UNIQUE (domain_service_id);


--
-- Name: role_permissions uq_role_permission; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT uq_role_permission UNIQUE (role_id, permission_id);


--
-- Name: service_city_prices uq_service_city_price; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.service_city_prices
    ADD CONSTRAINT uq_service_city_price UNIQUE (service_id, city_id);


--
-- Name: system_settings uq_setting_group_key; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT uq_setting_group_key UNIQUE ("group", key);


--
-- Name: technician_stock uq_tech_item; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.technician_stock
    ADD CONSTRAINT uq_tech_item UNIQUE (technician_id, item_id);


--
-- Name: user_permissions uq_user_permission; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.user_permissions
    ADD CONSTRAINT uq_user_permission UNIQUE (user_id, permission_id);


--
-- Name: users uq_users_firebase_uid; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uq_users_firebase_uid UNIQUE (firebase_uid);


--
-- Name: warehouse_stock uq_wh_item; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.warehouse_stock
    ADD CONSTRAINT uq_wh_item UNIQUE (warehouse_id, item_id);


--
-- Name: user_permissions user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.user_permissions
    ADD CONSTRAINT user_permissions_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_mobile_key; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_mobile_key UNIQUE (mobile);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vendor_transactions vendor_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.vendor_transactions
    ADD CONSTRAINT vendor_transactions_pkey PRIMARY KEY (id);


--
-- Name: vendors vendors_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_pkey PRIMARY KEY (id);


--
-- Name: wallet_transactions wallet_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.wallet_transactions
    ADD CONSTRAINT wallet_transactions_pkey PRIMARY KEY (id);


--
-- Name: wallets wallets_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.wallets
    ADD CONSTRAINT wallets_pkey PRIMARY KEY (id);


--
-- Name: wallets wallets_technician_id_key; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.wallets
    ADD CONSTRAINT wallets_technician_id_key UNIQUE (technician_id);


--
-- Name: warehouse_stock warehouse_stock_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.warehouse_stock
    ADD CONSTRAINT warehouse_stock_pkey PRIMARY KEY (id);


--
-- Name: warehouses warehouses_code_key; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.warehouses
    ADD CONSTRAINT warehouses_code_key UNIQUE (code);


--
-- Name: warehouses warehouses_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.warehouses
    ADD CONSTRAINT warehouses_pkey PRIMARY KEY (id);


--
-- Name: warranties warranties_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.warranties
    ADD CONSTRAINT warranties_pkey PRIMARY KEY (id);


--
-- Name: warranty_claims warranty_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.warranty_claims
    ADD CONSTRAINT warranty_claims_pkey PRIMARY KEY (id);


--
-- Name: zones zones_pkey; Type: CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.zones
    ADD CONSTRAINT zones_pkey PRIMARY KEY (id);


--
-- Name: ix_bpu_booking; Type: INDEX; Schema: public; Owner: bibek_user
--

CREATE INDEX ix_bpu_booking ON public.booking_part_usage USING btree (booking_id);


--
-- Name: ix_brand_categories_brand_id; Type: INDEX; Schema: public; Owner: bibek_user
--

CREATE INDEX ix_brand_categories_brand_id ON public.brand_categories USING btree (brand_id);


--
-- Name: ix_callback_requests_domain_id; Type: INDEX; Schema: public; Owner: bibek_user
--

CREATE INDEX ix_callback_requests_domain_id ON public.callback_requests USING btree (domain_id);


--
-- Name: ix_callback_requests_mobile; Type: INDEX; Schema: public; Owner: bibek_user
--

CREATE INDEX ix_callback_requests_mobile ON public.callback_requests USING btree (mobile);


--
-- Name: ix_coupons_domain_id; Type: INDEX; Schema: public; Owner: bibek_user
--

CREATE INDEX ix_coupons_domain_id ON public.coupons USING btree (domain_id);


--
-- Name: ix_direct_sales_sale_no; Type: INDEX; Schema: public; Owner: bibek_user
--

CREATE UNIQUE INDEX ix_direct_sales_sale_no ON public.direct_sales USING btree (sale_no);


--
-- Name: ix_inventory_items_barcode; Type: INDEX; Schema: public; Owner: bibek_user
--

CREATE UNIQUE INDEX ix_inventory_items_barcode ON public.inventory_items USING btree (barcode);


--
-- Name: ix_inventory_items_category_id; Type: INDEX; Schema: public; Owner: bibek_user
--

CREATE INDEX ix_inventory_items_category_id ON public.inventory_items USING btree (category_id);


--
-- Name: ix_inventory_items_sku; Type: INDEX; Schema: public; Owner: bibek_user
--

CREATE UNIQUE INDEX ix_inventory_items_sku ON public.inventory_items USING btree (sku);


--
-- Name: ix_mv_booking; Type: INDEX; Schema: public; Owner: bibek_user
--

CREATE INDEX ix_mv_booking ON public.stock_movements USING btree (booking_id);


--
-- Name: ix_mv_created; Type: INDEX; Schema: public; Owner: bibek_user
--

CREATE INDEX ix_mv_created ON public.stock_movements USING btree (created_at);


--
-- Name: ix_mv_item; Type: INDEX; Schema: public; Owner: bibek_user
--

CREATE INDEX ix_mv_item ON public.stock_movements USING btree (item_id);


--
-- Name: ix_mv_technician; Type: INDEX; Schema: public; Owner: bibek_user
--

CREATE INDEX ix_mv_technician ON public.stock_movements USING btree (technician_id);


--
-- Name: ix_tech_stock_tech; Type: INDEX; Schema: public; Owner: bibek_user
--

CREATE INDEX ix_tech_stock_tech ON public.technician_stock USING btree (technician_id);


--
-- Name: ix_technician_stock_logs_booking_id; Type: INDEX; Schema: public; Owner: bibek_user
--

CREATE INDEX ix_technician_stock_logs_booking_id ON public.technician_stock_logs USING btree (booking_id);


--
-- Name: ix_technician_stock_logs_item_id; Type: INDEX; Schema: public; Owner: bibek_user
--

CREATE INDEX ix_technician_stock_logs_item_id ON public.technician_stock_logs USING btree (item_id);


--
-- Name: ix_technician_stock_logs_technician_id; Type: INDEX; Schema: public; Owner: bibek_user
--

CREATE INDEX ix_technician_stock_logs_technician_id ON public.technician_stock_logs USING btree (technician_id);


--
-- Name: ix_transfer_challans_challan_no; Type: INDEX; Schema: public; Owner: bibek_user
--

CREATE UNIQUE INDEX ix_transfer_challans_challan_no ON public.transfer_challans USING btree (challan_no);


--
-- Name: ix_warehouse_stock_warehouse_id; Type: INDEX; Schema: public; Owner: bibek_user
--

CREATE INDEX ix_warehouse_stock_warehouse_id ON public.warehouse_stock USING btree (warehouse_id);


--
-- Name: ix_wh_stock_item; Type: INDEX; Schema: public; Owner: bibek_user
--

CREATE INDEX ix_wh_stock_item ON public.warehouse_stock USING btree (item_id);


--
-- Name: amc_subscriptions amc_subscriptions_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.amc_subscriptions
    ADD CONSTRAINT amc_subscriptions_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: amc_subscriptions amc_subscriptions_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.amc_subscriptions
    ADD CONSTRAINT amc_subscriptions_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.amc_plans(id);


--
-- Name: amc_visits amc_visits_amc_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.amc_visits
    ADD CONSTRAINT amc_visits_amc_id_fkey FOREIGN KEY (amc_id) REFERENCES public.amc_subscriptions(id);


--
-- Name: amc_visits amc_visits_technician_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.amc_visits
    ADD CONSTRAINT amc_visits_technician_id_fkey FOREIGN KEY (technician_id) REFERENCES public.technicians(id);


--
-- Name: appliance_service_history appliance_service_history_appliance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.appliance_service_history
    ADD CONSTRAINT appliance_service_history_appliance_id_fkey FOREIGN KEY (appliance_id) REFERENCES public.customer_appliances(id);


--
-- Name: appliance_service_history appliance_service_history_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.appliance_service_history
    ADD CONSTRAINT appliance_service_history_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: appliance_service_history appliance_service_history_technician_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.appliance_service_history
    ADD CONSTRAINT appliance_service_history_technician_id_fkey FOREIGN KEY (technician_id) REFERENCES public.technicians(id);


--
-- Name: appliance_types appliance_types_appliance_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.appliance_types
    ADD CONSTRAINT appliance_types_appliance_category_id_fkey FOREIGN KEY (appliance_category_id) REFERENCES public.service_categories(id);


--
-- Name: appliance_types appliance_types_brand_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.appliance_types
    ADD CONSTRAINT appliance_types_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES public.appliance_brands(id);


--
-- Name: areas areas_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(id);


--
-- Name: areas areas_zone_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_zone_id_fkey FOREIGN KEY (zone_id) REFERENCES public.zones(id);


--
-- Name: assignment_history assignment_history_assigned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.assignment_history
    ADD CONSTRAINT assignment_history_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id);


--
-- Name: assignment_history assignment_history_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.assignment_history
    ADD CONSTRAINT assignment_history_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: assignment_history assignment_history_technician_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.assignment_history
    ADD CONSTRAINT assignment_history_technician_id_fkey FOREIGN KEY (technician_id) REFERENCES public.technicians(id);


--
-- Name: attendance attendance_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- Name: attendance attendance_technician_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_technician_id_fkey FOREIGN KEY (technician_id) REFERENCES public.technicians(id);


--
-- Name: audit_logs audit_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: booking_part_usage booking_part_usage_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.booking_part_usage
    ADD CONSTRAINT booking_part_usage_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: booking_part_usage booking_part_usage_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.booking_part_usage
    ADD CONSTRAINT booking_part_usage_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: booking_part_usage booking_part_usage_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.booking_part_usage
    ADD CONSTRAINT booking_part_usage_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: booking_part_usage booking_part_usage_technician_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.booking_part_usage
    ADD CONSTRAINT booking_part_usage_technician_id_fkey FOREIGN KEY (technician_id) REFERENCES public.technicians(id);


--
-- Name: booking_part_usage booking_part_usage_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.booking_part_usage
    ADD CONSTRAINT booking_part_usage_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id);


--
-- Name: booking_status_logs booking_status_logs_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.booking_status_logs
    ADD CONSTRAINT booking_status_logs_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: booking_status_logs booking_status_logs_changed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.booking_status_logs
    ADD CONSTRAINT booking_status_logs_changed_by_fkey FOREIGN KEY (changed_by) REFERENCES public.users(id);


--
-- Name: bookings bookings_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.customer_addresses(id);


--
-- Name: bookings bookings_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: bookings bookings_domain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_domain_id_fkey FOREIGN KEY (domain_id) REFERENCES public.domains(id);


--
-- Name: bookings bookings_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id);


--
-- Name: bookings bookings_technician_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_technician_id_fkey FOREIGN KEY (technician_id) REFERENCES public.technicians(id);


--
-- Name: brand_categories brand_categories_appliance_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.brand_categories
    ADD CONSTRAINT brand_categories_appliance_category_id_fkey FOREIGN KEY (appliance_category_id) REFERENCES public.service_categories(id);


--
-- Name: brand_categories brand_categories_brand_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.brand_categories
    ADD CONSTRAINT brand_categories_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES public.appliance_brands(id);


--
-- Name: cash_collection_records cash_collection_records_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.cash_collection_records
    ADD CONSTRAINT cash_collection_records_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: cash_collection_records cash_collection_records_collected_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.cash_collection_records
    ADD CONSTRAINT cash_collection_records_collected_by_fkey FOREIGN KEY (collected_by) REFERENCES public.users(id);


--
-- Name: cash_collection_records cash_collection_records_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.cash_collection_records
    ADD CONSTRAINT cash_collection_records_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: cash_collection_records cash_collection_records_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.cash_collection_records
    ADD CONSTRAINT cash_collection_records_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.invoices(id);


--
-- Name: cash_collection_records cash_collection_records_payment_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.cash_collection_records
    ADD CONSTRAINT cash_collection_records_payment_transaction_id_fkey FOREIGN KEY (payment_transaction_id) REFERENCES public.payment_transactions(id);


--
-- Name: cash_collection_records cash_collection_records_technician_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.cash_collection_records
    ADD CONSTRAINT cash_collection_records_technician_id_fkey FOREIGN KEY (technician_id) REFERENCES public.technicians(id);


--
-- Name: city_settings city_settings_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.city_settings
    ADD CONSTRAINT city_settings_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(id);


--
-- Name: commission_group_assignments commission_group_assignments_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.commission_group_assignments
    ADD CONSTRAINT commission_group_assignments_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.commission_groups(id) ON DELETE CASCADE;


--
-- Name: commission_group_assignments commission_group_assignments_technician_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.commission_group_assignments
    ADD CONSTRAINT commission_group_assignments_technician_id_fkey FOREIGN KEY (technician_id) REFERENCES public.technicians(id) ON DELETE CASCADE;


--
-- Name: commission_group_part_rules commission_group_part_rules_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.commission_group_part_rules
    ADD CONSTRAINT commission_group_part_rules_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.commission_groups(id) ON DELETE CASCADE;


--
-- Name: commission_group_rules commission_group_rules_domain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.commission_group_rules
    ADD CONSTRAINT commission_group_rules_domain_id_fkey FOREIGN KEY (domain_id) REFERENCES public.domains(id) ON DELETE CASCADE;


--
-- Name: commission_group_rules commission_group_rules_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.commission_group_rules
    ADD CONSTRAINT commission_group_rules_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.commission_groups(id) ON DELETE CASCADE;


--
-- Name: commission_group_rules commission_group_rules_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.commission_group_rules
    ADD CONSTRAINT commission_group_rules_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;


--
-- Name: commissions commissions_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.commissions
    ADD CONSTRAINT commissions_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: commissions commissions_rule_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.commissions
    ADD CONSTRAINT commissions_rule_id_fkey FOREIGN KEY (rule_id) REFERENCES public.commission_rules(id);


--
-- Name: commissions commissions_technician_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.commissions
    ADD CONSTRAINT commissions_technician_id_fkey FOREIGN KEY (technician_id) REFERENCES public.technicians(id);


--
-- Name: coupon_usages coupon_usages_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.coupon_usages
    ADD CONSTRAINT coupon_usages_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: coupon_usages coupon_usages_coupon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.coupon_usages
    ADD CONSTRAINT coupon_usages_coupon_id_fkey FOREIGN KEY (coupon_id) REFERENCES public.coupons(id);


--
-- Name: coupon_usages coupon_usages_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.coupon_usages
    ADD CONSTRAINT coupon_usages_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: coupons coupons_domain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.coupons
    ADD CONSTRAINT coupons_domain_id_fkey FOREIGN KEY (domain_id) REFERENCES public.domains(id) ON DELETE SET NULL;


--
-- Name: crm_followups crm_followups_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.crm_followups
    ADD CONSTRAINT crm_followups_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: crm_followups crm_followups_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.crm_followups
    ADD CONSTRAINT crm_followups_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: crm_notes crm_notes_added_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.crm_notes
    ADD CONSTRAINT crm_notes_added_by_fkey FOREIGN KEY (added_by) REFERENCES public.users(id);


--
-- Name: crm_notes crm_notes_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.crm_notes
    ADD CONSTRAINT crm_notes_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: crm_tasks crm_tasks_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.crm_tasks
    ADD CONSTRAINT crm_tasks_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: crm_tasks crm_tasks_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.crm_tasks
    ADD CONSTRAINT crm_tasks_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: customer_addresses customer_addresses_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.customer_addresses
    ADD CONSTRAINT customer_addresses_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: customer_appliances customer_appliances_appliance_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.customer_appliances
    ADD CONSTRAINT customer_appliances_appliance_category_id_fkey FOREIGN KEY (appliance_category_id) REFERENCES public.service_categories(id);


--
-- Name: customer_appliances customer_appliances_brand_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.customer_appliances
    ADD CONSTRAINT customer_appliances_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES public.appliance_brands(id);


--
-- Name: customer_appliances customer_appliances_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.customer_appliances
    ADD CONSTRAINT customer_appliances_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: customer_appliances customer_appliances_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.customer_appliances
    ADD CONSTRAINT customer_appliances_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.appliance_types(id);


--
-- Name: customers customers_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: direct_sales direct_sales_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.direct_sales
    ADD CONSTRAINT direct_sales_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: direct_sales direct_sales_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.direct_sales
    ADD CONSTRAINT direct_sales_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: direct_sales direct_sales_sold_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.direct_sales
    ADD CONSTRAINT direct_sales_sold_by_fkey FOREIGN KEY (sold_by) REFERENCES public.users(id);


--
-- Name: direct_sales direct_sales_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.direct_sales
    ADD CONSTRAINT direct_sales_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id);


--
-- Name: domain_categories domain_categories_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.domain_categories
    ADD CONSTRAINT domain_categories_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.service_categories(id);


--
-- Name: domain_categories domain_categories_domain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.domain_categories
    ADD CONSTRAINT domain_categories_domain_id_fkey FOREIGN KEY (domain_id) REFERENCES public.domains(id);


--
-- Name: domain_cities domain_cities_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.domain_cities
    ADD CONSTRAINT domain_cities_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(id);


--
-- Name: domain_cities domain_cities_domain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.domain_cities
    ADD CONSTRAINT domain_cities_domain_id_fkey FOREIGN KEY (domain_id) REFERENCES public.domains(id);


--
-- Name: domain_profiles domain_profiles_domain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.domain_profiles
    ADD CONSTRAINT domain_profiles_domain_id_fkey FOREIGN KEY (domain_id) REFERENCES public.domains(id);


--
-- Name: domain_seo domain_seo_domain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.domain_seo
    ADD CONSTRAINT domain_seo_domain_id_fkey FOREIGN KEY (domain_id) REFERENCES public.domains(id);


--
-- Name: domain_service_overrides domain_service_overrides_domain_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.domain_service_overrides
    ADD CONSTRAINT domain_service_overrides_domain_service_id_fkey FOREIGN KEY (domain_service_id) REFERENCES public.domain_services(id) ON DELETE CASCADE;


--
-- Name: domain_services domain_services_domain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.domain_services
    ADD CONSTRAINT domain_services_domain_id_fkey FOREIGN KEY (domain_id) REFERENCES public.domains(id);


--
-- Name: domain_services domain_services_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.domain_services
    ADD CONSTRAINT domain_services_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id);


--
-- Name: escalations escalations_assigned_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.escalations
    ADD CONSTRAINT escalations_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES public.users(id);


--
-- Name: escalations escalations_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.escalations
    ADD CONSTRAINT escalations_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: escalations escalations_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.escalations
    ADD CONSTRAINT escalations_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: escalations escalations_resolved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.escalations
    ADD CONSTRAINT escalations_resolved_by_fkey FOREIGN KEY (resolved_by) REFERENCES public.users(id);


--
-- Name: franchises franchises_owner_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.franchises
    ADD CONSTRAINT franchises_owner_user_id_fkey FOREIGN KEY (owner_user_id) REFERENCES public.users(id);


--
-- Name: gst_settings gst_settings_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.gst_settings
    ADD CONSTRAINT gst_settings_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- Name: inventory_items inventory_items_brand_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT inventory_items_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES public.appliance_brands(id);


--
-- Name: inventory_items inventory_items_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT inventory_items_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.inventory_categories(id);


--
-- Name: inventory_reorder_rules inventory_reorder_rules_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.inventory_reorder_rules
    ADD CONSTRAINT inventory_reorder_rules_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: inventory_reorder_rules inventory_reorder_rules_preferred_vendor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.inventory_reorder_rules
    ADD CONSTRAINT inventory_reorder_rules_preferred_vendor_id_fkey FOREIGN KEY (preferred_vendor_id) REFERENCES public.vendors(id);


--
-- Name: inventory_reorder_rules inventory_reorder_rules_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.inventory_reorder_rules
    ADD CONSTRAINT inventory_reorder_rules_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id);


--
-- Name: invoices invoices_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: invoices invoices_domain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_domain_id_fkey FOREIGN KEY (domain_id) REFERENCES public.domains(id);


--
-- Name: invoices invoices_generated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_generated_by_fkey FOREIGN KEY (generated_by) REFERENCES public.users(id);


--
-- Name: invoices invoices_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_quotation_id_fkey FOREIGN KEY (quotation_id) REFERENCES public.quotations(id);


--
-- Name: leave_requests leave_requests_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- Name: leave_requests leave_requests_technician_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_technician_id_fkey FOREIGN KEY (technician_id) REFERENCES public.technicians(id);


--
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: payment_transactions payment_transactions_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.payment_transactions
    ADD CONSTRAINT payment_transactions_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: payment_transactions payment_transactions_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.payment_transactions
    ADD CONSTRAINT payment_transactions_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: payment_transactions payment_transactions_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.payment_transactions
    ADD CONSTRAINT payment_transactions_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.invoices(id);


--
-- Name: payment_transactions payment_transactions_verified_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.payment_transactions
    ADD CONSTRAINT payment_transactions_verified_by_fkey FOREIGN KEY (verified_by) REFERENCES public.users(id);


--
-- Name: quotation_appliances quotation_appliances_appliance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.quotation_appliances
    ADD CONSTRAINT quotation_appliances_appliance_id_fkey FOREIGN KEY (appliance_id) REFERENCES public.customer_appliances(id);


--
-- Name: quotation_appliances quotation_appliances_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.quotation_appliances
    ADD CONSTRAINT quotation_appliances_quotation_id_fkey FOREIGN KEY (quotation_id) REFERENCES public.quotations(id);


--
-- Name: quotation_appliances quotation_appliances_repeat_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.quotation_appliances
    ADD CONSTRAINT quotation_appliances_repeat_booking_id_fkey FOREIGN KEY (repeat_booking_id) REFERENCES public.bookings(id);


--
-- Name: quotation_part_items quotation_part_items_inventory_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.quotation_part_items
    ADD CONSTRAINT quotation_part_items_inventory_item_id_fkey FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_items(id);


--
-- Name: quotation_part_items quotation_part_items_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.quotation_part_items
    ADD CONSTRAINT quotation_part_items_quotation_id_fkey FOREIGN KEY (quotation_id) REFERENCES public.quotations(id);


--
-- Name: quotation_service_items quotation_service_items_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.quotation_service_items
    ADD CONSTRAINT quotation_service_items_quotation_id_fkey FOREIGN KEY (quotation_id) REFERENCES public.quotations(id);


--
-- Name: quotation_service_items quotation_service_items_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.quotation_service_items
    ADD CONSTRAINT quotation_service_items_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id);


--
-- Name: quotation_status_logs quotation_status_logs_changed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.quotation_status_logs
    ADD CONSTRAINT quotation_status_logs_changed_by_fkey FOREIGN KEY (changed_by) REFERENCES public.users(id);


--
-- Name: quotation_status_logs quotation_status_logs_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.quotation_status_logs
    ADD CONSTRAINT quotation_status_logs_quotation_id_fkey FOREIGN KEY (quotation_id) REFERENCES public.quotations(id);


--
-- Name: quotations quotations_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- Name: quotations quotations_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: quotations quotations_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: quotations quotations_domain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_domain_id_fkey FOREIGN KEY (domain_id) REFERENCES public.domains(id);


--
-- Name: quotations quotations_original_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_original_quotation_id_fkey FOREIGN KEY (original_quotation_id) REFERENCES public.quotations(id);


--
-- Name: referral_codes referral_codes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.referral_codes
    ADD CONSTRAINT referral_codes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: referral_rewards referral_rewards_referral_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.referral_rewards
    ADD CONSTRAINT referral_rewards_referral_id_fkey FOREIGN KEY (referral_id) REFERENCES public.referrals(id);


--
-- Name: referral_rewards referral_rewards_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.referral_rewards
    ADD CONSTRAINT referral_rewards_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: referrals referrals_referee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.referrals
    ADD CONSTRAINT referrals_referee_id_fkey FOREIGN KEY (referee_id) REFERENCES public.users(id);


--
-- Name: referrals referrals_referrer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.referrals
    ADD CONSTRAINT referrals_referrer_id_fkey FOREIGN KEY (referrer_id) REFERENCES public.users(id);


--
-- Name: refunds refunds_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.refunds
    ADD CONSTRAINT refunds_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: refunds refunds_payment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.refunds
    ADD CONSTRAINT refunds_payment_id_fkey FOREIGN KEY (payment_id) REFERENCES public.payment_transactions(id);


--
-- Name: refunds refunds_processed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.refunds
    ADD CONSTRAINT refunds_processed_by_fkey FOREIGN KEY (processed_by) REFERENCES public.users(id);


--
-- Name: role_permissions role_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id);


--
-- Name: role_permissions role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- Name: service_city_prices service_city_prices_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.service_city_prices
    ADD CONSTRAINT service_city_prices_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(id);


--
-- Name: service_city_prices service_city_prices_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.service_city_prices
    ADD CONSTRAINT service_city_prices_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id);


--
-- Name: services services_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.service_categories(id);


--
-- Name: sla_breaches sla_breaches_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.sla_breaches
    ADD CONSTRAINT sla_breaches_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: sla_breaches sla_breaches_policy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.sla_breaches
    ADD CONSTRAINT sla_breaches_policy_id_fkey FOREIGN KEY (policy_id) REFERENCES public.sla_policies(id);


--
-- Name: stock_movements stock_movements_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: stock_movements stock_movements_from_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_from_warehouse_id_fkey FOREIGN KEY (from_warehouse_id) REFERENCES public.warehouses(id);


--
-- Name: stock_movements stock_movements_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: stock_movements stock_movements_performed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_performed_by_fkey FOREIGN KEY (performed_by) REFERENCES public.users(id);


--
-- Name: stock_movements stock_movements_technician_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_technician_id_fkey FOREIGN KEY (technician_id) REFERENCES public.technicians(id);


--
-- Name: stock_movements stock_movements_to_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_to_warehouse_id_fkey FOREIGN KEY (to_warehouse_id) REFERENCES public.warehouses(id);


--
-- Name: technician_availability technician_availability_technician_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.technician_availability
    ADD CONSTRAINT technician_availability_technician_id_fkey FOREIGN KEY (technician_id) REFERENCES public.technicians(id);


--
-- Name: technician_ratings technician_ratings_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.technician_ratings
    ADD CONSTRAINT technician_ratings_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: technician_ratings technician_ratings_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.technician_ratings
    ADD CONSTRAINT technician_ratings_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: technician_ratings technician_ratings_technician_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.technician_ratings
    ADD CONSTRAINT technician_ratings_technician_id_fkey FOREIGN KEY (technician_id) REFERENCES public.technicians(id);


--
-- Name: technician_skills technician_skills_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.technician_skills
    ADD CONSTRAINT technician_skills_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id);


--
-- Name: technician_skills technician_skills_technician_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.technician_skills
    ADD CONSTRAINT technician_skills_technician_id_fkey FOREIGN KEY (technician_id) REFERENCES public.technicians(id);


--
-- Name: technician_stock technician_stock_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.technician_stock
    ADD CONSTRAINT technician_stock_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: technician_stock_logs technician_stock_logs_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.technician_stock_logs
    ADD CONSTRAINT technician_stock_logs_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: technician_stock_logs technician_stock_logs_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.technician_stock_logs
    ADD CONSTRAINT technician_stock_logs_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: technician_stock_logs technician_stock_logs_performed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.technician_stock_logs
    ADD CONSTRAINT technician_stock_logs_performed_by_fkey FOREIGN KEY (performed_by) REFERENCES public.users(id);


--
-- Name: technician_stock_logs technician_stock_logs_technician_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.technician_stock_logs
    ADD CONSTRAINT technician_stock_logs_technician_id_fkey FOREIGN KEY (technician_id) REFERENCES public.technicians(id);


--
-- Name: technician_stock_logs technician_stock_logs_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.technician_stock_logs
    ADD CONSTRAINT technician_stock_logs_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id);


--
-- Name: technician_stock technician_stock_technician_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.technician_stock
    ADD CONSTRAINT technician_stock_technician_id_fkey FOREIGN KEY (technician_id) REFERENCES public.technicians(id);


--
-- Name: technicians technicians_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.technicians
    ADD CONSTRAINT technicians_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: tracking_locations tracking_locations_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.tracking_locations
    ADD CONSTRAINT tracking_locations_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: tracking_locations tracking_locations_technician_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.tracking_locations
    ADD CONSTRAINT tracking_locations_technician_id_fkey FOREIGN KEY (technician_id) REFERENCES public.technicians(id);


--
-- Name: transfer_challans transfer_challans_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.transfer_challans
    ADD CONSTRAINT transfer_challans_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: transfer_challans transfer_challans_from_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.transfer_challans
    ADD CONSTRAINT transfer_challans_from_warehouse_id_fkey FOREIGN KEY (from_warehouse_id) REFERENCES public.warehouses(id);


--
-- Name: transfer_challans transfer_challans_received_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.transfer_challans
    ADD CONSTRAINT transfer_challans_received_by_fkey FOREIGN KEY (received_by) REFERENCES public.users(id);


--
-- Name: transfer_challans transfer_challans_to_technician_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.transfer_challans
    ADD CONSTRAINT transfer_challans_to_technician_id_fkey FOREIGN KEY (to_technician_id) REFERENCES public.technicians(id);


--
-- Name: transfer_challans transfer_challans_to_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.transfer_challans
    ADD CONSTRAINT transfer_challans_to_warehouse_id_fkey FOREIGN KEY (to_warehouse_id) REFERENCES public.warehouses(id);


--
-- Name: user_permissions user_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.user_permissions
    ADD CONSTRAINT user_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id);


--
-- Name: user_permissions user_permissions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.user_permissions
    ADD CONSTRAINT user_permissions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: vendor_transactions vendor_transactions_vendor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.vendor_transactions
    ADD CONSTRAINT vendor_transactions_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.vendors(id);


--
-- Name: wallet_transactions wallet_transactions_wallet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.wallet_transactions
    ADD CONSTRAINT wallet_transactions_wallet_id_fkey FOREIGN KEY (wallet_id) REFERENCES public.wallets(id);


--
-- Name: wallets wallets_technician_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.wallets
    ADD CONSTRAINT wallets_technician_id_fkey FOREIGN KEY (technician_id) REFERENCES public.technicians(id);


--
-- Name: wallets wallets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.wallets
    ADD CONSTRAINT wallets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: warehouse_stock warehouse_stock_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.warehouse_stock
    ADD CONSTRAINT warehouse_stock_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: warehouse_stock warehouse_stock_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.warehouse_stock
    ADD CONSTRAINT warehouse_stock_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id);


--
-- Name: warehouses warehouses_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.warehouses
    ADD CONSTRAINT warehouses_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(id);


--
-- Name: warehouses warehouses_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.warehouses
    ADD CONSTRAINT warehouses_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES public.users(id);


--
-- Name: warranties warranties_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.warranties
    ADD CONSTRAINT warranties_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: warranties warranties_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.warranties
    ADD CONSTRAINT warranties_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: warranty_claims warranty_claims_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.warranty_claims
    ADD CONSTRAINT warranty_claims_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- Name: warranty_claims warranty_claims_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.warranty_claims
    ADD CONSTRAINT warranty_claims_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: warranty_claims warranty_claims_claimed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.warranty_claims
    ADD CONSTRAINT warranty_claims_claimed_by_fkey FOREIGN KEY (claimed_by) REFERENCES public.users(id);


--
-- Name: warranty_claims warranty_claims_rejected_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.warranty_claims
    ADD CONSTRAINT warranty_claims_rejected_by_fkey FOREIGN KEY (rejected_by) REFERENCES public.users(id);


--
-- Name: warranty_claims warranty_claims_warranty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.warranty_claims
    ADD CONSTRAINT warranty_claims_warranty_id_fkey FOREIGN KEY (warranty_id) REFERENCES public.warranties(id);


--
-- Name: zones zones_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bibek_user
--

ALTER TABLE ONLY public.zones
    ADD CONSTRAINT zones_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(id);


--
-- PostgreSQL database dump complete
--

\unrestrict kVaOoktnfHonooi8taZdfzyejaqrYKsr4e3AqiBygdwUaQzSQeuE9aOeb4ermHN

