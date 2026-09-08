#!/bin/bash

exec > >(tee /var/log/user-data.log) 2>&1

APP_NAME=${APP_NAME}
environment=${environment}

apt update -y
apt install -y nginx

unlink /etc/nginx/sites-enabled/default

mkdir -p /var/www/${APP_NAME}
echo "Hello from ${APP_NAME} - ${environment}" > /var/www/${APP_NAME}/index.html

cat <<EOF > /etc/nginx/sites-available/${APP_NAME}
server {
    listen 80;
    server_name _;

    root /var/www/${APP_NAME};
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

ln -s /etc/nginx/sites-available/${APP_NAME} /etc/nginx/sites-enabled/

nginx -t
service nginx restart