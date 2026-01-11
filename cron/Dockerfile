FROM serversideup/php:8.4-cli

USER root

# Install required PHP extensions (same as main container)
RUN install-php-extensions gd mysqli intl imagick exif zip gmp redis

# Install cron
RUN apt-get update && apt-get install -y --no-install-recommends cron \
    && rm -rf /var/lib/apt/lists/*

# Copy crontab file
COPY crontab /etc/cron.d/xenforo-cron

# Set proper permissions for crontab
RUN chmod 0644 /etc/cron.d/xenforo-cron \
    && crontab /etc/cron.d/xenforo-cron

# Create log file
RUN touch /var/log/cron.log

# Run cron in foreground
CMD ["cron", "-f"]
