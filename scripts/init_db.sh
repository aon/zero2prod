#!/usr/bin/env bash
set -x
set -eo pipefail

if ! [ -x "$(command -v psql)" ]; then
    echo >&2 "Error: psql is not installed."
    exit 1
fi

if ! [ -x "$(command -v sqlx)" ]; then
    echo >&2 "Error: sqlx is not installed."
    echo >&2 "Use:"
    echo >&2 "    cargo install --version='~0.6' sqlx-cli\
--no-default-features --features rustls,postgres"
    echo >&2 "to install it."
    exit 1
fi

# Check if custom values set, otherwise use defaults
DB_USER=${POSTGRES_USER:=postgres}
DB_PASS=${POSTGRES_PASSWORD:=password}
DB_NAME=${POSTGRES_DB:=newsletter}
DB_PORT=${POSTGRES_PORT:=5432}

# Launch postgres using Docker
docker run \
    -e POSTGRES_USER=${DB_USER} \
    -e POSTGRES_PASSWORD=${DB_PASS} \
    -e POSTGRES_DB=${DB_NAME} \
    -p ${DB_PORT}:5432 \
    -d postgres \
    postgres -N 1000

# Wait for postgres to be ready
export PGPASSWORD="${DB_PASS}"
until psql -h "localhost" -U "${DB_USER}" -p "${DB_PORT}" -d "postgres" -c '\q'; do
  >&2 echo "Postgres is still unavailable - sleeping"
  sleep 1
done

<&2 echo "Postgres is up and running on port ${DB_PORT}!"

# Export credentials
DATABASE_URL=postgres://${DB_USER}:${DB_PASS}@localhost:${DB_PORT}/${DB_NAME}
export DATABASE_URL

# Create database
sqlx database create
