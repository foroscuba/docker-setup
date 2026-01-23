FROM serversideup/php:8.4-cli

USER root

# Install required PHP extensions and mariadb-client
RUN install-php-extensions gd mysqli intl imagick exif zip gmp redis

# Install cron and mariadb-client
RUN apt-get update && apt-get install -y --no-install-recommends \
    cron \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Copy crontab, backup script, and entrypoint
COPY crontab /etc/cron.d/xenforo-cron
COPY backup.sh /usr/local/bin/backup.sh
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Set proper permissions
RUN chmod 0644 /etc/cron.d/xenforo-cron \
    && chmod +x /usr/local/bin/backup.sh \
    && chmod +x /usr/local/bin/entrypoint.sh \
    && crontab /etc/cron.d/xenforo-cron

# Create log file
RUN touch /var/log/cron.log

# Run entrypoint (exports env vars then starts cron)
CMD ["/usr/local/bin/entrypoint.sh"]
