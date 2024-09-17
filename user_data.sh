#!/bin/bash

# install terraform
echo "installing terraform"

sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update -y
sudo apt-get install terraform -y

echo "terraform installation finished"

# configure aliases
echo "Configuring aliases..."

cat << 'EOF' >> /home/ubuntu/.bashrc
# Custom Aliases
alias cb='git checkout -b'
alias stat='git status'
alias b='git branch'
alias push='git push'
alias add='git add'
EOF

# Source the .bashrc file so the aliases are available in the current session
source /home/ubuntu/.bashrc

echo "Aliases configured successfully."