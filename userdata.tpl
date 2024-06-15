#!/bin/bash

# Update the package list
sudo apt update -y

# Install Nginx
sudo apt install -y nginx

welcome_text="Hello, World! This is ${name}"

# Create a custom index.html with a placeholder variable
sudo sh -c "echo '$welcome_text' > /var/www/html/index.html"

# Start and enable the Nginx service
sudo systemctl start nginx
sudo systemctl enable nginx

# sudo apt install unzip -y
# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# unzip awscliv2.zip
# sudo ./aws/install
# sudo rm -rf aws awscliv2.zip

port=${port}

nginx_script="
server {
    listen $port;
    server_name _;
    location / {
        return 200 \"this is $port - $welcome_text\";
        add_header Content-Type text/plain;
    }

    location /health/ {
        return 200 \"OK\";
    }
}"

sudo bash -c "echo '$nginx_script' > /etc/nginx/sites-available/abc.conf"

sudo ln -s /etc/nginx/sites-available/abc.conf /etc/nginx/sites-enabled/abc.conf
sudo systemctl restart nginx
