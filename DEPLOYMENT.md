# Deployment

The application runs on a Linux virtual machine in **Microsoft Azure (Azure for Students)**.

| Item | Value |
|------|-------|
| Cloud provider | Microsoft Azure – Azure for Students subscription |
| Virtual machine | Standard B1s (1 vCPU, 1 GB RAM) |
| Operating system | Ubuntu Server 24.04 LTS |
| Public IP address | SERVER-IP-ADDRESS |
| Open inbound ports | 22 (SSH), 80 (HTTP) |
| URL | http://SERVER-IP-ADDRESS |

## 1. Create the virtual machine
Azure Portal → *Virtual machines* → *Create* → Ubuntu Server 24.04 LTS, size B1s,
authentication with an SSH key, inbound ports **SSH (22)** and **HTTP (80)** allowed.

## 2. Connect with SSH and install the software
```bash
ssh -i stock-vm_key.pem azureuser@SERVER-IP-ADDRESS

sudo apt update && sudo apt upgrade -y
sudo apt install -y git
curl -fsSL https://get.docker.com | sudo sh        # Docker Engine + Compose plugin
sudo usermod -aG docker $USER && newgrp docker

# 1 GB RAM: add 2 GB swap so the image build does not run out of memory
sudo fallocate -l 2G /swapfile && sudo chmod 600 /swapfile
sudo mkswap /swapfile && sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

## 3. Clone and start the project
```bash
git clone https://github.com/GITHUB-USERNAME/stock-management-system-group-X.git
cd stock-management-system-group-X

# production secrets (not committed to GitHub)
cat > .env <<EOF
DB_PASSWORD=$(openssl rand -hex 16)
SECRET_KEY=$(openssl rand -hex 32)
EOF

docker compose up -d --build
docker compose ps          # both services must be "running" / db "healthy"
```
The containers have `restart: unless-stopped`, so the app starts again automatically after a reboot.

## 4. Open the app to the internet
- **Azure network security group:** inbound rule for TCP port 80 from *Any* (created by selecting HTTP when the VM was made;
  otherwise VM → *Networking* → *Add inbound port rule*).
- **Inside the VM:** the web container publishes port 80 (`"80:5000"` in `docker-compose.yml`).
  The PostgreSQL port 5432 is **not** published, so the database is reachable only from the web container.
- Check: open `http://SERVER-IP-ADDRESS` in a browser → the login page appears.

## 5. Updating the deployed app
```bash
cd stock-management-system-group-X
git pull
docker compose up -d --build
```

## 6. Domain (bonus)
Domain: `DOMAIN-NAME` → DNS **A record** `@` pointing to `SERVER-IP-ADDRESS` (and `www` → same IP).
After DNS propagates, the app opens at http://DOMAIN-NAME.
