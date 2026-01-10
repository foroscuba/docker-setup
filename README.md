# Docker Setup

This repository provides transparency into how our servers run. Users can review the exact configuration we use in production.

## Quick Start

```bash
git clone https://github.com/foroscuba/docker-setup.git
cd docker-setup
cp .env.example .env
# Edit .env with your credentials
docker-compose up -d
```

## Structure

- `Dockerfile` - PHP 8.4 with FPM-NGINX and extensions
- `docker-compose.yml` - Service definitions
- `nginx/xenforo.conf` - NGINX configuration for XenForo
- `.env.example` - Environment template

## Services

| Service | Port |
|---------|------|
| PHP/NGINX | 18580 |
| MariaDB | 13306 |
