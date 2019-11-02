#!/bin/bash
curl -fsSL get.docker.com | sh
curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

apt -y install php-imagick php-pear php7.2 php7.2-cli php7.2-cgi php7.2-common php7.2-curl php7.2-gd php7.2-json php7.2-mbstring php7.2-mysql php7.2-opcache php7.2-readline php7.2-xml php7.2-xmlrpc php7.2-zip libapache2-mod-php7.2

cd /root
mkdir docker
cd docker
cat << 'EOF' > docker-compose.yml
version: '3'
services:
  php:
    build: .
    volumes:
      - /root/development:/var/www/html
    ports:
      - 80:80
  mysql:
    image: mysql:5
    environment:
      - MYSQL_ROOT_PASSWORD=utcode2019
    ports:
      - 3306:3306
  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    environment:
      - PMA_HOST=mysql
      - PMA_USER=root
      - PMA_PASSWORD=utcode2019
    ports:
      - 55556:80
EOF
cat << 'EOF' > Dockerfile
FROM php:apache
RUN docker-php-ext-install mysqli pdo_mysql
EOF
docker-compose up -d
