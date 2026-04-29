# 🏗️ Student Note Books - Infrastructure as Code (Terraform)

This repository contains the Terraform configuration files to fully automate the deployment of the "Student Note Books" MERN-stack application to AWS. 

By using Infrastructure as Code (IaC), this project eliminates manual AWS Console configuration, ensuring a reproducible, secure, and automated deployment pipeline.

## 🌟 Features
- **Automated Provisioning:** Creates an AWS EC2 instance (`t3.small`) running Ubuntu 22.04.
- **Static IP Configuration:** Allocates and associates an Elastic IP so the public URL remains consistent.
- **Security:** Configures AWS Security Groups to expose only necessary ports (22 for SSH, 80 for HTTP, 3000 for React Dev, 5000 for Node API).
- **Zero-Touch Setup:** Uses EC2 `user_data` (cloud-init) to automatically:
  - Install Node.js 20 and MongoDB 7.0.
  - Clone the application source code.
  - Inject dynamic environment variables (finding the server's own IP).
  - Seed the database and start the services using PM2 process manager.

## 🚀 How to Run

1. **Prerequisites:** 
   - [Terraform](https://developer.hashicorp.com/terraform/downloads) installed.
   - AWS CLI configured with active credentials (`aws configure`).

2. **Initialize Terraform:**
   ```bash
   terraform init
   ```

3. **Preview the Infrastructure Plan:**
   ```bash
   terraform plan
   ```

4. **Deploy the Infrastructure:**
   ```bash
   terraform apply -auto-approve
   ```

5. **Access the App:**
   After 3-5 minutes, Terraform will output the `frontend_url` and `backend_url`. Open the frontend URL in your browser!

6. **Cleanup:**
   To destroy the resources and prevent billing charges:
   ```bash
   terraform destroy -auto-approve
   ```

## 📂 File Structure
- `main.tf` - Core provider definitions and AWS region setup.
- `ec2.tf` - Defines the EC2 instance, Security Groups, IAM Roles, Elastic IP, and the crucial `user_data` bootstrap script.
- `variables.tf` - Configurable input variables for the infrastructure.
- `outputs.tf` - Extracts important information (like Public IP and SSH commands) after deployment.
- `key.tf` - Manages the SSH Key Pair for secure server access.
