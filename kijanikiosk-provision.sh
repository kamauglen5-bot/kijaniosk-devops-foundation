#!/bin/bash
# KijaniKiosk Provisioning Script - Phase Template

set -e

log() { echo "[INFO] $1"; }
success() { echo "[PASS] $1"; }
error() { echo "[FAIL] $1"; exit 1; }

### Phase 1: Users and Groups ###
log "Phase 1: Users and Groups"
# Example: create users if they do not exist
id kk-api &>/dev/null || sudo useradd -m -s /bin/bash kk-api
id kk-payments &>/dev/null || sudo useradd -m -s /bin/bash kk-payments
id kk-logs &>/dev/null || sudo useradd -m -s /bin/bash kk-logs
log "Phase 1 complete"

### Phase 2: Directory Setup ###
log "Phase 2: Directory Setup"
sudo mkdir -p /opt/kijanikiosk/shared/logs
sudo mkdir -p /opt/kijanikiosk/config
sudo chown -R kk-logs:kijanikiosk /opt/kijanikiosk/shared/logs
sudo chmod 770 /opt/kijanikiosk/shared/logs
log "Phase 2 complete"

### Phase 3: Systemd Units ###
log "Phase 3: Systemd Units"
# kk-api.service example inline
cat <<EOF | sudo tee /etc/systemd/system/kk-api.service
[Unit]
Description=KijaniKiosk API Service
After=network.target

[Service]
Type=simple
User=kk-api
Group=kijanikiosk
ExecStart=/usr/bin/python3 /opt/kijanikiosk/api/app.py
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable kk-api.service
sudo systemctl start kk-api.service
log "Phase 3 complete"

### Phase 4: Firewall ###
log "Phase 4: Firewall"
sudo ufw --force reset
sudo ufw allow 22/tcp comment "Allow SSH"
sudo ufw allow 80/tcp comment "Allow HTTP"
sudo ufw deny 3001 comment "Deny external kk-payments"
sudo ufw enable
log "Phase 4 complete"

### Phase 5: Logrotate & Journal Persistence ###
log "Phase 5: Logrotate & Journal Persistence"
sudo mkdir -p /var/log/journal
sudo tee /etc/logrotate.d/kijanikiosk <<EOF
/opt/kijanikiosk/shared/logs/*.log {
    daily
    rotate 7
    missingok
    notifempty
    compress
    create 770 kk-logs kijanikiosk
    postrotate
        systemctl restart kk-logs.service
    endscript
}
EOF
sudo systemctl restart systemd-journald
log "Phase 5 complete"

### Phase 6: Health Checks ###
log "Phase 6: Health Checks"
mkdir -p /opt/kijanikiosk/health
api_status=$(timeout 2 bash -c "echo >/dev/tcp/localhost/3000" 2>/dev/null && echo '"ok"' || echo '"down"')
payments_status=$(timeout 2 bash -c "echo >/dev/tcp/localhost/3001" 2>/dev/null && echo '"ok"' || echo '"down"')
printf '{"timestamp":"%s","kk-api":%s,"kk-payments":%s}\n' "$(date -Is)" "$api_status" "$payments_status" \
  > /opt/kijanikiosk/health/last-provision.json
chown kk-logs:kijanikiosk /opt/kijanikiosk/health/last-provision.json
chmod 640 /opt/kijanikiosk/health/last-provision.json
log "Phase 6 complete"

### Phase 7: Verification ###
log "Phase 7: Verification"
ls -la /opt/kijanikiosk/shared/logs/
sudo -u kk-api touch /opt/kijanikiosk/shared/logs/test-write.tmp && success "Log access OK" || error "Log access FAIL"
sudo systemctl status kk-api.service
sudo systemctl status kk-payments.service
sudo systemctl status kk-logs.service
log "Provisioning complete"
