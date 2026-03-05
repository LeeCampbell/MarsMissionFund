-- migrate:up

CREATE TABLE accounts (
  id                    UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  clerk_user_id         TEXT         UNIQUE NOT NULL,
  email                 TEXT         UNIQUE NOT NULL,
  display_name          TEXT,
  status                TEXT         NOT NULL DEFAULT 'pending_verification',
  roles                 TEXT[]       NOT NULL DEFAULT '{backer}',
  onboarding_completed  BOOLEAN      NOT NULL DEFAULT FALSE,
  created_at            TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  updated_at            TIMESTAMPTZ  NOT NULL DEFAULT NOW(),

  CONSTRAINT chk_accounts_status CHECK (
    status IN ('pending_verification', 'active', 'suspended', 'deactivated', 'deleted')
  )
);

CREATE INDEX idx_accounts_status ON accounts (status);

CREATE TRIGGER trg_accounts_updated_at
  BEFORE UPDATE ON accounts
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- migrate:down

DROP TRIGGER IF EXISTS trg_accounts_updated_at ON accounts;
DROP TABLE IF EXISTS accounts;
