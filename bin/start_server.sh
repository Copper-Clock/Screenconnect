#!/bin/bash
##
ENVIRONMENT=${ENVIRONMENT:-production}

mkdir -p \
    /data/.config \
    /data/.tccconnect \
    /data/.tccconnect/backups \
    /data/tccconnect_assets

cp -n /usr/src/app/ansible/roles/tccconnect/files/tccconnect.conf /data/.tccconnect/tccconnect.conf
cp -n /usr/src/app/ansible/roles/tccconnect/files/default_assets.yml /data/.tccconnect/default_assets.yml

echo "Running migration..."

# The following block ensures that the migration is transactional and that the
# database is not left in an inconsistent state if the migration fails.

if [ -f /data/.tccconnect/tccconnect.db ]; then
    ./manage.py dbbackup --noinput --clean && \
        ./manage.py migrate --fake-initial --noinput || \
        ./manage.py dbrestore --noinput
else
    ./manage.py migrate && \
        ./manage.py dbbackup --noinput --clean
fi

if [[ "$ENVIRONMENT" == "development" ]]; then
    echo "Starting Django development server..."
    npm install && npm run build
    ./manage.py runserver 0.0.0.0:8080
else
    echo "Generating Django static files..."
    ./manage.py collectstatic --clear --noinput
    echo "Starting Gunicorn..."
    python run_gunicorn.py
fi
