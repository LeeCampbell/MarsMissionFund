-- migrate:up

CREATE TABLE escrow_ledger (
  id               UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  campaign_id      UUID         NOT NULL REFERENCES campaigns(id) ON DELETE RESTRICT,
  entry_type       TEXT         NOT NULL,
  amount_cents     BIGINT       NOT NULL,
  contribution_id  UUID,
  disbursement_id  UUID,
  description      TEXT,
  created_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),

  CONSTRAINT chk_escrow_ledger_entry_type CHECK (
    entry_type IN ('contribution', 'disbursement', 'refund', 'interest_credit', 'interest_debit')
  )
);

CREATE INDEX idx_escrow_ledger_campaign_id ON escrow_ledger (campaign_id);
CREATE INDEX idx_escrow_ledger_contribution_id ON escrow_ledger (contribution_id);

-- Defence in depth: prevent UPDATE and DELETE on append-only table
CREATE OR REPLACE FUNCTION prevent_escrow_ledger_modification()
RETURNS TRIGGER AS $$
BEGIN
  RAISE EXCEPTION 'escrow_ledger table is append-only: % operations are not permitted', TG_OP;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_escrow_ledger_no_update
  BEFORE UPDATE ON escrow_ledger
  FOR EACH ROW
  EXECUTE FUNCTION prevent_escrow_ledger_modification();

CREATE TRIGGER trg_escrow_ledger_no_delete
  BEFORE DELETE ON escrow_ledger
  FOR EACH ROW
  EXECUTE FUNCTION prevent_escrow_ledger_modification();

-- migrate:down

DROP TRIGGER IF EXISTS trg_escrow_ledger_no_delete ON escrow_ledger;
DROP TRIGGER IF EXISTS trg_escrow_ledger_no_update ON escrow_ledger;
DROP FUNCTION IF EXISTS prevent_escrow_ledger_modification();
DROP TABLE IF EXISTS escrow_ledger;
