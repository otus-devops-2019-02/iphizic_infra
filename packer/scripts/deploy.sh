#! /bin/bash
cd /home
git clone -b monolith https://github.com/express42/reddit.git
cd reddit
bundle install
cat <<EOF> /etc/systemd/system/puma.service
[Unit]
Description=Puma
After=mongod.service
After=network.target
Requires=mongod.service

[Service]
Type=simple
ExecStart=/usr/local/bin/puma --pid /home/puma.pid
PIDFile=/home/puma.pid
WorkingDirectory=/home/reddit
Restart=always

[Install]
WantedBy=multi-user.target
EOF

chmod 664 /etc/systemd/system/puma.service
systemctl daemon-reload
systemctl enable puma
