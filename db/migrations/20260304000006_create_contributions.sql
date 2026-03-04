-- migrate:up
BEGIN;

CREATE TABLE contributions (
  id                 UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  donor_id           UUID         NOT NULL REFERENCES accounts(id) ON DELETE RESTRICT,
  campaign_id        UUID         NOT NULL REFERENCES campaigns(id) ON DELETE RESTRICT,
  amount_cents       BIGINT       NOT NULL,
  status             TEXT         NOT NULL DEFAULT 'pending_capture',
  gateway_reference  TEXT,
  created_at         TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  updated_at         TIMESTAMPTZ  NOT NULL DEFAULT NOW(),

  CONSTRAINT chk_contributions_amount CHECK (amount_cents > 0),
  CONSTRAINT chk_contributions_status CHECK (
    status IN ('pending_capture', 'captured', 'failed', 'refunded', 'partially_refunded')
  )
);

CREATE INDEX idx_contributions_donor_id ON contributions (donor_id);
CREATE INDEX idx_contributions_campaign_id ON contributions (campaign_id);
CREATE INDEX idx_contributions_status ON contributions (status);

CREATE TRIGGER trg_contributions_updated_at
  BEFORE UPDATE ON contributions
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

COMMIT;

-- migrate:down
BEGIN;

DROP TRIGGER IF EXISTS trg_contributions_updated_at ON contributions;
DROP TABLE IF EXISTS contributions;

COMMIT;
