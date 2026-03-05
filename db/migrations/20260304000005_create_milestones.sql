-- migrate:up

CREATE TABLE milestones (
  id                     UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  campaign_id            UUID         NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
  title                  TEXT,
  description            TEXT,
  target_date            TIMESTAMPTZ,
  funding_percentage     INTEGER,
  verification_criteria  TEXT,
  status                 TEXT         NOT NULL DEFAULT 'pending',
  created_at             TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  updated_at             TIMESTAMPTZ  NOT NULL DEFAULT NOW(),

  CONSTRAINT chk_milestones_status CHECK (
    status IN ('pending', 'verified', 'returned')
  ),
  CONSTRAINT chk_milestones_funding_percentage CHECK (
    funding_percentage IS NULL OR (funding_percentage >= 0 AND funding_percentage <= 100)
  )
);

CREATE INDEX idx_milestones_campaign_id ON milestones (campaign_id);

CREATE TRIGGER trg_milestones_updated_at
  BEFORE UPDATE ON milestones
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- migrate:down

DROP TRIGGER IF EXISTS trg_milestones_updated_at ON milestones;
DROP TABLE IF EXISTS milestones;
