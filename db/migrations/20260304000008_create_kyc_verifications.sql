-- migrate:up

CREATE TABLE kyc_verifications (
  id                  UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  account_id          UUID         NOT NULL REFERENCES accounts(id) ON DELETE RESTRICT,
  status              TEXT         NOT NULL DEFAULT 'not_verified',
  document_type       TEXT,
  provider_reference  TEXT,
  failure_count       INTEGER      NOT NULL DEFAULT 0,
  verified_at         TIMESTAMPTZ,
  expires_at          TIMESTAMPTZ,
  created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),

  CONSTRAINT chk_kyc_verifications_status CHECK (
    status IN (
      'not_verified', 'pending', 'pending_resubmission', 'in_manual_review',
      'verified', 'expired', 'reverification_required', 'rejected', 'locked'
    )
  ),
  CONSTRAINT chk_kyc_verifications_failure_count CHECK (failure_count >= 0)
);

CREATE INDEX idx_kyc_verifications_account_id ON kyc_verifications (account_id);
CREATE INDEX idx_kyc_verifications_status ON kyc_verifications (status);
CREATE INDEX idx_kyc_verifications_expires_at ON kyc_verifications (expires_at);

CREATE TRIGGER trg_kyc_verifications_updated_at
  BEFORE UPDATE ON kyc_verifications
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- migrate:down

DROP TRIGGER IF EXISTS trg_kyc_verifications_updated_at ON kyc_verifications;
DROP TABLE IF EXISTS kyc_verifications;
