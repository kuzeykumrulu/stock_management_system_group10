# Deployment

The application runs on a Linux virtual machine (**Droplet**) at **DigitalOcean**.

| Item | Value |
|------|-------|
| Cloud provider | DigitalOcean |
| Virtual machine | Droplet – Basic, Regular CPU, 1 vCPU, 1 GB RAM |
| Operating system | Ubuntu 24.04 LTS (x64) |
| Region | New York (NYC1) |
| Public IP address | 162.243.165.86 |
| Open inbound ports | 22 (SSH), 80 (HTTP) – DigitalOcean Cloud Firewall |
| URL | http://162.243.165.86 |

## 1. Create the Droplet
DigitalOcean control panel → **Create → Droplets** → Ubuntu 24.04 (LTS) x64, Basic / Regular, 1 GB RAM,
authentication with a root password (or SSH key), hostname `stock-vm`.

## 2. Connect with SSH and install the software
```bash
ssh root@162.243.165.86

apt update
apt install -y git
curl -fsSL https://get.docker.com | sh          # Docker Engine + Compose plugin

# 1 GB RAM: add 2 GB swap so the image build does not run out of memory
fallocate -l 2G /swapfile && chmod 600 /swapfile
mkswap /swapfile && swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab
```

## 3. Clone and start the project
```bash
git clone https://github.com/kuzeykumrulu/stock_management_system_group10.git
cd stock_management_system_group10

# production secrets (not committed to GitHub)
cat > .env <<EOT
DB_PASSWORD=$(openssl rand -hex 16)
SECRET_KEY=$(openssl rand -hex 32)
EOT

docker compose up -d --build
docker compose ps          # db must be "healthy", web "Up"
```
The containers have `restart: unless-stopped`, so the app starts again automatically after a reboot.

## 4. Open the app to the internet
- **DigitalOcean Cloud Firewall** (`stock-firewall`, Networking → Firewalls) applied to the Droplet,
  with only two inbound rules: **SSH (TCP 22)** and **HTTP (TCP 80)**. All other inbound traffic is blocked.
- **Docker port mapping:** the web container publishes port 80 (`"80:5000"` in `docker-compose.yml`).
  PostgreSQL's port 5432 is **not** published, so the database is reachable only from the web container.
- Check: open `http://162.243.165.86` in a browser → the login page appears.

## 5. Updating the deployed app
```bash
cd stock_management_system_group10
git pull
docker compose up -d --build
```

## 6. Domain (bonus)
Domain: `DOMAIN-NAME` → DNS **A record** `@` pointing to `162.243.165.86` (and `www` → same IP).
After DNS propagates, the app opens at http://DOMAIN-NAME.
