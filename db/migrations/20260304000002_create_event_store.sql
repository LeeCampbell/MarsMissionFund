-- migrate:up

CREATE TABLE events (
  event_id         UUID         NOT NULL DEFAULT gen_random_uuid(),
  event_type       TEXT         NOT NULL,
  aggregate_id     UUID         NOT NULL,
  aggregate_type   TEXT         NOT NULL,
  sequence_number  BIGINT       NOT NULL,
  timestamp        TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  correlation_id   UUID         NOT NULL,
  source_service   TEXT         NOT NULL,
  payload          JSONB        NOT NULL DEFAULT '{}',

  PRIMARY KEY (aggregate_id, sequence_number)
);

ALTER TABLE events ADD CONSTRAINT uq_events_event_id UNIQUE (event_id);

CREATE INDEX idx_events_event_type ON events (event_type);
CREATE INDEX idx_events_timestamp ON events (timestamp);
CREATE INDEX idx_events_correlation_id ON events (correlation_id);

-- Defence in depth: prevent UPDATE and DELETE on append-only table
CREATE OR REPLACE FUNCTION prevent_events_modification()
RETURNS TRIGGER AS $$
BEGIN
  RAISE EXCEPTION 'events table is append-only: % operations are not permitted', TG_OP;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_events_no_update
  BEFORE UPDATE ON events
  FOR EACH ROW
  EXECUTE FUNCTION prevent_events_modification();

CREATE TRIGGER trg_events_no_delete
  BEFORE DELETE ON events
  FOR EACH ROW
  EXECUTE FUNCTION prevent_events_modification();

-- migrate:down

DROP TRIGGER IF EXISTS trg_events_no_delete ON events;
DROP TRIGGER IF EXISTS trg_events_no_update ON events;
DROP FUNCTION IF EXISTS prevent_events_modification();
DROP TABLE IF EXISTS events;
