# 🌐 AWS EC2 Remote Development Environment

This project automates the creation of a **remote development environment** on AWS using an EC2 instance. It leverages **infrastructure-as-code (IaC)** principles to provision the instance, dynamically configure SSH access from your local IP, and seamlessly manage SSH keys in your local setup.

With this setup, you can easily spin up a secure EC2 instance that is accessible from your local machine, enabling a scalable, cloud-based development environment.

---

### ✨ Key Features

- **Dynamic IP-based SSH Access**: Automatically restricts SSH access to your EC2 instance based on your current local IP.
- **SSH Key Management**: Dynamically generates and configures an SSH key in your local environment, ensuring secure and frictionless login.
- **Infrastructure-as-Code (IaC)**: Fully automated infrastructure management using Terraform for consistency and repeatability.
- **Simple Teardown**: Easily clean up and remove the resources when done, saving costs and keeping your environment clean.

---

### 🛠️ Prerequisites

Before running this project, ensure you clone the required **base Terraform module repository** that contains the essential infrastructure components.

1. Clone the base module repository here:

   [Terraform Modules Repository](https://github.com/vijayrmourya/terraform-modules)

2. Ensure the following directory structure:

   ```bash
   |-parent-folder
      |- dev-desktop-setup
      |- terraform-module
   ```

---

### 🚀 Deployment Guide

Once you've cloned the required base module, follow these simple steps to deploy the EC2 instance:

1. **Clone this repository** (`dev-desktop-setup`) into your local environment.

2. **Run the `deploy.sh` script** to provision the EC2 instance and configure SSH access dynamically:

   ```bash
   source deploy.sh
   ```

   - This script will handle the entire process, including Terraform initialization, applying infrastructure, and configuring SSH access with your current IP.

3. **Access your remote development environment** using the SSH key generated in your local environment.

---

### 🧹 Cleaning Up the Environment

When you're done with the EC2 instance, easily tear down the infrastructure to avoid unnecessary charges. Simply run the `cleanup.sh` script:

```bash
source cleanup.sh
```

This script will safely terminate and remove all provisioned AWS resources, ensuring no lingering costs.

---

### 📂 Project Structure

- **`deploy.sh`**: Automates the deployment of the EC2 instance and all related resources.
- **`cleanup.sh`**: Safely destroys all created infrastructure, releasing any AWS resources.

---

### ⚡ Quick Recap

1. Clone the base module repository.
2. Run `deploy.sh` to provision the EC2 instance.
3. SSH into your remote development environment using the generated key.
4. Run `cleanup.sh` to tear down and remove resources when done.

---

### 🤝 Contributing

Contributions are always welcome! Feel free to fork the repository, make improvements, and submit a pull request.

---

### 📝 Important Notes

- Ensure that your local environment has the correct AWS credentials and permissions to manage resources in your AWS account.
- The term "local environment" refers to the system where you execute this infrastructure-as-code solution.
