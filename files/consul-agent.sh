#!/usr/bin/env bash
set -e

### set consul version
sudo echo 'CONSUL_VERSION="1.8.5"' >> /etc/environment
export CONSUL_VERSION="1.8.5"

echo "Grabbing IPs..."
sudo echo "PRIVATE_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)" >> /etc/environment
export PRIVATE_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

echo "Installing dependencies..."
sudo apt-get -qq update &>/dev/null
sudo apt-get -yqq install unzip dnsmasq &>/dev/null

echo "Configuring dnsmasq..."
sudo cat << EODMCF >/etc/dnsmasq.d/10-consul
# Enable forward lookup of the 'consul' domain:
server=/consul/127.0.0.1#8600
EODMCF

sudo systemctl restart dnsmasq

sudo cat << EOF >/etc/systemd/resolved.conf
[Resolve]
DNS=127.0.0.1
Domains=~consul
EOF

sudo systemctl restart systemd-resolved.service

echo "Fetching Consul..."
cd /tmp
sudo curl -Lo consul.zip "https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip"

echo "Installing Consul..."
sudo unzip consul.zip >/dev/null
sudo chmod +x consul
sudo mv consul /usr/local/bin/consul

# Setup Consul
mkdir -p /opt/consul
mkdir -p /etc/consul.d
mkdir -p /run/consul
tee /etc/consul.d/config.json > /dev/null <<EOF
{
  "advertise_addr": "$PRIVATE_IP",
  "data_dir": "/opt/consul",
  "datacenter": "opsschool",
  "encrypt": "uDBV4e+LbFW3019YKPxIrg==",
  "disable_remote_exec": true,
  "disable_update_check": true,
  "leave_on_terminate": true,
  "retry_join": ["provider=aws tag_key=consul_server tag_value=true"],
  "enable_script_checks": true,
  "server": false
}
EOF

# Create user & grant ownership of folders
sudo useradd consul
sudo chown -R consul:consul /opt/consul /etc/consul.d /run/consul


# Configure consul service
sudo tee /etc/systemd/system/consul.service > /dev/null <<"EOF"
[Unit]
Description=Consul service discovery agent
Requires=network-online.target
After=network.target

[Service]
User=consul
Group=consul
PIDFile=/run/consul/consul.pid
Restart=on-failure
Environment=GOMAXPROCS=2
ExecStart=/usr/local/bin/consul agent -pid-file=/run/consul/consul.pid -config-dir=/etc/consul.d
ExecReload=/bin/kill -s HUP $MAINPID
KillSignal=SIGINT
TimeoutStopSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo tee /etc/consul.d/web.json > /dev/null <<EOF
{
  "service": {
    "name": "webserver",
    "tags": [
      "nginx"
    ],
    "port": 80,
    "check": {
      "args": [
        "curl",
        "localhost"
      ],
      "interval": "5s",
      "success_before_passing": 2,
      "failures_before_critical": 2
    }
  }
}
EOF

sleep 15

sudo apt update --yes
sudo apt install nginx --yes
sudo service nginx restart
sudo systemctl daemon-reload
sudo systemctl enable consul.service
sudo systemctl start consul.service

exit 0
