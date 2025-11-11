-- ============================================================================
-- Lead Analytics Dashboard - Database Schema
-- Version: 1.0
-- Database: PostgreSQL 14+
-- Created: 2025-11-11
-- ============================================================================

-- ============================================================================
-- 1. EXTENSIONS
-- ============================================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";      -- For UUID generation
CREATE EXTENSION IF NOT EXISTS "pg_trgm";        -- For text search/fuzzy matching

-- ============================================================================
-- 2. ENUMS
-- ============================================================================

CREATE TYPE user_role AS ENUM ('admin', 'manager', 'analyst', 'viewer');
CREATE TYPE client_status AS ENUM ('Active', 'Inactive', 'Pending');
CREATE TYPE platform_type AS ENUM ('google', 'meta');
CREATE TYPE campaign_status AS ENUM ('Active', 'Paused', 'Completed');
CREATE TYPE ad_type AS ENUM ('Search', 'Display', 'YouTube', 'Shopping', 'Facebook', 'Instagram', 'Messenger', 'Audience Network');
CREATE TYPE creative_type AS ENUM ('Video', 'Static', 'Carousel');
CREATE TYPE lead_stage AS ENUM ('New', 'Contacted', 'Qualified', 'Converted', 'Lost');
CREATE TYPE upload_type AS ENUM ('google_ads', 'meta_ads', 'leads');
CREATE TYPE upload_status AS ENUM ('pending', 'processing', 'completed', 'failed');

-- ============================================================================
-- 3. USERS & AUTHENTICATION
-- ============================================================================

CREATE TABLE users (
    user_id VARCHAR(50) PRIMARY KEY DEFAULT 'USR' || LPAD(nextval('users_seq')::TEXT, 6, '0'),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    role user_role NOT NULL DEFAULT 'viewer',
    permissions JSONB DEFAULT '[]'::JSONB,
    is_active BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE SEQUENCE users_seq START 1;

-- Index for email lookups
CREATE INDEX idx_users_email ON users(email);

-- ============================================================================
-- 4. CLIENTS
-- ============================================================================

CREATE TABLE clients (
    client_id VARCHAR(50) PRIMARY KEY DEFAULT 'CLT' || LPAD(nextval('clients_seq')::TEXT, 6, '0'),
    client_name VARCHAR(255) NOT NULL,
    industry VARCHAR(100),
    contact_email VARCHAR(255),
    contact_phone VARCHAR(20),
    logo_url TEXT,
    status client_status DEFAULT 'Active',
    date_created DATE DEFAULT CURRENT_DATE,
    created_by VARCHAR(50) REFERENCES users(user_id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE SEQUENCE clients_seq START 1;

-- Indexes
CREATE INDEX idx_clients_status ON clients(status);
CREATE INDEX idx_clients_name ON clients(client_name);

-- ============================================================================
-- 5. CAMPAIGNS
-- ============================================================================

CREATE TABLE campaigns (
    campaign_id VARCHAR(50) PRIMARY KEY,
    campaign_name VARCHAR(255) NOT NULL,
    client_id VARCHAR(50) NOT NULL REFERENCES clients(client_id) ON DELETE CASCADE,
    platform platform_type NOT NULL,
    status campaign_status DEFAULT 'Active',
    start_date DATE,
    end_date DATE,
    budget DECIMAL(12, 2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_campaigns_client ON campaigns(client_id);
CREATE INDEX idx_campaigns_platform ON campaigns(platform);
CREATE INDEX idx_campaigns_status ON campaigns(status);
CREATE INDEX idx_campaigns_dates ON campaigns(start_date, end_date);
CREATE INDEX idx_campaigns_name ON campaigns USING gin(campaign_name gin_trgm_ops);

-- ============================================================================
-- 6. AD GROUPS (for Google Ads) & AD SETS (for Meta Ads)
-- ============================================================================

CREATE TABLE adgroups (
    adgroup_id VARCHAR(50) PRIMARY KEY,
    adgroup_name VARCHAR(255) NOT NULL,
    campaign_id VARCHAR(50) NOT NULL REFERENCES campaigns(campaign_id) ON DELETE CASCADE,
    platform platform_type NOT NULL,
    status campaign_status DEFAULT 'Active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_adgroups_campaign ON adgroups(campaign_id);
CREATE INDEX idx_adgroups_platform ON adgroups(platform);

-- ============================================================================
-- 7. ADS / CREATIVES
-- ============================================================================

CREATE TABLE ads (
    ad_id VARCHAR(50) PRIMARY KEY,
    ad_name VARCHAR(255) NOT NULL,
    adgroup_id VARCHAR(50) NOT NULL REFERENCES adgroups(adgroup_id) ON DELETE CASCADE,
    campaign_id VARCHAR(50) NOT NULL REFERENCES campaigns(campaign_id) ON DELETE CASCADE,
    platform platform_type NOT NULL,
    ad_type ad_type,
    creative_type creative_type,              -- Only for Meta Ads
    form_id VARCHAR(100),                      -- For Meta lead forms
    landing_page_url TEXT,
    status campaign_status DEFAULT 'Active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_ads_adgroup ON ads(adgroup_id);
CREATE INDEX idx_ads_campaign ON ads(campaign_id);
CREATE INDEX idx_ads_creative_type ON ads(creative_type);

-- ============================================================================
-- 8. PERFORMANCE DATA
-- ============================================================================

CREATE TABLE performance (
    performance_id BIGSERIAL PRIMARY KEY,
    date DATE NOT NULL,
    client_id VARCHAR(50) NOT NULL REFERENCES clients(client_id) ON DELETE CASCADE,
    campaign_id VARCHAR(50) NOT NULL REFERENCES campaigns(campaign_id) ON DELETE CASCADE,
    adgroup_id VARCHAR(50) REFERENCES adgroups(adgroup_id) ON DELETE CASCADE,
    ad_id VARCHAR(50) REFERENCES ads(ad_id) ON DELETE CASCADE,
    platform platform_type NOT NULL,

    -- Location/Targeting
    location VARCHAR(100),
    region VARCHAR(100),
    keyword TEXT,
    placement VARCHAR(100),                    -- For Meta: Feed, Stories, etc.

    -- Performance Metrics
    spend DECIMAL(12, 2) DEFAULT 0,
    impressions INTEGER DEFAULT 0,
    clicks INTEGER DEFAULT 0,
    conversions INTEGER DEFAULT 0,              -- From ad platform

    -- Calculated Metrics (can be calculated on-the-fly or stored)
    ctr DECIMAL(5, 2),                          -- Click-Through Rate
    cpc DECIMAL(10, 2),                         -- Cost Per Click

    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Unique constraint to prevent duplicate records
    UNIQUE(date, campaign_id, adgroup_id, ad_id, location, keyword, placement)
);

-- Indexes for performance queries
CREATE INDEX idx_performance_date ON performance(date);
CREATE INDEX idx_performance_client ON performance(client_id);
CREATE INDEX idx_performance_campaign ON performance(campaign_id);
CREATE INDEX idx_performance_platform ON performance(platform);
CREATE INDEX idx_performance_composite ON performance(date, client_id, platform);

-- Partial index for recent data (last 90 days)
CREATE INDEX idx_performance_recent ON performance(date)
    WHERE date >= CURRENT_DATE - INTERVAL '90 days';

-- ============================================================================
-- 9. LEADS
-- ============================================================================

CREATE TABLE leads (
    lead_id VARCHAR(50) PRIMARY KEY DEFAULT 'LED' || LPAD(nextval('leads_seq')::TEXT, 6, '0'),

    -- Lead Information
    lead_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    city VARCHAR(100),

    -- Source & Attribution
    source VARCHAR(100) NOT NULL,               -- Google Search, Meta-FB, etc.
    utm_url TEXT,
    campaign_id VARCHAR(50) REFERENCES campaigns(campaign_id),
    adgroup_id VARCHAR(50) REFERENCES adgroups(adgroup_id),
    ad_id VARCHAR(50) REFERENCES ads(ad_id),
    keyword TEXT,

    -- Lead Details
    interested_service VARCHAR(255),
    lead_stage lead_stage NOT NULL DEFAULT 'New',
    lead_sub_stage VARCHAR(100),
    lead_date DATE NOT NULL,
    follow_up_date DATE,

    -- Revenue
    revenue_generated DECIMAL(12, 2) DEFAULT 0,

    -- Notes
    remarks TEXT,

    -- Custom Fields (dynamic fields stored as JSONB)
    custom_fields JSONB DEFAULT '{}'::JSONB,

    -- Matching Metadata
    match_confidence INTEGER,                   -- 0-100 confidence score
    match_method VARCHAR(50),                   -- exact_hierarchy, campaign_id, utm_extraction, fuzzy_match
    is_matched BOOLEAN DEFAULT FALSE,

    -- Duplicate Detection
    is_duplicate BOOLEAN DEFAULT FALSE,
    duplicate_of VARCHAR(50) REFERENCES leads(lead_id),

    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE SEQUENCE leads_seq START 1;

-- Indexes
CREATE INDEX idx_leads_campaign ON leads(campaign_id);
CREATE INDEX idx_leads_email ON leads(email);
CREATE INDEX idx_leads_phone ON leads(phone);
CREATE INDEX idx_leads_stage ON leads(lead_stage);
CREATE INDEX idx_leads_date ON leads(lead_date);
CREATE INDEX idx_leads_source ON leads(source);
CREATE INDEX idx_leads_matched ON leads(is_matched);

-- Composite index for duplicate detection
CREATE INDEX idx_leads_duplicate_check ON leads(email, phone, lead_date);

-- GIN index for custom fields JSONB search
CREATE INDEX idx_leads_custom_fields ON leads USING gin(custom_fields);

-- ============================================================================
-- 10. UPLOAD HISTORY
-- ============================================================================

CREATE TABLE upload_history (
    upload_id VARCHAR(50) PRIMARY KEY DEFAULT 'UPL' || LPAD(nextval('upload_history_seq')::TEXT, 6, '0'),
    upload_type upload_type NOT NULL,
    client_id VARCHAR(50) REFERENCES clients(client_id) ON DELETE CASCADE,
    file_name VARCHAR(255) NOT NULL,
    file_size BIGINT,                           -- Size in bytes

    -- Upload metadata
    uploaded_by VARCHAR(50) REFERENCES users(user_id),
    uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Processing status
    status upload_status DEFAULT 'pending',
    started_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,

    -- Results
    rows_total INTEGER DEFAULT 0,
    rows_imported INTEGER DEFAULT 0,
    rows_failed INTEGER DEFAULT 0,
    rows_warnings INTEGER DEFAULT 0,

    -- Date range detected in uploaded data
    date_range_from DATE,
    date_range_to DATE,

    -- Errors and warnings
    errors JSONB DEFAULT '[]'::JSONB,
    warnings JSONB DEFAULT '[]'::JSONB,

    -- Custom fields detected (for leads upload)
    custom_fields_detected JSONB DEFAULT '[]'::JSONB
);

CREATE SEQUENCE upload_history_seq START 1;

-- Indexes
CREATE INDEX idx_upload_history_client ON upload_history(client_id);
CREATE INDEX idx_upload_history_type ON upload_history(upload_type);
CREATE INDEX idx_upload_history_status ON upload_history(status);
CREATE INDEX idx_upload_history_date ON upload_history(uploaded_at);

-- ============================================================================
-- 11. AGGREGATED VIEWS (Materialized Views for Performance)
-- ============================================================================

-- Daily Campaign Performance Summary
CREATE MATERIALIZED VIEW mv_daily_campaign_performance AS
SELECT
    p.date,
    p.client_id,
    c.client_name,
    p.campaign_id,
    cam.campaign_name,
    p.platform,

    -- Aggregated metrics
    SUM(p.spend) as total_spend,
    SUM(p.impressions) as total_impressions,
    SUM(p.clicks) as total_clicks,
    SUM(p.conversions) as total_conversions,

    -- Calculated metrics
    CASE
        WHEN SUM(p.impressions) > 0 THEN ROUND((SUM(p.clicks)::DECIMAL / SUM(p.impressions) * 100), 2)
        ELSE 0
    END as ctr,
    CASE
        WHEN SUM(p.clicks) > 0 THEN ROUND((SUM(p.spend) / SUM(p.clicks)), 2)
        ELSE 0
    END as cpc,

    -- Lead metrics (from leads table)
    COUNT(l.lead_id) as total_leads,
    COUNT(CASE WHEN l.lead_stage IN ('Qualified', 'Converted') THEN 1 END) as qualified_leads,
    CASE
        WHEN COUNT(l.lead_id) > 0 THEN
            ROUND((COUNT(CASE WHEN l.lead_stage IN ('Qualified', 'Converted') THEN 1 END)::DECIMAL / COUNT(l.lead_id) * 100), 1)
        ELSE 0
    END as qualification_rate,

    -- Cost metrics
    CASE
        WHEN COUNT(l.lead_id) > 0 THEN ROUND((SUM(p.spend) / COUNT(l.lead_id)), 2)
        ELSE 0
    END as cpl,
    CASE
        WHEN COUNT(CASE WHEN l.lead_stage IN ('Qualified', 'Converted') THEN 1 END) > 0 THEN
            ROUND((SUM(p.spend) / COUNT(CASE WHEN l.lead_stage IN ('Qualified', 'Converted') THEN 1 END)), 2)
        ELSE 0
    END as cpql,

    -- Revenue metrics
    SUM(l.revenue_generated) as revenue,
    CASE
        WHEN SUM(p.spend) > 0 THEN
            ROUND(((SUM(l.revenue_generated) - SUM(p.spend)) / SUM(p.spend) * 100), 0)
        ELSE 0
    END as roi

FROM performance p
JOIN clients c ON p.client_id = c.client_id
JOIN campaigns cam ON p.campaign_id = cam.campaign_id
LEFT JOIN leads l ON p.campaign_id = l.campaign_id AND p.date = l.lead_date
GROUP BY p.date, p.client_id, c.client_name, p.campaign_id, cam.campaign_name, p.platform;

-- Indexes on materialized view
CREATE INDEX idx_mv_daily_date ON mv_daily_campaign_performance(date);
CREATE INDEX idx_mv_daily_client ON mv_daily_campaign_performance(client_id);
CREATE INDEX idx_mv_daily_campaign ON mv_daily_campaign_performance(campaign_id);

-- Refresh function for materialized view
CREATE OR REPLACE FUNCTION refresh_daily_performance()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY mv_daily_campaign_performance;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- 12. AUDIT LOG (Track changes to critical tables)
-- ============================================================================

CREATE TABLE audit_log (
    audit_id BIGSERIAL PRIMARY KEY,
    table_name VARCHAR(100) NOT NULL,
    record_id VARCHAR(50) NOT NULL,
    action VARCHAR(20) NOT NULL,                -- INSERT, UPDATE, DELETE
    old_values JSONB,
    new_values JSONB,
    changed_by VARCHAR(50) REFERENCES users(user_id),
    changed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Index for audit queries
CREATE INDEX idx_audit_table ON audit_log(table_name);
CREATE INDEX idx_audit_record ON audit_log(record_id);
CREATE INDEX idx_audit_date ON audit_log(changed_at);

-- ============================================================================
-- 13. TRIGGERS
-- ============================================================================

-- Trigger function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply trigger to all tables with updated_at column
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_clients_updated_at BEFORE UPDATE ON clients
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_campaigns_updated_at BEFORE UPDATE ON campaigns
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_adgroups_updated_at BEFORE UPDATE ON adgroups
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_ads_updated_at BEFORE UPDATE ON ads
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_performance_updated_at BEFORE UPDATE ON performance
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_leads_updated_at BEFORE UPDATE ON leads
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- 14. FUNCTIONS & STORED PROCEDURES
-- ============================================================================

-- Function to calculate CPL for a campaign
CREATE OR REPLACE FUNCTION calculate_cpl(
    p_campaign_id VARCHAR(50),
    p_date_from DATE,
    p_date_to DATE
)
RETURNS DECIMAL(10, 2) AS $$
DECLARE
    v_total_spend DECIMAL(12, 2);
    v_total_leads INTEGER;
BEGIN
    -- Get total spend
    SELECT COALESCE(SUM(spend), 0) INTO v_total_spend
    FROM performance
    WHERE campaign_id = p_campaign_id
    AND date BETWEEN p_date_from AND p_date_to;

    -- Get total leads
    SELECT COUNT(*) INTO v_total_leads
    FROM leads
    WHERE campaign_id = p_campaign_id
    AND lead_date BETWEEN p_date_from AND p_date_to;

    -- Calculate CPL
    IF v_total_leads > 0 THEN
        RETURN ROUND(v_total_spend / v_total_leads, 2);
    ELSE
        RETURN 0;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Function to calculate CPQL for a campaign
CREATE OR REPLACE FUNCTION calculate_cpql(
    p_campaign_id VARCHAR(50),
    p_date_from DATE,
    p_date_to DATE
)
RETURNS DECIMAL(10, 2) AS $$
DECLARE
    v_total_spend DECIMAL(12, 2);
    v_qualified_leads INTEGER;
BEGIN
    -- Get total spend
    SELECT COALESCE(SUM(spend), 0) INTO v_total_spend
    FROM performance
    WHERE campaign_id = p_campaign_id
    AND date BETWEEN p_date_from AND p_date_to;

    -- Get qualified leads
    SELECT COUNT(*) INTO v_qualified_leads
    FROM leads
    WHERE campaign_id = p_campaign_id
    AND lead_date BETWEEN p_date_from AND p_date_to
    AND lead_stage IN ('Qualified', 'Converted');

    -- Calculate CPQL
    IF v_qualified_leads > 0 THEN
        RETURN ROUND(v_total_spend / v_qualified_leads, 2);
    ELSE
        RETURN 0;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Function to get master summary data
CREATE OR REPLACE FUNCTION get_master_summary(
    p_date_from DATE,
    p_date_to DATE,
    p_platform platform_type DEFAULT NULL
)
RETURNS TABLE (
    total_spend DECIMAL(12, 2),
    total_leads BIGINT,
    qualified_leads BIGINT,
    qualification_rate DECIMAL(5, 1),
    average_cpl DECIMAL(10, 2),
    average_cpql DECIMAL(10, 2),
    total_revenue DECIMAL(12, 2),
    overall_roi DECIMAL(10, 0)
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        COALESCE(SUM(p.spend), 0)::DECIMAL(12, 2) as total_spend,
        COUNT(DISTINCT l.lead_id) as total_leads,
        COUNT(DISTINCT CASE WHEN l.lead_stage IN ('Qualified', 'Converted') THEN l.lead_id END) as qualified_leads,
        CASE
            WHEN COUNT(DISTINCT l.lead_id) > 0 THEN
                ROUND((COUNT(DISTINCT CASE WHEN l.lead_stage IN ('Qualified', 'Converted') THEN l.lead_id END)::DECIMAL /
                       COUNT(DISTINCT l.lead_id) * 100), 1)
            ELSE 0
        END as qualification_rate,
        CASE
            WHEN COUNT(DISTINCT l.lead_id) > 0 THEN
                ROUND(SUM(p.spend) / COUNT(DISTINCT l.lead_id), 2)
            ELSE 0
        END as average_cpl,
        CASE
            WHEN COUNT(DISTINCT CASE WHEN l.lead_stage IN ('Qualified', 'Converted') THEN l.lead_id END) > 0 THEN
                ROUND(SUM(p.spend) / COUNT(DISTINCT CASE WHEN l.lead_stage IN ('Qualified', 'Converted') THEN l.lead_id END), 2)
            ELSE 0
        END as average_cpql,
        COALESCE(SUM(l.revenue_generated), 0)::DECIMAL(12, 2) as total_revenue,
        CASE
            WHEN SUM(p.spend) > 0 THEN
                ROUND(((SUM(l.revenue_generated) - SUM(p.spend)) / SUM(p.spend) * 100), 0)
            ELSE 0
        END as overall_roi
    FROM performance p
    LEFT JOIN leads l ON p.campaign_id = l.campaign_id AND p.date = l.lead_date
    WHERE p.date BETWEEN p_date_from AND p_date_to
    AND (p_platform IS NULL OR p.platform = p_platform);
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- 15. SAMPLE DATA (For Testing)
-- ============================================================================

-- Insert sample user
INSERT INTO users (user_id, email, password_hash, name, role, permissions) VALUES
('USR001', 'admin@olioglobal.com', '$2b$10$abcdefghijklmnopqrstuvwxyz', 'Agency Manager', 'admin',
 '["view_all_clients", "upload_data", "export_reports", "manage_users"]'::JSONB);

-- Insert sample clients
INSERT INTO clients (client_id, client_name, industry, contact_email, status) VALUES
('CLT001', 'Tech Manufacturing Ltd', 'Manufacturing', 'contact@techmanufacturing.com', 'Active'),
('CLT002', 'EduTech Solutions', 'Education Technology', 'info@edutech.com', 'Active'),
('CLT003', 'HealthWellness Clinic', 'Healthcare', 'contact@healthwellness.com', 'Active');

-- Insert sample campaigns
INSERT INTO campaigns (campaign_id, campaign_name, client_id, platform, status, start_date) VALUES
('CMP001', 'Google_Search_Manufacturing_Nov25', 'CLT001', 'google', 'Active', '2025-10-01'),
('CMP002', 'Google_YouTube_TechManuf_Nov25', 'CLT001', 'google', 'Active', '2025-10-01'),
('CMP003', 'Campaign_FB_EduTech_Nov25', 'CLT002', 'meta', 'Active', '2025-10-01');

-- Insert sample ad groups
INSERT INTO adgroups (adgroup_id, adgroup_name, campaign_id, platform, status) VALUES
('ADG001', 'Precision Machining Keywords', 'CMP001', 'google', 'Active'),
('ADG002', 'CNC Manufacturing Services', 'CMP001', 'google', 'Active');

-- Insert sample ads
INSERT INTO ads (ad_id, ad_name, adgroup_id, campaign_id, platform, ad_type) VALUES
('AD001', 'Ad_Precision_001', 'ADG001', 'CMP001', 'google', 'Search'),
('AD002', 'Ad_CNC_001', 'ADG002', 'CMP001', 'google', 'Search');

-- Insert sample performance data
INSERT INTO performance (date, client_id, campaign_id, adgroup_id, ad_id, platform, spend, impressions, clicks, conversions) VALUES
('2025-11-01', 'CLT001', 'CMP001', 'ADG001', 'AD001', 'google', 5000, 10000, 500, 25),
('2025-11-02', 'CLT001', 'CMP001', 'ADG001', 'AD001', 'google', 4800, 9500, 480, 24),
('2025-11-03', 'CLT001', 'CMP001', 'ADG001', 'AD001', 'google', 5200, 10500, 520, 26);

-- Insert sample leads
INSERT INTO leads (lead_name, email, phone, city, source, campaign_id, adgroup_id, interested_service, lead_stage, lead_date, revenue_generated) VALUES
('John Doe', 'john@example.com', '9876543210', 'Mumbai', 'Google Search', 'CMP001', 'ADG001', 'Precision Machining', 'Qualified', '2025-11-01', 0),
('Jane Smith', 'jane@example.com', '9876543211', 'Pune', 'Google Search', 'CMP001', 'ADG001', 'CNC Services', 'Converted', '2025-11-02', 150000),
('Bob Johnson', 'bob@example.com', '9876543212', 'Delhi', 'Google YouTube', 'CMP002', NULL, 'Manufacturing Consultation', 'Qualified', '2025-11-03', 0);

-- ============================================================================
-- 16. VIEWS (Virtual Views for Common Queries)
-- ============================================================================

-- View: Client Performance Summary
CREATE OR REPLACE VIEW vw_client_performance AS
SELECT
    c.client_id,
    c.client_name,
    c.industry,
    c.status,
    COUNT(DISTINCT cam.campaign_id) as total_campaigns,
    COUNT(DISTINCT CASE WHEN cam.status = 'Active' THEN cam.campaign_id END) as active_campaigns,
    COALESCE(SUM(p.spend), 0) as total_spend_ytd,
    COUNT(DISTINCT l.lead_id) as total_leads_ytd,
    COUNT(DISTINCT CASE WHEN l.lead_stage IN ('Qualified', 'Converted') THEN l.lead_id END) as qualified_leads_ytd,
    COALESCE(SUM(l.revenue_generated), 0) as total_revenue_ytd
FROM clients c
LEFT JOIN campaigns cam ON c.client_id = cam.client_id
LEFT JOIN performance p ON c.client_id = p.client_id
LEFT JOIN leads l ON c.client_id = (SELECT client_id FROM campaigns WHERE campaign_id = l.campaign_id)
GROUP BY c.client_id, c.client_name, c.industry, c.status;

-- View: Campaign Hierarchy
CREATE OR REPLACE VIEW vw_campaign_hierarchy AS
SELECT
    c.client_id,
    cl.client_name,
    c.campaign_id,
    c.campaign_name,
    c.platform,
    ag.adgroup_id,
    ag.adgroup_name,
    a.ad_id,
    a.ad_name,
    a.creative_type
FROM campaigns c
JOIN clients cl ON c.client_id = cl.client_id
LEFT JOIN adgroups ag ON c.campaign_id = ag.campaign_id
LEFT JOIN ads a ON ag.adgroup_id = a.adgroup_id;

-- ============================================================================
-- 17. PERMISSIONS & SECURITY
-- ============================================================================

-- Create read-only role for analysts
CREATE ROLE analyst_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO analyst_role;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO analyst_role;

-- Create manager role (read + limited write)
CREATE ROLE manager_role;
GRANT SELECT, INSERT, UPDATE ON clients, campaigns, leads TO manager_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO manager_role;

-- Create admin role (full access)
CREATE ROLE admin_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_role;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin_role;

-- ============================================================================
-- 18. MAINTENANCE & OPTIMIZATION
-- ============================================================================

-- Function to clean up old audit logs (older than 1 year)
CREATE OR REPLACE FUNCTION cleanup_old_audit_logs()
RETURNS void AS $$
BEGIN
    DELETE FROM audit_log
    WHERE changed_at < CURRENT_DATE - INTERVAL '1 year';
END;
$$ LANGUAGE plpgsql;

-- Function to archive old performance data
CREATE OR REPLACE FUNCTION archive_old_performance_data()
RETURNS void AS $$
BEGIN
    -- Archive performance data older than 2 years to archive table
    INSERT INTO performance_archive
    SELECT * FROM performance
    WHERE date < CURRENT_DATE - INTERVAL '2 years';

    -- Delete archived data from main table
    DELETE FROM performance
    WHERE date < CURRENT_DATE - INTERVAL '2 years';
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- END OF SCHEMA
-- ============================================================================

-- Refresh materialized view after setup
SELECT refresh_daily_performance();

-- Analyze tables for query optimization
ANALYZE users;
ANALYZE clients;
ANALYZE campaigns;
ANALYZE adgroups;
ANALYZE ads;
ANALYZE performance;
ANALYZE leads;
ANALYZE upload_history;

-- Display schema summary
SELECT
    'Schema Created Successfully' as status,
    COUNT(DISTINCT table_name) as total_tables,
    (SELECT COUNT(*) FROM information_schema.views WHERE table_schema = 'public') as total_views,
    (SELECT COUNT(*) FROM pg_matviews WHERE schemaname = 'public') as materialized_views
FROM information_schema.tables
WHERE table_schema = 'public' AND table_type = 'BASE TABLE';
