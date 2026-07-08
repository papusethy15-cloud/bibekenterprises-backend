-- ============================================================
-- VPS SCHEMA REPAIR SCRIPT — generated from ORM models
-- Safe to run multiple times: CREATE TABLE IF NOT EXISTS
-- Run as: psql -U bibek_user -d bibek_enterprises -h localhost -p 5432 -f /tmp/vps_repair.sql
-- ============================================================

-- ── amc_plans ──
CREATE TABLE IF NOT EXISTS amc_plans (
	name VARCHAR(100) NOT NULL, 
	plan_type VARCHAR(30), 
	price FLOAT NOT NULL, 
	duration_months INTEGER, 
	visit_count INTEGER NOT NULL, 
	description TEXT, 
	appliance_types TEXT, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id)
);

-- ── appliance_brands ──
CREATE TABLE IF NOT EXISTS appliance_brands (
	id UUID NOT NULL, 
	name VARCHAR(100) NOT NULL, 
	logo_url VARCHAR(500), 
	is_active BOOLEAN, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id), 
	UNIQUE (name)
);

-- ── assignment_rules ──
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
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	UNIQUE (name)
);

-- ── cities ──
CREATE TABLE IF NOT EXISTS cities (
	name VARCHAR(100) NOT NULL, 
	state VARCHAR(100) NOT NULL, 
	country VARCHAR(100), 
	base_travel_charge FLOAT, 
	surge_multiplier FLOAT, 
	sort_order INTEGER, 
	latitude FLOAT, 
	longitude FLOAT, 
	is_serviceable BOOLEAN, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	UNIQUE (name)
);

-- ── commission_groups ──
CREATE TABLE IF NOT EXISTS commission_groups (
	id UUID NOT NULL, 
	name VARCHAR(150) NOT NULL, 
	description VARCHAR(500), 
	is_active BOOLEAN, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	updated_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id)
);

-- ── commission_rules ──
CREATE TABLE IF NOT EXISTS commission_rules (
	id UUID NOT NULL, 
	name VARCHAR(100) NOT NULL, 
	role VARCHAR(50), 
	commission_type VARCHAR(20), 
	rate FLOAT, 
	applies_to VARCHAR(50), 
	is_active BOOLEAN, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id)
);

-- ── domains ──
CREATE TABLE IF NOT EXISTS domains (
	name VARCHAR(150) NOT NULL, 
	slug VARCHAR(100) NOT NULL, 
	description TEXT, 
	logo_url VARCHAR(500), 
	primary_color VARCHAR(20), 
	meta_title VARCHAR(200), 
	meta_desc TEXT, 
	sort_order INTEGER, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	UNIQUE (slug)
);

-- ── inventory_brands ──
CREATE TABLE IF NOT EXISTS inventory_brands (
	id UUID NOT NULL, 
	name VARCHAR(100) NOT NULL, 
	is_active BOOLEAN, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id), 
	UNIQUE (name)
);

-- ── inventory_categories ──
CREATE TABLE IF NOT EXISTS inventory_categories (
	id UUID NOT NULL, 
	name VARCHAR(100) NOT NULL, 
	description TEXT, 
	icon VARCHAR(10), 
	sort_order INTEGER, 
	is_active BOOLEAN, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id), 
	UNIQUE (name)
);

-- ── notification_templates ──
CREATE TABLE IF NOT EXISTS notification_templates (
	id UUID NOT NULL, 
	name VARCHAR(100) NOT NULL, 
	title VARCHAR(200) NOT NULL, 
	body TEXT NOT NULL, 
	channel VARCHAR(20), 
	is_active BOOLEAN, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id), 
	UNIQUE (name)
);

-- ── permissions ──
CREATE TABLE IF NOT EXISTS permissions (
	code VARCHAR(100) NOT NULL, 
	module VARCHAR(50) NOT NULL, 
	name VARCHAR(150) NOT NULL, 
	description TEXT, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	UNIQUE (code)
);

-- ── roles ──
CREATE TABLE IF NOT EXISTS roles (
	code VARCHAR(50) NOT NULL, 
	name VARCHAR(150) NOT NULL, 
	description TEXT, 
	is_system BOOLEAN NOT NULL, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	UNIQUE (code)
);

-- ── service_categories ──
CREATE TABLE IF NOT EXISTS service_categories (
	name VARCHAR(150) NOT NULL, 
	description TEXT, 
	icon VARCHAR(500), 
	sort_order INTEGER, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id)
);

-- ── sla_policies ──
CREATE TABLE IF NOT EXISTS sla_policies (
	id UUID NOT NULL, 
	name VARCHAR(100) NOT NULL, 
	description TEXT, 
	response_time_minutes INTEGER, 
	resolution_time_hours INTEGER, 
	priority VARCHAR(20), 
	is_active BOOLEAN, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id)
);

-- ── system_settings ──
CREATE TABLE IF NOT EXISTS system_settings (
	"group" VARCHAR(50) NOT NULL, 
	key VARCHAR(100) NOT NULL, 
	value TEXT, 
	is_secret BOOLEAN, 
	label VARCHAR(200), 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	CONSTRAINT uq_setting_group_key UNIQUE ("group", key)
);

-- ── users ──
CREATE TABLE IF NOT EXISTS users (
	name VARCHAR(150) NOT NULL, 
	mobile VARCHAR(20) NOT NULL, 
	email VARCHAR(200), 
	password_hash VARCHAR(255), 
	role userrole NOT NULL, 
	city VARCHAR(100), 
	profile_image VARCHAR(500), 
	id_proof_url VARCHAR(500), 
	id_proof_type VARCHAR(50), 
	address_proof_url VARCHAR(500), 
	address_proof_type VARCHAR(50), 
	is_verified BOOLEAN, 
	fcm_token VARCHAR(500), 
	firebase_uid VARCHAR(128), 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	UNIQUE (mobile), 
	UNIQUE (email), 
	UNIQUE (firebase_uid)
);

-- ── vendors ──
CREATE TABLE IF NOT EXISTS vendors (
	name VARCHAR(200) NOT NULL, 
	contact_person VARCHAR(150), 
	mobile VARCHAR(20), 
	email VARCHAR(200), 
	gstin VARCHAR(20), 
	address TEXT, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id)
);

-- ── appliance_types ──
CREATE TABLE IF NOT EXISTS appliance_types (
	id UUID NOT NULL, 
	name VARCHAR(100) NOT NULL, 
	category VARCHAR(100), 
	appliance_category_id UUID, 
	brand_id UUID, 
	is_active BOOLEAN, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id), 
	FOREIGN KEY(appliance_category_id) REFERENCES service_categories (id), 
	FOREIGN KEY(brand_id) REFERENCES appliance_brands (id)
);

-- ── audit_logs ──
CREATE TABLE IF NOT EXISTS audit_logs (
	id UUID NOT NULL, 
	user_id UUID, 
	user_name VARCHAR(150), 
	user_role VARCHAR(50), 
	action VARCHAR(100) NOT NULL, 
	resource_type VARCHAR(100), 
	resource_id VARCHAR(200), 
	description VARCHAR(500), 
	old_data JSONB, 
	new_data JSONB, 
	ip_address VARCHAR(50), 
	user_agent VARCHAR(500), 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(user_id) REFERENCES users (id)
);

-- ── brand_categories ──
CREATE TABLE IF NOT EXISTS brand_categories (
	id UUID NOT NULL, 
	brand_id UUID NOT NULL, 
	appliance_category_id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id), 
	FOREIGN KEY(brand_id) REFERENCES appliance_brands (id), 
	FOREIGN KEY(appliance_category_id) REFERENCES service_categories (id)
);

-- ── city_settings ──
CREATE TABLE IF NOT EXISTS city_settings (
	city_id UUID NOT NULL, 
	min_booking_amount FLOAT, 
	max_booking_amount FLOAT, 
	booking_advance_days INTEGER, 
	cancellation_window_hrs INTEGER, 
	auto_assign_enabled BOOLEAN, 
	notes TEXT, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	CONSTRAINT uq_city_settings UNIQUE (city_id), 
	FOREIGN KEY(city_id) REFERENCES cities (id)
);

-- ── commission_group_part_rules ──
CREATE TABLE IF NOT EXISTS commission_group_part_rules (
	id UUID NOT NULL, 
	group_id UUID NOT NULL, 
	part_name_match VARCHAR(200), 
	part_source_filter VARCHAR(30), 
	commission_type VARCHAR(20) NOT NULL, 
	rate FLOAT NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id), 
	FOREIGN KEY(group_id) REFERENCES commission_groups (id) ON DELETE CASCADE
);

-- ── coupons ──
CREATE TABLE IF NOT EXISTS coupons (
	id UUID NOT NULL, 
	domain_id UUID, 
	code VARCHAR(50) NOT NULL, 
	description TEXT, 
	discount_type VARCHAR(20), 
	discount_value FLOAT NOT NULL, 
	min_order_amount FLOAT, 
	max_discount_amount FLOAT, 
	usage_limit INTEGER, 
	used_count INTEGER, 
	valid_from TIMESTAMP WITH TIME ZONE, 
	valid_until TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	updated_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id), 
	FOREIGN KEY(domain_id) REFERENCES domains (id) ON DELETE SET NULL
);

-- ── customers ──
CREATE TABLE IF NOT EXISTS customers (
	user_id UUID NOT NULL, 
	name VARCHAR(150) NOT NULL, 
	mobile VARCHAR(20) NOT NULL, 
	email VARCHAR(200), 
	alternate_mobile VARCHAR(20), 
	notes TEXT, 
	customer_code VARCHAR(30), 
	total_bookings VARCHAR(10), 
	fcm_token VARCHAR(500), 
	gst_number VARCHAR(20), 
	gst_name VARCHAR(200), 
	gst_address TEXT, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	UNIQUE (user_id), 
	FOREIGN KEY(user_id) REFERENCES users (id), 
	UNIQUE (customer_code)
);

-- ── domain_categories ──
CREATE TABLE IF NOT EXISTS domain_categories (
	domain_id UUID NOT NULL, 
	category_id UUID NOT NULL, 
	sort_order INTEGER, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	CONSTRAINT uq_domain_category UNIQUE (domain_id, category_id), 
	FOREIGN KEY(domain_id) REFERENCES domains (id), 
	FOREIGN KEY(category_id) REFERENCES service_categories (id)
);

-- ── domain_cities ──
CREATE TABLE IF NOT EXISTS domain_cities (
	domain_id UUID NOT NULL, 
	city_id UUID NOT NULL, 
	sort_order INTEGER, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	CONSTRAINT uq_domain_city UNIQUE (domain_id, city_id), 
	FOREIGN KEY(domain_id) REFERENCES domains (id), 
	FOREIGN KEY(city_id) REFERENCES cities (id)
);

-- ── domain_profiles ──
CREATE TABLE IF NOT EXISTS domain_profiles (
	domain_id UUID NOT NULL, 
	logo_url VARCHAR(500), 
	logo_dark_url VARCHAR(500), 
	favicon_url VARCHAR(500), 
	og_image_url VARCHAR(500), 
	banner_url VARCHAR(500), 
	facebook_url VARCHAR(500), 
	instagram_url VARCHAR(500), 
	twitter_url VARCHAR(500), 
	youtube_url VARCHAR(500), 
	linkedin_url VARCHAR(500), 
	whatsapp_number VARCHAR(20), 
	support_phone VARCHAR(30), 
	support_email VARCHAR(200), 
	office_address TEXT, 
	office_city VARCHAR(100), 
	office_state VARCHAR(100), 
	office_pincode VARCHAR(10), 
	office_country VARCHAR(100), 
	google_maps_url VARCHAR(500), 
	business_legal_name VARCHAR(200), 
	gstin VARCHAR(20), 
	pan_number VARCHAR(20), 
	invoice_prefix VARCHAR(20), 
	bank_account_name VARCHAR(200), 
	bank_account_number VARCHAR(50), 
	bank_ifsc VARCHAR(20), 
	bank_name VARCHAR(100), 
	bank_branch VARCHAR(200), 
	upi_id VARCHAR(100), 
	tagline VARCHAR(300), 
	about_short TEXT, 
	copyright_text VARCHAR(300), 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	CONSTRAINT uq_domain_profile UNIQUE (domain_id), 
	FOREIGN KEY(domain_id) REFERENCES domains (id)
);

-- ── domain_seo ──
CREATE TABLE IF NOT EXISTS domain_seo (
	domain_id UUID NOT NULL, 
	meta_title VARCHAR(200), 
	meta_description TEXT, 
	meta_keywords TEXT, 
	og_title VARCHAR(200), 
	og_description TEXT, 
	og_image_url VARCHAR(500), 
	canonical_url VARCHAR(500), 
	robots VARCHAR(100), 
	schema_json TEXT, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	CONSTRAINT uq_domain_seo UNIQUE (domain_id), 
	FOREIGN KEY(domain_id) REFERENCES domains (id)
);

-- ── franchises ──
CREATE TABLE IF NOT EXISTS franchises (
	id UUID NOT NULL, 
	name VARCHAR(200) NOT NULL, 
	owner_user_id UUID, 
	city VARCHAR(100), 
	state VARCHAR(100), 
	address TEXT, 
	phone VARCHAR(20), 
	email VARCHAR(200), 
	commission_rate FLOAT, 
	is_active BOOLEAN, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id), 
	FOREIGN KEY(owner_user_id) REFERENCES users (id)
);

-- ── gst_settings ──
CREATE TABLE IF NOT EXISTS gst_settings (
	gst_enabled BOOLEAN NOT NULL, 
	default_rate FLOAT NOT NULL, 
	allow_b2b BOOLEAN NOT NULL, 
	allow_b2c BOOLEAN NOT NULL, 
	allow_non_gst BOOLEAN NOT NULL, 
	gstin_validation_enabled BOOLEAN NOT NULL, 
	company_gstin VARCHAR(50), 
	company_name VARCHAR(200), 
	company_address TEXT, 
	hsn_code VARCHAR(30), 
	invoice_prefix VARCHAR(20) NOT NULL, 
	state_code VARCHAR(10), 
	updated_by UUID, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(updated_by) REFERENCES users (id)
);

-- ── inventory_items ──
CREATE TABLE IF NOT EXISTS inventory_items (
	id UUID NOT NULL, 
	name VARCHAR(200) NOT NULL, 
	sku VARCHAR(100), 
	barcode VARCHAR(100), 
	category_id UUID, 
	brand_id UUID, 
	unit VARCHAR(20), 
	description TEXT, 
	image_url VARCHAR(500), 
	hsn_code VARCHAR(20), 
	gst_percent FLOAT, 
	cost_price FLOAT, 
	selling_price FLOAT, 
	mrp FLOAT, 
	current_stock INTEGER, 
	reserved_stock INTEGER, 
	min_stock_level INTEGER, 
	reorder_qty INTEGER, 
	is_active BOOLEAN, 
	is_consumable BOOLEAN, 
	is_serialised BOOLEAN, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	updated_at TIMESTAMP WITH TIME ZONE, 
	PRIMARY KEY (id), 
	FOREIGN KEY(category_id) REFERENCES inventory_categories (id), 
	FOREIGN KEY(brand_id) REFERENCES appliance_brands (id)
);

-- ── notifications ──
CREATE TABLE IF NOT EXISTS notifications (
	id UUID NOT NULL, 
	user_id UUID NOT NULL, 
	title VARCHAR(200) NOT NULL, 
	body TEXT NOT NULL, 
	channel VARCHAR(20), 
	is_read BOOLEAN, 
	data JSONB, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id), 
	FOREIGN KEY(user_id) REFERENCES users (id)
);

-- ── referral_codes ──
CREATE TABLE IF NOT EXISTS referral_codes (
	user_id UUID NOT NULL, 
	code VARCHAR(20) NOT NULL, 
	total_referrals INTEGER, 
	total_earned FLOAT, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	UNIQUE (user_id), 
	FOREIGN KEY(user_id) REFERENCES users (id), 
	UNIQUE (code)
);

-- ── referrals ──
CREATE TABLE IF NOT EXISTS referrals (
	referrer_id UUID NOT NULL, 
	referee_id UUID NOT NULL, 
	reward_amount FLOAT, 
	status VARCHAR(20), 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(referrer_id) REFERENCES users (id), 
	FOREIGN KEY(referee_id) REFERENCES users (id)
);

-- ── role_permissions ──
CREATE TABLE IF NOT EXISTS role_permissions (
	role_id UUID NOT NULL, 
	permission_id UUID NOT NULL, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	CONSTRAINT uq_role_permission UNIQUE (role_id, permission_id), 
	FOREIGN KEY(role_id) REFERENCES roles (id), 
	FOREIGN KEY(permission_id) REFERENCES permissions (id)
);

-- ── services ──
CREATE TABLE IF NOT EXISTS services (
	category_id UUID NOT NULL, 
	name VARCHAR(200) NOT NULL, 
	description TEXT, 
	base_price FLOAT NOT NULL, 
	gst_percent FLOAT, 
	duration_mins INTEGER, 
	is_visible BOOLEAN, 
	sort_order INTEGER, 
	is_pending_verify INTEGER NOT NULL, 
	suggested_by_tech UUID, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(category_id) REFERENCES service_categories (id), 
	FOREIGN KEY(suggested_by_tech) REFERENCES users (id)
);

-- ── technicians ──
CREATE TABLE IF NOT EXISTS technicians (
	user_id UUID NOT NULL, 
	name VARCHAR(150) NOT NULL, 
	mobile VARCHAR(20) NOT NULL, 
	email VARCHAR(200), 
	alternate_mobile VARCHAR(20), 
	technician_code VARCHAR(30), 
	dob DATE, 
	gender VARCHAR(10), 
	city VARCHAR(100), 
	area VARCHAR(200), 
	pincode VARCHAR(10), 
	address TEXT, 
	experience_years INTEGER, 
	status technicianstatus, 
	rating FLOAT, 
	total_jobs INTEGER, 
	profile_image VARCHAR(500), 
	id_proof VARCHAR(500), 
	identity_type VARCHAR(50), 
	identity_number VARCHAR(50), 
	emergency_contact_name VARCHAR(150), 
	emergency_contact_mobile VARCHAR(20), 
	is_online BOOLEAN NOT NULL, 
	fcm_token VARCHAR(500), 
	last_lat FLOAT, 
	last_lng FLOAT, 
	last_seen_at TIMESTAMP WITH TIME ZONE, 
	auto_assign_eligible BOOLEAN NOT NULL, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	UNIQUE (user_id), 
	FOREIGN KEY(user_id) REFERENCES users (id), 
	UNIQUE (technician_code)
);

-- ── user_permissions ──
CREATE TABLE IF NOT EXISTS user_permissions (
	user_id UUID NOT NULL, 
	permission_id UUID NOT NULL, 
	is_granted BOOLEAN NOT NULL, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	CONSTRAINT uq_user_permission UNIQUE (user_id, permission_id), 
	FOREIGN KEY(user_id) REFERENCES users (id), 
	FOREIGN KEY(permission_id) REFERENCES permissions (id)
);

-- ── vendor_transactions ──
CREATE TABLE IF NOT EXISTS vendor_transactions (
	vendor_id UUID NOT NULL, 
	amount FLOAT NOT NULL, 
	type VARCHAR(30) NOT NULL, 
	notes TEXT, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(vendor_id) REFERENCES vendors (id)
);

-- ── warehouses ──
CREATE TABLE IF NOT EXISTS warehouses (
	id UUID NOT NULL, 
	name VARCHAR(200) NOT NULL, 
	code VARCHAR(20), 
	address TEXT, 
	city_id UUID, 
	city VARCHAR(100), 
	manager_id UUID, 
	phone VARCHAR(20), 
	is_active BOOLEAN, 
	is_default BOOLEAN, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id), 
	UNIQUE (code), 
	FOREIGN KEY(city_id) REFERENCES cities (id), 
	FOREIGN KEY(manager_id) REFERENCES users (id)
);

-- ── zones ──
CREATE TABLE IF NOT EXISTS zones (
	city_id UUID NOT NULL, 
	name VARCHAR(150) NOT NULL, 
	description TEXT, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(city_id) REFERENCES cities (id)
);

-- ── amc_subscriptions ──
CREATE TABLE IF NOT EXISTS amc_subscriptions (
	customer_id UUID NOT NULL, 
	plan_id UUID NOT NULL, 
	start_date TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	end_date TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	visits_remaining INTEGER, 
	amount_paid FLOAT, 
	status VARCHAR(20), 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(customer_id) REFERENCES customers (id), 
	FOREIGN KEY(plan_id) REFERENCES amc_plans (id)
);

-- ── areas ──
CREATE TABLE IF NOT EXISTS areas (
	city_id UUID NOT NULL, 
	zone_id UUID, 
	name VARCHAR(150) NOT NULL, 
	pincode VARCHAR(20), 
	latitude FLOAT, 
	longitude FLOAT, 
	surge_multiplier FLOAT, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(city_id) REFERENCES cities (id), 
	FOREIGN KEY(zone_id) REFERENCES zones (id)
);

-- ── attendance ──
CREATE TABLE IF NOT EXISTS attendance (
	id UUID NOT NULL, 
	technician_id UUID NOT NULL, 
	date DATE NOT NULL, 
	check_in TIMESTAMP WITH TIME ZONE, 
	check_out TIMESTAMP WITH TIME ZONE, 
	check_in_lat FLOAT, 
	check_in_lng FLOAT, 
	accumulated_seconds INTEGER NOT NULL, 
	status VARCHAR(20), 
	notes TEXT, 
	approved_by UUID, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id), 
	FOREIGN KEY(technician_id) REFERENCES technicians (id), 
	FOREIGN KEY(approved_by) REFERENCES users (id)
);

-- ── commission_group_assignments ──
CREATE TABLE IF NOT EXISTS commission_group_assignments (
	id UUID NOT NULL, 
	technician_id UUID NOT NULL, 
	group_id UUID NOT NULL, 
	assigned_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id), 
	UNIQUE (technician_id, group_id), 
	FOREIGN KEY(technician_id) REFERENCES technicians (id) ON DELETE CASCADE, 
	FOREIGN KEY(group_id) REFERENCES commission_groups (id) ON DELETE CASCADE
);

-- ── commission_group_rules ──
CREATE TABLE IF NOT EXISTS commission_group_rules (
	id UUID NOT NULL, 
	group_id UUID NOT NULL, 
	service_id UUID NOT NULL, 
	domain_id UUID, 
	commission_type VARCHAR(20) NOT NULL, 
	rate FLOAT NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id), 
	FOREIGN KEY(group_id) REFERENCES commission_groups (id) ON DELETE CASCADE, 
	FOREIGN KEY(service_id) REFERENCES services (id) ON DELETE CASCADE, 
	FOREIGN KEY(domain_id) REFERENCES domains (id) ON DELETE CASCADE
);

-- ── crm_followups ──
CREATE TABLE IF NOT EXISTS crm_followups (
	customer_id UUID NOT NULL, 
	created_by UUID NOT NULL, 
	subject VARCHAR(200) NOT NULL, 
	notes TEXT, 
	due_date TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	status VARCHAR(20), 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(customer_id) REFERENCES customers (id), 
	FOREIGN KEY(created_by) REFERENCES users (id)
);

-- ── crm_notes ──
CREATE TABLE IF NOT EXISTS crm_notes (
	customer_id UUID NOT NULL, 
	added_by UUID NOT NULL, 
	note TEXT NOT NULL, 
	note_type VARCHAR(30), 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(customer_id) REFERENCES customers (id), 
	FOREIGN KEY(added_by) REFERENCES users (id)
);

-- ── crm_tasks ──
CREATE TABLE IF NOT EXISTS crm_tasks (
	created_by UUID NOT NULL, 
	customer_id UUID, 
	title VARCHAR(200) NOT NULL, 
	description TEXT, 
	due_date TIMESTAMP WITHOUT TIME ZONE, 
	priority VARCHAR(20), 
	status VARCHAR(20), 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(created_by) REFERENCES users (id), 
	FOREIGN KEY(customer_id) REFERENCES customers (id)
);

-- ── customer_addresses ──
CREATE TABLE IF NOT EXISTS customer_addresses (
	customer_id UUID NOT NULL, 
	label VARCHAR(50), 
	address_line1 VARCHAR(300) NOT NULL, 
	address_line2 VARCHAR(300), 
	city VARCHAR(100) NOT NULL, 
	state VARCHAR(100) NOT NULL, 
	pincode VARCHAR(10) NOT NULL, 
	latitude FLOAT, 
	longitude FLOAT, 
	is_default BOOLEAN, 
	location_source VARCHAR(50), 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(customer_id) REFERENCES customers (id)
);

-- ── customer_appliances ──
CREATE TABLE IF NOT EXISTS customer_appliances (
	id UUID NOT NULL, 
	customer_id UUID NOT NULL, 
	brand_id UUID, 
	type_id UUID, 
	appliance_category_id UUID, 
	category VARCHAR(100), 
	model VARCHAR(200), 
	serial_number VARCHAR(200), 
	purchase_date TIMESTAMP WITH TIME ZONE, 
	installation_date TIMESTAMP WITH TIME ZONE, 
	warranty_expiry TIMESTAMP WITH TIME ZONE, 
	status VARCHAR(30), 
	notes TEXT, 
	image_url VARCHAR(500), 
	is_active BOOLEAN, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	updated_at TIMESTAMP WITH TIME ZONE, 
	PRIMARY KEY (id), 
	FOREIGN KEY(customer_id) REFERENCES customers (id), 
	FOREIGN KEY(brand_id) REFERENCES appliance_brands (id), 
	FOREIGN KEY(type_id) REFERENCES appliance_types (id), 
	FOREIGN KEY(appliance_category_id) REFERENCES service_categories (id)
);

-- ── domain_services ──
CREATE TABLE IF NOT EXISTS domain_services (
	domain_id UUID NOT NULL, 
	service_id UUID NOT NULL, 
	is_featured BOOLEAN, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	CONSTRAINT uq_domain_service UNIQUE (domain_id, service_id), 
	FOREIGN KEY(domain_id) REFERENCES domains (id), 
	FOREIGN KEY(service_id) REFERENCES services (id)
);

-- ── inventory_reorder_rules ──
CREATE TABLE IF NOT EXISTS inventory_reorder_rules (
	id UUID NOT NULL, 
	item_id UUID NOT NULL, 
	warehouse_id UUID, 
	reorder_level INTEGER NOT NULL, 
	reorder_qty INTEGER NOT NULL, 
	preferred_vendor_id UUID, 
	is_active BOOLEAN, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id), 
	UNIQUE (item_id), 
	FOREIGN KEY(item_id) REFERENCES inventory_items (id), 
	FOREIGN KEY(warehouse_id) REFERENCES warehouses (id), 
	FOREIGN KEY(preferred_vendor_id) REFERENCES vendors (id)
);

-- ── leave_requests ──
CREATE TABLE IF NOT EXISTS leave_requests (
	id UUID NOT NULL, 
	technician_id UUID NOT NULL, 
	leave_type VARCHAR(30), 
	from_date DATE NOT NULL, 
	to_date DATE NOT NULL, 
	reason TEXT, 
	status VARCHAR(20), 
	approved_by UUID, 
	reviewed_at TIMESTAMP WITH TIME ZONE, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id), 
	FOREIGN KEY(technician_id) REFERENCES technicians (id), 
	FOREIGN KEY(approved_by) REFERENCES users (id)
);

-- ── referral_rewards ──
CREATE TABLE IF NOT EXISTS referral_rewards (
	user_id UUID NOT NULL, 
	referral_id UUID, 
	amount FLOAT NOT NULL, 
	type VARCHAR(30), 
	status VARCHAR(20), 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(user_id) REFERENCES users (id), 
	FOREIGN KEY(referral_id) REFERENCES referrals (id)
);

-- ── service_city_prices ──
CREATE TABLE IF NOT EXISTS service_city_prices (
	service_id UUID NOT NULL, 
	city_id UUID NOT NULL, 
	price FLOAT NOT NULL, 
	is_available BOOLEAN, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	CONSTRAINT uq_service_city_price UNIQUE (service_id, city_id), 
	FOREIGN KEY(service_id) REFERENCES services (id), 
	FOREIGN KEY(city_id) REFERENCES cities (id)
);

-- ── technician_availability ──
CREATE TABLE IF NOT EXISTS technician_availability (
	technician_id UUID NOT NULL, 
	day_of_week INTEGER NOT NULL, 
	start_time VARCHAR(8) NOT NULL, 
	end_time VARCHAR(8) NOT NULL, 
	is_available BOOLEAN, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(technician_id) REFERENCES technicians (id)
);

-- ── technician_skills ──
CREATE TABLE IF NOT EXISTS technician_skills (
	technician_id UUID NOT NULL, 
	service_id UUID NOT NULL, 
	proficiency VARCHAR(20), 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(technician_id) REFERENCES technicians (id), 
	FOREIGN KEY(service_id) REFERENCES services (id)
);

-- ── technician_stock ──
CREATE TABLE IF NOT EXISTS technician_stock (
	id UUID NOT NULL, 
	technician_id UUID NOT NULL, 
	item_id UUID NOT NULL, 
	quantity INTEGER, 
	assigned_qty INTEGER, 
	consumed_qty INTEGER, 
	returned_qty INTEGER, 
	updated_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id), 
	CONSTRAINT uq_tech_item UNIQUE (technician_id, item_id), 
	FOREIGN KEY(technician_id) REFERENCES technicians (id), 
	FOREIGN KEY(item_id) REFERENCES inventory_items (id)
);

-- ── transfer_challans ──
CREATE TABLE IF NOT EXISTS transfer_challans (
	id UUID NOT NULL, 
	challan_no VARCHAR(30) NOT NULL, 
	from_warehouse_id UUID, 
	to_warehouse_id UUID, 
	to_technician_id UUID, 
	items_json TEXT NOT NULL, 
	total_qty INTEGER, 
	total_value FLOAT, 
	status VARCHAR(20), 
	notes TEXT, 
	reference_no VARCHAR(100), 
	dispatched_at TIMESTAMP WITH TIME ZONE, 
	received_at TIMESTAMP WITH TIME ZONE, 
	created_by UUID, 
	received_by UUID, 
	is_active BOOLEAN, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id), 
	FOREIGN KEY(from_warehouse_id) REFERENCES warehouses (id), 
	FOREIGN KEY(to_warehouse_id) REFERENCES warehouses (id), 
	FOREIGN KEY(to_technician_id) REFERENCES technicians (id), 
	FOREIGN KEY(created_by) REFERENCES users (id), 
	FOREIGN KEY(received_by) REFERENCES users (id)
);

-- ── wallets ──
CREATE TABLE IF NOT EXISTS wallets (
	id UUID NOT NULL, 
	user_id UUID, 
	technician_id UUID, 
	balance FLOAT, 
	total_earned FLOAT, 
	total_withdrawn FLOAT, 
	is_active BOOLEAN, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	updated_at TIMESTAMP WITH TIME ZONE, 
	PRIMARY KEY (id), 
	FOREIGN KEY(user_id) REFERENCES users (id), 
	UNIQUE (technician_id), 
	FOREIGN KEY(technician_id) REFERENCES technicians (id)
);

-- ── warehouse_stock ──
CREATE TABLE IF NOT EXISTS warehouse_stock (
	id UUID NOT NULL, 
	warehouse_id UUID NOT NULL, 
	item_id UUID NOT NULL, 
	quantity INTEGER, 
	reserved_qty INTEGER, 
	updated_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id), 
	CONSTRAINT uq_wh_item UNIQUE (warehouse_id, item_id), 
	FOREIGN KEY(warehouse_id) REFERENCES warehouses (id), 
	FOREIGN KEY(item_id) REFERENCES inventory_items (id)
);

-- ── amc_visits ──
CREATE TABLE IF NOT EXISTS amc_visits (
	amc_id UUID NOT NULL, 
	scheduled_date TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	technician_id UUID, 
	notes TEXT, 
	status VARCHAR(20), 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(amc_id) REFERENCES amc_subscriptions (id), 
	FOREIGN KEY(technician_id) REFERENCES technicians (id)
);

-- ── bookings ──
CREATE TABLE IF NOT EXISTS bookings (
	booking_number VARCHAR(30) NOT NULL, 
	customer_id UUID NOT NULL, 
	technician_id UUID, 
	service_id UUID, 
	address_id UUID, 
	service_name VARCHAR(200), 
	address_line TEXT, 
	city VARCHAR(100), 
	pincode VARCHAR(10), 
	coupon_id UUID, 
	coupon_code VARCHAR(50), 
	coupon_discount FLOAT, 
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
	pre_cancel_status VARCHAR(30), 
	pre_reschedule_status VARCHAR(30), 
	domain_id UUID, 
	repeat_of_booking_id UUID, 
	city_id UUID, 
	inspection_notes TEXT, 
	inspection_photos TEXT, 
	inspection_submitted_by VARCHAR(20), 
	technician_to_customer_rating FLOAT, 
	technician_to_customer_notes TEXT, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	UNIQUE (booking_number), 
	FOREIGN KEY(customer_id) REFERENCES customers (id), 
	FOREIGN KEY(technician_id) REFERENCES technicians (id), 
	FOREIGN KEY(service_id) REFERENCES services (id), 
	FOREIGN KEY(address_id) REFERENCES customer_addresses (id), 
	FOREIGN KEY(domain_id) REFERENCES domains (id), 
	FOREIGN KEY(repeat_of_booking_id) REFERENCES bookings (id), 
	FOREIGN KEY(city_id) REFERENCES cities (id)
);

-- ── domain_service_overrides ──
CREATE TABLE IF NOT EXISTS domain_service_overrides (
	domain_service_id UUID NOT NULL, 
	image_url VARCHAR(500), 
	thumbnail_url VARCHAR(500), 
	meta_title VARCHAR(200), 
	meta_description TEXT, 
	meta_keywords TEXT, 
	og_title VARCHAR(200), 
	og_description TEXT, 
	og_image_url VARCHAR(500), 
	includes_json TEXT, 
	excludes_json TEXT, 
	faqs_json TEXT, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	CONSTRAINT uq_domain_service_override UNIQUE (domain_service_id), 
	FOREIGN KEY(domain_service_id) REFERENCES domain_services (id) ON DELETE CASCADE
);

-- ── wallet_transactions ──
CREATE TABLE IF NOT EXISTS wallet_transactions (
	id UUID NOT NULL, 
	wallet_id UUID NOT NULL, 
	transaction_type VARCHAR(30), 
	amount FLOAT NOT NULL, 
	balance_before FLOAT, 
	balance_after FLOAT, 
	reference_id VARCHAR(200), 
	description TEXT, 
	status VARCHAR(20), 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id), 
	FOREIGN KEY(wallet_id) REFERENCES wallets (id)
);

-- ── appliance_service_history ──
CREATE TABLE IF NOT EXISTS appliance_service_history (
	id UUID NOT NULL, 
	appliance_id UUID NOT NULL, 
	booking_id UUID, 
	service_date TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	issue_reported TEXT, 
	work_done TEXT, 
	technician_id UUID, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id), 
	FOREIGN KEY(appliance_id) REFERENCES customer_appliances (id), 
	FOREIGN KEY(booking_id) REFERENCES bookings (id), 
	FOREIGN KEY(technician_id) REFERENCES technicians (id)
);

-- ── assignment_history ──
CREATE TABLE IF NOT EXISTS assignment_history (
	booking_id UUID NOT NULL, 
	technician_id UUID NOT NULL, 
	assigned_by UUID, 
	assignment_type assignmenttype NOT NULL, 
	status assignmentstatus NOT NULL, 
	score FLOAT, 
	notes TEXT, 
	response_deadline TIMESTAMP WITH TIME ZONE, 
	screen_shown_at TIMESTAMP WITH TIME ZONE, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(booking_id) REFERENCES bookings (id), 
	FOREIGN KEY(technician_id) REFERENCES technicians (id), 
	FOREIGN KEY(assigned_by) REFERENCES users (id)
);

-- ── booking_part_usage ──
CREATE TABLE IF NOT EXISTS booking_part_usage (
	id UUID NOT NULL, 
	booking_id UUID NOT NULL, 
	item_id UUID NOT NULL, 
	technician_id UUID, 
	warehouse_id UUID, 
	quantity INTEGER NOT NULL, 
	unit_cost FLOAT, 
	unit_price FLOAT, 
	total_amount FLOAT, 
	notes TEXT, 
	created_by UUID, 
	is_active BOOLEAN, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id), 
	FOREIGN KEY(booking_id) REFERENCES bookings (id), 
	FOREIGN KEY(item_id) REFERENCES inventory_items (id), 
	FOREIGN KEY(technician_id) REFERENCES technicians (id), 
	FOREIGN KEY(warehouse_id) REFERENCES warehouses (id), 
	FOREIGN KEY(created_by) REFERENCES users (id)
);

-- ── booking_status_logs ──
CREATE TABLE IF NOT EXISTS booking_status_logs (
	booking_id UUID NOT NULL, 
	status bookingstatus NOT NULL, 
	changed_by UUID, 
	notes TEXT, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(booking_id) REFERENCES bookings (id), 
	FOREIGN KEY(changed_by) REFERENCES users (id)
);

-- ── call_logs ──
CREATE TABLE IF NOT EXISTS call_logs (
	customer_id UUID NOT NULL, 
	cco_id UUID NOT NULL, 
	booking_id UUID, 
	direction VARCHAR(20), 
	duration_seconds INTEGER, 
	outcome VARCHAR(40) NOT NULL, 
	summary TEXT NOT NULL, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(customer_id) REFERENCES customers (id), 
	FOREIGN KEY(cco_id) REFERENCES users (id), 
	FOREIGN KEY(booking_id) REFERENCES bookings (id)
);

-- ── commissions ──
CREATE TABLE IF NOT EXISTS commissions (
	id UUID NOT NULL, 
	technician_id UUID NOT NULL, 
	booking_id UUID, 
	rule_id UUID, 
	base_amount FLOAT, 
	commission_amount FLOAT, 
	status VARCHAR(20), 
	payout_date TIMESTAMP WITH TIME ZONE, 
	notes TEXT, 
	item_type VARCHAR(20), 
	item_name VARCHAR(300), 
	item_quantity INTEGER, 
	part_source VARCHAR(30), 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id), 
	FOREIGN KEY(technician_id) REFERENCES technicians (id), 
	FOREIGN KEY(booking_id) REFERENCES bookings (id), 
	FOREIGN KEY(rule_id) REFERENCES commission_rules (id)
);

-- ── coupon_usages ──
CREATE TABLE IF NOT EXISTS coupon_usages (
	id UUID NOT NULL, 
	coupon_id UUID NOT NULL, 
	customer_id UUID, 
	booking_id UUID, 
	discount_amount FLOAT, 
	is_active BOOLEAN, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	updated_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id), 
	FOREIGN KEY(coupon_id) REFERENCES coupons (id), 
	FOREIGN KEY(customer_id) REFERENCES customers (id), 
	FOREIGN KEY(booking_id) REFERENCES bookings (id)
);

-- ── direct_sales ──
CREATE TABLE IF NOT EXISTS direct_sales (
	id UUID NOT NULL, 
	sale_no VARCHAR(30) NOT NULL, 
	warehouse_id UUID NOT NULL, 
	customer_id UUID, 
	customer_name VARCHAR(200), 
	customer_mobile VARCHAR(20), 
	booking_id UUID, 
	items_json TEXT NOT NULL, 
	subtotal FLOAT, 
	gst_amount FLOAT, 
	total_amount FLOAT, 
	payment_method VARCHAR(30), 
	payment_status VARCHAR(20), 
	notes TEXT, 
	sold_by UUID, 
	is_active BOOLEAN, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id), 
	FOREIGN KEY(warehouse_id) REFERENCES warehouses (id), 
	FOREIGN KEY(customer_id) REFERENCES customers (id), 
	FOREIGN KEY(booking_id) REFERENCES bookings (id), 
	FOREIGN KEY(sold_by) REFERENCES users (id)
);

-- ── escalations ──
CREATE TABLE IF NOT EXISTS escalations (
	created_by UUID NOT NULL, 
	booking_id UUID, 
	subject VARCHAR(300) NOT NULL, 
	description TEXT NOT NULL, 
	priority VARCHAR(20), 
	status escalationstatus, 
	assigned_to UUID, 
	resolved_by UUID, 
	resolved_at TIMESTAMP WITHOUT TIME ZONE, 
	resolution_notes TEXT, 
	escalation_level INTEGER, 
	escalation_notes TEXT, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(created_by) REFERENCES users (id), 
	FOREIGN KEY(booking_id) REFERENCES bookings (id), 
	FOREIGN KEY(assigned_to) REFERENCES users (id), 
	FOREIGN KEY(resolved_by) REFERENCES users (id)
);

-- ── quotations ──
CREATE TABLE IF NOT EXISTS quotations (
	quotation_number VARCHAR(30) NOT NULL, 
	booking_id UUID NOT NULL, 
	domain_id UUID, 
	created_by UUID NOT NULL, 
	original_quotation_id UUID, 
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
	coupon_id UUID, 
	coupon_code VARCHAR(50), 
	coupon_discount FLOAT, 
	submitted_at TIMESTAMP WITHOUT TIME ZONE, 
	approved_at TIMESTAMP WITHOUT TIME ZONE, 
	approved_by UUID, 
	rejection_reason TEXT, 
	tax_mode VARCHAR(10) NOT NULL, 
	customer_gst_number VARCHAR(20), 
	customer_gst_name VARCHAR(200), 
	customer_gst_address TEXT, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	UNIQUE (quotation_number), 
	FOREIGN KEY(booking_id) REFERENCES bookings (id), 
	FOREIGN KEY(domain_id) REFERENCES domains (id), 
	FOREIGN KEY(created_by) REFERENCES users (id), 
	FOREIGN KEY(original_quotation_id) REFERENCES quotations (id), 
	FOREIGN KEY(approved_by) REFERENCES users (id)
);

-- ── sla_breaches ──
CREATE TABLE IF NOT EXISTS sla_breaches (
	id UUID NOT NULL, 
	booking_id UUID NOT NULL, 
	policy_id UUID, 
	breach_type VARCHAR(30), 
	breached_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	notes TEXT, 
	PRIMARY KEY (id), 
	FOREIGN KEY(booking_id) REFERENCES bookings (id), 
	FOREIGN KEY(policy_id) REFERENCES sla_policies (id)
);

-- ── stock_movements ──
CREATE TABLE IF NOT EXISTS stock_movements (
	id UUID NOT NULL, 
	item_id UUID NOT NULL, 
	movement_type VARCHAR(30) NOT NULL, 
	quantity INTEGER NOT NULL, 
	from_warehouse_id UUID, 
	to_warehouse_id UUID, 
	technician_id UUID, 
	booking_id UUID, 
	reference_no VARCHAR(100), 
	batch_no VARCHAR(100), 
	reason VARCHAR(300), 
	notes TEXT, 
	unit_cost FLOAT, 
	performed_by UUID, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id), 
	FOREIGN KEY(item_id) REFERENCES inventory_items (id), 
	FOREIGN KEY(from_warehouse_id) REFERENCES warehouses (id), 
	FOREIGN KEY(to_warehouse_id) REFERENCES warehouses (id), 
	FOREIGN KEY(technician_id) REFERENCES technicians (id), 
	FOREIGN KEY(booking_id) REFERENCES bookings (id), 
	FOREIGN KEY(performed_by) REFERENCES users (id)
);

-- ── technician_ratings ──
CREATE TABLE IF NOT EXISTS technician_ratings (
	technician_id UUID NOT NULL, 
	booking_id UUID, 
	customer_id UUID, 
	rating FLOAT NOT NULL, 
	review TEXT, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(technician_id) REFERENCES technicians (id), 
	FOREIGN KEY(booking_id) REFERENCES bookings (id), 
	FOREIGN KEY(customer_id) REFERENCES customers (id)
);

-- ── technician_stock_logs ──
CREATE TABLE IF NOT EXISTS technician_stock_logs (
	id UUID NOT NULL, 
	technician_id UUID NOT NULL, 
	item_id UUID NOT NULL, 
	booking_id UUID, 
	warehouse_id UUID, 
	status VARCHAR(30) NOT NULL, 
	quantity INTEGER NOT NULL, 
	notes TEXT, 
	performed_by UUID, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id), 
	FOREIGN KEY(technician_id) REFERENCES technicians (id), 
	FOREIGN KEY(item_id) REFERENCES inventory_items (id), 
	FOREIGN KEY(booking_id) REFERENCES bookings (id), 
	FOREIGN KEY(warehouse_id) REFERENCES warehouses (id), 
	FOREIGN KEY(performed_by) REFERENCES users (id)
);

-- ── tracking_locations ──
CREATE TABLE IF NOT EXISTS tracking_locations (
	technician_id UUID NOT NULL, 
	booking_id UUID, 
	latitude FLOAT NOT NULL, 
	longitude FLOAT NOT NULL, 
	accuracy FLOAT, 
	speed FLOAT, 
	heading FLOAT, 
	source VARCHAR(50) NOT NULL, 
	recorded_at TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(technician_id) REFERENCES technicians (id), 
	FOREIGN KEY(booking_id) REFERENCES bookings (id)
);

-- ── warranties ──
CREATE TABLE IF NOT EXISTS warranties (
	customer_id UUID NOT NULL, 
	booking_id UUID, 
	warranty_type VARCHAR(30), 
	description TEXT NOT NULL, 
	expiry_date TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	parts_covered TEXT, 
	status warrantystatus, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(customer_id) REFERENCES customers (id), 
	FOREIGN KEY(booking_id) REFERENCES bookings (id)
);

-- ── withdrawal_requests ──
CREATE TABLE IF NOT EXISTS withdrawal_requests (
	id UUID NOT NULL, 
	technician_id UUID NOT NULL, 
	wallet_id UUID NOT NULL, 
	amount FLOAT NOT NULL, 
	status VARCHAR(20), 
	upi_id VARCHAR(200), 
	bank_account VARCHAR(200), 
	bank_ifsc VARCHAR(20), 
	bank_name VARCHAR(200), 
	notes TEXT, 
	admin_notes TEXT, 
	reviewed_by UUID, 
	reviewed_at TIMESTAMP WITH TIME ZONE, 
	wallet_txn_id UUID, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	updated_at TIMESTAMP WITH TIME ZONE, 
	PRIMARY KEY (id), 
	FOREIGN KEY(technician_id) REFERENCES technicians (id), 
	FOREIGN KEY(wallet_id) REFERENCES wallets (id), 
	FOREIGN KEY(wallet_txn_id) REFERENCES wallet_transactions (id)
);

-- ── invoices ──
CREATE TABLE IF NOT EXISTS invoices (
	invoice_number VARCHAR(30) NOT NULL, 
	booking_id UUID NOT NULL, 
	domain_id UUID, 
	quotation_id UUID NOT NULL, 
	generated_by UUID NOT NULL, 
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
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	UNIQUE (invoice_number), 
	FOREIGN KEY(booking_id) REFERENCES bookings (id), 
	FOREIGN KEY(domain_id) REFERENCES domains (id), 
	UNIQUE (quotation_id), 
	FOREIGN KEY(quotation_id) REFERENCES quotations (id), 
	FOREIGN KEY(generated_by) REFERENCES users (id)
);

-- ── quotation_appliances ──
CREATE TABLE IF NOT EXISTS quotation_appliances (
	quotation_id UUID NOT NULL, 
	appliance_id UUID, 
	appliance_label VARCHAR(300) NOT NULL, 
	is_repeat_complaint BOOLEAN, 
	repeat_booking_id UUID, 
	repeat_confirmed_at TIMESTAMP WITHOUT TIME ZONE, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(quotation_id) REFERENCES quotations (id), 
	FOREIGN KEY(appliance_id) REFERENCES customer_appliances (id), 
	FOREIGN KEY(repeat_booking_id) REFERENCES bookings (id)
);

-- ── quotation_part_items ──
CREATE TABLE IF NOT EXISTS quotation_part_items (
	quotation_id UUID NOT NULL, 
	part_name VARCHAR(200) NOT NULL, 
	part_source partsource, 
	quantity INTEGER, 
	unit_price FLOAT, 
	purchase_price FLOAT, 
	total_price FLOAT, 
	vendor_name VARCHAR(200), 
	bill_number VARCHAR(100), 
	notes TEXT, 
	inventory_item_id UUID, 
	is_pending_verify INTEGER, 
	is_repeat_complaint BOOLEAN, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(quotation_id) REFERENCES quotations (id), 
	FOREIGN KEY(inventory_item_id) REFERENCES inventory_items (id)
);

-- ── quotation_service_items ──
CREATE TABLE IF NOT EXISTS quotation_service_items (
	quotation_id UUID NOT NULL, 
	service_id UUID, 
	service_name VARCHAR(200) NOT NULL, 
	quantity INTEGER, 
	unit_price FLOAT, 
	total_price FLOAT, 
	appliance_label VARCHAR(300), 
	is_repeat_complaint BOOLEAN, 
	is_pending_verify INTEGER NOT NULL, 
	custom_service_name TEXT, 
	tech_commission_override FLOAT, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(quotation_id) REFERENCES quotations (id), 
	FOREIGN KEY(service_id) REFERENCES services (id)
);

-- ── quotation_status_logs ──
CREATE TABLE IF NOT EXISTS quotation_status_logs (
	quotation_id UUID NOT NULL, 
	status quotationstatus NOT NULL, 
	changed_by UUID, 
	notes TEXT, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(quotation_id) REFERENCES quotations (id), 
	FOREIGN KEY(changed_by) REFERENCES users (id)
);

-- ── warranty_claims ──
CREATE TABLE IF NOT EXISTS warranty_claims (
	warranty_id UUID NOT NULL, 
	claimed_by UUID NOT NULL, 
	booking_id UUID, 
	description TEXT NOT NULL, 
	status claimstatus, 
	approved_by UUID, 
	rejected_by UUID, 
	notes TEXT, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(warranty_id) REFERENCES warranties (id), 
	FOREIGN KEY(claimed_by) REFERENCES users (id), 
	FOREIGN KEY(booking_id) REFERENCES bookings (id), 
	FOREIGN KEY(approved_by) REFERENCES users (id), 
	FOREIGN KEY(rejected_by) REFERENCES users (id)
);

-- ── payment_transactions ──
CREATE TABLE IF NOT EXISTS payment_transactions (
	transaction_number VARCHAR(30) NOT NULL, 
	invoice_id UUID NOT NULL, 
	booking_id UUID NOT NULL, 
	created_by UUID, 
	verified_by UUID, 
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
	collected_by_role VARCHAR(30), 
	cash_collection_status cashcollectionstatus, 
	due_collect_at TIMESTAMP WITH TIME ZONE, 
	last_reminder_at TIMESTAMP WITH TIME ZONE, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	UNIQUE (transaction_number), 
	FOREIGN KEY(invoice_id) REFERENCES invoices (id), 
	FOREIGN KEY(booking_id) REFERENCES bookings (id), 
	FOREIGN KEY(created_by) REFERENCES users (id), 
	FOREIGN KEY(verified_by) REFERENCES users (id)
);

-- ── cash_collection_records ──
CREATE TABLE IF NOT EXISTS cash_collection_records (
	payment_transaction_id UUID NOT NULL, 
	booking_id UUID NOT NULL, 
	invoice_id UUID NOT NULL, 
	technician_id UUID NOT NULL, 
	customer_id UUID NOT NULL, 
	amount FLOAT NOT NULL, 
	status cashcollectionstatus NOT NULL, 
	collected_by UUID, 
	collected_at TIMESTAMP WITHOUT TIME ZONE, 
	notes TEXT, 
	id UUID NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	is_active BOOLEAN, 
	PRIMARY KEY (id), 
	UNIQUE (payment_transaction_id), 
	FOREIGN KEY(payment_transaction_id) REFERENCES payment_transactions (id), 
	FOREIGN KEY(booking_id) REFERENCES bookings (id), 
	FOREIGN KEY(invoice_id) REFERENCES invoices (id), 
	FOREIGN KEY(technician_id) REFERENCES technicians (id), 
	FOREIGN KEY(customer_id) REFERENCES customers (id), 
	FOREIGN KEY(collected_by) REFERENCES users (id)
);

-- ── refunds ──
CREATE TABLE IF NOT EXISTS refunds (
	id UUID NOT NULL, 
	booking_id UUID NOT NULL, 
	payment_id UUID, 
	amount FLOAT NOT NULL, 
	reason TEXT NOT NULL, 
	status VARCHAR(20), 
	refund_method VARCHAR(30), 
	processed_by UUID, 
	processed_at TIMESTAMP WITH TIME ZONE, 
	gateway_refund_id VARCHAR(200), 
	notes TEXT, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (id), 
	FOREIGN KEY(booking_id) REFERENCES bookings (id), 
	FOREIGN KEY(payment_id) REFERENCES payment_transactions (id), 
	FOREIGN KEY(processed_by) REFERENCES users (id)
);

-- ============================================================
-- COLUMN PATCHES (idempotent — IF NOT EXISTS)
-- ============================================================
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS is_online BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS fcm_token VARCHAR(500);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS last_lat DOUBLE PRECISION;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS last_lng DOUBLE PRECISION;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS last_seen_at TIMESTAMP WITH TIME ZONE;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS auto_assign_eligible BOOLEAN NOT NULL DEFAULT TRUE;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS alternate_mobile VARCHAR(20);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS dob DATE;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS gender VARCHAR(10);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS pincode VARCHAR(10);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS identity_type VARCHAR(50);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS identity_number VARCHAR(50);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS emergency_contact_name VARCHAR(150);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS emergency_contact_mobile VARCHAR(20);
ALTER TABLE users ADD COLUMN IF NOT EXISTS fcm_token VARCHAR(500);
ALTER TABLE users ADD COLUMN IF NOT EXISTS firebase_uid VARCHAR(128);
ALTER TABLE users ADD COLUMN IF NOT EXISTS id_proof_url VARCHAR(500);
ALTER TABLE users ADD COLUMN IF NOT EXISTS address_proof_url VARCHAR(500);
ALTER TABLE users ADD COLUMN IF NOT EXISTS id_proof_type VARCHAR(50);
ALTER TABLE users ADD COLUMN IF NOT EXISTS address_proof_type VARCHAR(50);
ALTER TABLE services ADD COLUMN IF NOT EXISTS is_pending_verify INTEGER NOT NULL DEFAULT 0;
ALTER TABLE services ADD COLUMN IF NOT EXISTS suggested_by_tech UUID;
ALTER TABLE quotation_service_items ADD COLUMN IF NOT EXISTS is_pending_verify INTEGER NOT NULL DEFAULT 0;
ALTER TABLE quotation_service_items ADD COLUMN IF NOT EXISTS custom_service_name TEXT;
ALTER TABLE quotation_service_items ADD COLUMN IF NOT EXISTS tech_commission_override DOUBLE PRECISION;
ALTER TABLE payment_transactions ADD COLUMN IF NOT EXISTS due_collect_at TIMESTAMP WITH TIME ZONE;
ALTER TABLE payment_transactions ADD COLUMN IF NOT EXISTS last_reminder_at TIMESTAMP WITH TIME ZONE;
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS coupon_id UUID;
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS coupon_code VARCHAR(50);
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS coupon_discount FLOAT DEFAULT 0.0;
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS city_id UUID;

-- ── quotation_service_items.service_id → nullable ──
DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns
               WHERE table_name='quotation_service_items' AND column_name='service_id' AND is_nullable='NO')
    THEN ALTER TABLE quotation_service_items ALTER COLUMN service_id DROP NOT NULL; END IF;
END $$;

-- ── enum: bookingstatus ──
ALTER TYPE bookingstatus ADD VALUE IF NOT EXISTS 'PENDING_VERIFICATION';
ALTER TYPE bookingstatus ADD VALUE IF NOT EXISTS 'TECHNICIAN_ACCEPTED';
ALTER TYPE bookingstatus ADD VALUE IF NOT EXISTS 'INVOICE_GENERATED';
ALTER TYPE bookingstatus ADD VALUE IF NOT EXISTS 'PAYMENT_PENDING';
ALTER TYPE bookingstatus ADD VALUE IF NOT EXISTS 'WORK_STARTED';
ALTER TYPE bookingstatus ADD VALUE IF NOT EXISTS 'WORK_PAUSED';
ALTER TYPE bookingstatus ADD VALUE IF NOT EXISTS 'REFUND_INITIATED';
ALTER TYPE bookingstatus ADD VALUE IF NOT EXISTS 'PAID';
ALTER TYPE bookingstatus ADD VALUE IF NOT EXISTS 'CLOSED';
ALTER TYPE bookingstatus ADD VALUE IF NOT EXISTS 'SETTLED';
ALTER TYPE bookingstatus ADD VALUE IF NOT EXISTS 'QUOTATION_APPROVED';
ALTER TYPE bookingstatus ADD VALUE IF NOT EXISTS 'CANCELLATION_REQUESTED';

-- ── enum: paymentstatus ──
ALTER TYPE paymentstatus ADD VALUE IF NOT EXISTS 'CANCELLED';

-- ── alembic_version: stamp 055 ──
DELETE FROM alembic_version;
INSERT INTO alembic_version (version_num) VALUES ('055');

-- ── verify ──
SELECT version_num FROM alembic_version;
\dt