-- migrate:up
-- Migration: YYYYMMDDHHMMSS_[description]
-- Feature: feat-XXX
-- Description: [What this migration does]
-- Author: infra-engineer-agent

-- ============================================================
-- New tables
-- ============================================================

CREATE TABLE IF NOT EXISTS [table_name] (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,

    -- Domain columns (as defined in feature spec)
    -- Monetary: BIGINT (integer cents)
    -- Percentages: NUMERIC(5,2)
    -- Dates: TIMESTAMPTZ
    -- Text: VARCHAR(n) or TEXT with CHECK

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- Indexes
-- ============================================================

CREATE INDEX idx_[table]_user_id ON [table_name](user_id);
-- FK indexes
-- Query pattern indexes (columns used in WHERE/ORDER BY)

-- ============================================================
-- Constraints
-- ============================================================

-- CHECK constraints for domain invariants
-- UNIQUE constraints where specified

-- ============================================================
-- Triggers
-- ============================================================

-- Auto-update updated_at on row modification
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_[table]_updated_at
    BEFORE UPDATE ON [table_name]
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- migrate:down
DROP TABLE IF EXISTS [table_name];
