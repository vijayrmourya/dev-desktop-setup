#!/bin/bash

LOG_FILE="installed_dependencies.txt"

# Remove the old log file if it exists
rm -f $LOG_FILE

######################################################
# Function to log the installed version of each tool
add_log(){
    echo -e "[$(date)]\n$1 installed version:" >> $LOG_FILE
    echo "$2" >> $LOG_FILE
    echo >> $LOG_FILE
}

######################################################
# Function to handle command failures
handle_failure(){
    echo "$1 failed. Exiting."
    exit 1  # Removed manual intervention
}

######################################################
# Update system repositories
echo "Updating system repositories..."
sudo apt update || handle_failure "System update"

######################################################
# Install Git
echo "Installing Git..."
sudo apt install git-all -y || handle_failure "Installing Git"
add_log "Git" "$(git --version)"

######################################################
# Install AWS CLI
echo "Installing AWS CLI..."
sudo snap install aws-cli --classic || handle_failure "Installing AWS CLI"
add_log "AWS-CLI" "$(aws --version)"

######################################################
# Install Docker
echo "Installing Docker..."
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do 
    sudo apt-get remove -y $pkg || handle_failure "Removing $pkg"
done
sudo apt-get update || handle_failure "System update for Docker"
sudo apt-get install -y ca-certificates curl || handle_failure "Installing CA cert and curl"
# Add Docker GPG key and repository
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
# Add the Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update || handle_failure "Updating Docker repository"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || handle_failure "Installing Docker"
add_log "Docker" "$(docker --version)"
# Add the current user to the Docker group to enable Docker commands without sudo
sudo usermod -aG docker $USER || handle_failure "Adding user to Docker group"
# Inform the user to log out and log back in
echo "You need to log out and log back in for Docker group changes to take effect."
echo "Alternatively, use sudo for Docker commands until you log back in."

######################################################
# Install Minikube
echo "Installing Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb || handle_failure "Downloading Minikube"
sudo dpkg -i minikube_latest_amd64.deb || handle_failure "Installing Minikube"

# Start Minikube using Docker driver as a non-root user
echo "Starting Minikube with Docker driver (non-root)..."
minikube start --driver=docker || { minikube delete; handle_failure "Starting Minikube"; }
add_log "Minikube" "$(minikube version)"
rm -f minikube_latest_amd64.deb

######################################################
# Install kubectl and validate
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
# Validate kubectl binary against the checksum
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check 2>&1
if [[ $? -eq 0 ]]; then
    echo "kubectl: OK"
else
    echo "kubectl validation failed!"
    handle_failure "kubectl checksum validation"
fi
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl  || handle_failure "Installing Kubectl"
add_log "Kubectl" "$(kubectl version)"

######################################################
# Install terraform
echo "installing terraform"
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common || handle_failure "System update"
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update -y || handle_failure "System update"
sudo apt-get install terraform -y  || handle_failure "Installing Terraform"
add_log "Terraform" "$(terraform version)"
echo "terraform installation finished"

######################################################
echo "All installations completed successfully. Logs can be found in $LOG_FILE."
# configure aliases
echo "Configuring aliases..."
cat << 'EOF' >> /home/ubuntu/.bashrc
# Custom Aliases
alias cb='git checkout -b'
alias stat='git status'
alias b='git branch'
alias push='git push'
alias add='git add'
alias k='kubectl'
alias kgpo='kubectl get pods'
EOF
# Source the .bashrc file so the aliases are available in the current session
source /home/ubuntu/.bashrc
echo "Configured aliases..."