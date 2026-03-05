#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Idempotent Database Reset
# =============================================================================
# Drops and recreates the mmf database, then applies all migrations via dbmate.
# Retries with backoff on failure; falls back to --no-tx-wrap on later attempts.
# Safe to run repeatedly.
# =============================================================================

echo "Resetting database..."

# Parse connection details from DATABASE_URL
# Format: postgres://user:password@host:port/dbname?sslmode=disable
DB_URL="${DATABASE_URL:?DATABASE_URL is required}"

# Extract host, port, user, password from the URL
DB_USER=$(echo "${DB_URL}" | sed -n 's|.*://\([^:]*\):.*|\1|p')
DB_HOST=$(echo "${DB_URL}" | sed -n 's|.*@\([^:]*\):.*|\1|p')
DB_PORT=$(echo "${DB_URL}" | sed -n 's|.*:\([0-9]*\)/.*|\1|p')
DB_NAME=$(echo "${DB_URL}" | sed -n 's|.*/\([^?]*\).*|\1|p')
DB_PASS=$(echo "${DB_URL}" | sed -n 's|.*://[^:]*:\([^@]*\)@.*|\1|p')

export PGPASSWORD="${DB_PASS}"

# Drop and recreate the database
echo "Dropping database ${DB_NAME} (if exists)..."
psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d postgres \
    -c "DROP DATABASE IF EXISTS ${DB_NAME};"

echo "Creating database ${DB_NAME}..."
psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d postgres \
    -c "CREATE DATABASE ${DB_NAME};"

# Apply migrations (only if migration files exist)
MIGRATIONS_DIR="${DBMATE_MIGRATIONS_DIR:-db/migrations}"
if [ ! -d "${MIGRATIONS_DIR}" ] || [ -z "$(ls -A "${MIGRATIONS_DIR}" 2>/dev/null)" ]; then
    echo "No migration files found in ${MIGRATIONS_DIR}, skipping dbmate."
    echo "Database reset complete (empty database)."
    exit 0
fi

MAX_ATTEMPTS=3
BACKOFF_SECONDS=(0 5 15)

for attempt in $(seq 1 "${MAX_ATTEMPTS}"); do
    echo "Running dbmate migrations (attempt ${attempt}/${MAX_ATTEMPTS})..."

    if dbmate --url "${DB_URL}" up 2>&1; then
        echo "Database reset complete."
        exit 0
    fi

    if [ "${attempt}" -lt "${MAX_ATTEMPTS}" ]; then
        backoff=${BACKOFF_SECONDS[${attempt}]}
        echo "Migration failed on attempt ${attempt}. Retrying in ${backoff}s..."
        sleep "${backoff}"
    fi
done

echo "{\"event\":\"db_reset_failed\",\"error\":\"migrations failed after ${MAX_ATTEMPTS} attempts\",\"timestamp\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"}"
exit 1
