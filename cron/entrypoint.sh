#!/bin/bash
# Export environment variables for cron jobs
printenv | grep -E "^(MARIADB_|TZ=)" > /etc/environment
# Start cron in foreground
exec cron -f
