# 🚀 Deployment Guide

## Prerequisites

Before running this project, ensure you have the following installed:

| Tool | Version | Download |
|---|---|---|
| Terraform | >= 1.5 | https://developer.hashicorp.com/terraform/downloads |
| AWS CLI | >= 2.0 | https://aws.amazon.com/cli/ |
| Git | Any | https://git-scm.com/ |

## Step 1 — Configure AWS Credentials

```bash
aws configure
```
You will be asked to enter:
- **AWS Access Key ID** — from your AWS IAM user
- **AWS Secret Access Key** — from your AWS IAM user
- **Default region** — enter `us-east-1`
- **Output format** — enter `json`

## Step 2 — Clone this Repository

```bash
git clone https://github.com/Vilvashini-T/devops_terraform.git
cd devops_terraform
```

## Step 3 — Initialize Terraform

Downloads the required AWS provider plugins.

```bash
terraform init
```

## Step 4 — Preview the Plan

See exactly what resources Terraform will create before applying.

```bash
terraform plan
```

## Step 5 — Deploy the Infrastructure

```bash
terraform apply -auto-approve
```

This will:
- Create an EC2 instance on AWS
- Generate and save SSH keys automatically
- Configure security groups and firewall rules
- Attach a static Elastic IP address
- Run the full bootstrap script to install and start the app

⏳ **Wait 3-5 minutes** for the server's user_data script to complete.

## Step 6 — Access the Application

After `terraform apply` completes, you will see output like:

```
Outputs:
backend_url  = "http://<YOUR_IP>:5000"
frontend_url = "http://<YOUR_IP>"
public_ip    = "<YOUR_IP>"
ssh_command  = "ssh -i student-notes-key.pem ubuntu@<YOUR_IP>"
```

Open the `frontend_url` in your browser. 🎉

## Step 7 — SSH into the Server (Optional)

```bash
ssh -i student-notes-key.pem ubuntu@<YOUR_IP>
```

Once inside, you can check app status:
```bash
pm2 status
pm2 logs backend
pm2 logs frontend
```

## Step 8 — Destroy the Infrastructure

When you are done, destroy all AWS resources to avoid charges:

```bash
terraform destroy -auto-approve
```

---

## Troubleshooting

**Website not loading after 5 minutes?**
SSH into the server and check the bootstrap log:
```bash
cat /var/log/cloud-init-output.log
```

**PM2 apps not running after server restart?**
```bash
pm2 resurrect
# If that fails, manually restart:
cd /home/ubuntu/app/backend && pm2 start server.js --name backend
cd /home/ubuntu/app/frontend && pm2 start serve --name frontend -- -s dist -l 80
pm2 save
```
