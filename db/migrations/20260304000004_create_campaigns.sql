-- migrate:up
BEGIN;

CREATE TABLE campaigns (
  id                        UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  creator_id                UUID         NOT NULL REFERENCES accounts(id) ON DELETE RESTRICT,
  title                     TEXT         NOT NULL,
  summary                   VARCHAR(280),
  description               TEXT,
  category                  TEXT         NOT NULL,
  status                    TEXT         NOT NULL DEFAULT 'draft',
  min_funding_target_cents  BIGINT       NOT NULL,
  max_funding_cap_cents     BIGINT       NOT NULL,
  deadline                  TIMESTAMPTZ,
  created_at                TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  updated_at                TIMESTAMPTZ  NOT NULL DEFAULT NOW(),

  CONSTRAINT chk_campaigns_status CHECK (
    status IN (
      'draft', 'submitted', 'under_review', 'approved', 'rejected',
      'live', 'funded', 'suspended', 'failed', 'settlement', 'complete', 'cancelled'
    )
  ),
  CONSTRAINT chk_campaigns_category CHECK (
    category IN (
      'propulsion', 'entry_descent_landing', 'power_energy',
      'habitats_construction', 'life_support_crew_health',
      'food_water_production', 'isru', 'radiation_protection',
      'robotics_automation', 'communications_navigation'
    )
  ),
  CONSTRAINT chk_campaigns_min_funding CHECK (min_funding_target_cents > 0),
  CONSTRAINT chk_campaigns_max_funding CHECK (max_funding_cap_cents >= min_funding_target_cents)
);

CREATE INDEX idx_campaigns_creator_id ON campaigns (creator_id);
CREATE INDEX idx_campaigns_status ON campaigns (status);
CREATE INDEX idx_campaigns_category ON campaigns (category);
CREATE INDEX idx_campaigns_deadline ON campaigns (deadline);

CREATE TRIGGER trg_campaigns_updated_at
  BEFORE UPDATE ON campaigns
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

COMMIT;

-- migrate:down
BEGIN;

DROP TRIGGER IF EXISTS trg_campaigns_updated_at ON campaigns;
DROP TABLE IF EXISTS campaigns;

COMMIT;
