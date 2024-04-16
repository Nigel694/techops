#!/bin/bash

# Create a new user with home directory and SSH identity
adduser --disabled-password --gecos "" newuser
mkdir /home/newuser/.ssh
chmod 700 /home/newuser/.ssh
touch /home/newuser/.ssh/authorized_keys
chmod 600 /home/newuser/.ssh/authorized_keys

# Install Ghost application and dependencies
apt-get update

# Install MySQL
sudo apt-get install mysql-server

# Enter mysql
sudo mysql
# Update permissions
ALTER USER 'root'@'localhost' IDENTIFIED WITH 'password' BY 'password';
# Reread permissions
FLUSH PRIVILEGES;
# exit mysql
exit

# Download and import the Nodesource GPG key
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

# Create deb repository
NODE_MAJOR=18 
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list

# Run update and install
sudo apt-get update
sudo apt-get install nodejs -y

npm install -g ghost-cli

# Create directory: Change `sitename` to whatever you like
sudo mkdir -p /var/www/techops

# Set directory owner: Replace <user> with the name of your user
sudo chown <user>:<user> /var/www/techops

# Set the correct permissions
sudo chmod 775 /var/www/techops

# Then navigate into it
cd /var/www/techops


mkdir /var/www/techops
chown newuser:newuser /var/www/techops
su - newuser -c "ghost install"

# Setup firewall rules
ufw allow OpenSSH
ufw allow 80  # Assuming HTTP traffic is required for Ghost
ufw --force enable

# Add cron job
echo "0 0 * * * /usr/bin/ghost dump" >> /etc/crontab
echo "0 0 * * * cp -r /var/www/ghost/content/data /backup" >> /etc/crontab
echo "0 0 * * * echo 'Summary' | mail -s 'Nightly Summary' dukpanigel69@gmail.com" >> /etc/crontab