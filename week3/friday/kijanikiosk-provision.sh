#!/bin/bash
set -e

echo "Phase 1: Packages"
sudo apt update
sudo apt install -y nginx ufw curl

echo "Phase 2: Users"
sudo groupadd -f kijanikiosk
id kk-api || sudo useradd -r -g kijanikiosk kk-api
id kk-payments || sudo useradd -r -g kijanikiosk kk-payments
id kk-logs || sudo useradd -r -g kijanikiosk kk-logs

echo "Phase 3: Directories"
sudo mkdir -p /opt/kijanikiosk/{config,shared/logs,health}
sudo chown -R root:kijanikiosk /opt/kijanikiosk
sudo chmod -R 750 /opt/kijanikiosk

echo "Phase 4: Systemd"
sudo tee /etc/systemd/system/kk-api.service > /dev/null <<EOF
[Unit]
Description=KK API
After=network.target

[Service]
User=kk-api
ExecStart=/usr/bin/python3 -m http.server 3000
Restart=always

[Install]
WantedBy=multi-user.target
EOF

echo "Phase 5: Firewall"
sudo ufw --force reset
sudo ufw allow 22
sudo ufw allow 80
sudo ufw deny 3001
sudo ufw --force enable

echo "Phase 6: Logrotate"
sudo tee /etc/logrotate.d/kijanikiosk > /dev/null <<EOF
/opt/kijanikiosk/shared/logs/*.log {
    daily
    rotate 7
    create 640 kk-api kijanikiosk
}
EOF

echo "Phase 7: Journal"
sudo mkdir -p /var/log/journal
sudo sed -i 's/#Storage=.*/Storage=persistent/' /etc/systemd/journald.conf
sudo systemctl restart systemd-journald

echo "Phase 8: Health"
api_status=$(echo >/dev/tcp/localhost/3000 2>/dev/null && echo "ok" || echo "down")

echo "{\"status\":\"$api_status\"}" | sudo tee /opt/kijanikiosk/health/last-provision.json

echo "DONE"
