# 🚀 Deployment Guide

## ⚠️ Important Note — Do You Need to Clone the MERN App?

**No!** You only need to clone this `devops_terraform` repository.

Terraform automatically downloads the MERN application code from GitHub directly onto the AWS server during deployment. You never need to touch the app repo manually.

---

## Prerequisites

Before starting, make sure you have these tools installed on your laptop:

| Tool | Minimum Version | Download Link |
|---|---|---|
| Terraform | 1.5 or higher | https://developer.hashicorp.com/terraform/downloads |
| AWS CLI | 2.0 or higher | https://aws.amazon.com/cli/ |
| Git | Any version | https://git-scm.com/ |

---

## Step 1 — Set Up AWS Credentials

You need an AWS account with Access Keys. Run this command and enter your keys:

```bash
aws configure
```

It will ask you for 4 things:
```
AWS Access Key ID     → (your key ID from AWS IAM)
AWS Secret Access Key → (your secret key from AWS IAM)
Default region name   → us-east-1
Default output format → json
```

> 💡 To verify your credentials are working, run: `aws sts get-caller-identity`

---

## Step 2 — Clone This Repository

```bash
git clone https://github.com/Vilvashini-T/devops_terraform.git
cd devops_terraform
```

> 🔁 **You only need this one repository.** The MERN app is automatically pulled from GitHub by the Terraform script during deployment.

---

## Step 3 — Initialize Terraform

This downloads the required AWS provider plugins. Run it once after cloning.

```bash
terraform init
```

You should see: `Terraform has been successfully initialized!`

---

## Step 4 — Preview What Will Be Created

This is optional but useful. It shows you exactly what AWS resources Terraform will create — without actually creating anything.

```bash
terraform plan
```

---

## Step 5 — Deploy the Infrastructure

This is the main command. It creates everything on AWS.

```bash
terraform apply -auto-approve
```

**What happens automatically:**
1. EC2 server is created on AWS
2. SSH key pair is generated and saved as `student-notes-key.pem`
3. Firewall rules (Security Group) are configured
4. A static Elastic IP is assigned
5. The server boots and runs the setup script which:
   - Installs Node.js 20 and MongoDB 7.0
   - Clones the MERN app from GitHub
   - Configures environment variables
   - Seeds the database
   - Starts the app with PM2

⏳ **Wait 3 to 5 minutes** after the command finishes for the server's setup script to complete in the background.

---

## Step 6 — Get the Website URL

After the command finishes, Terraform prints the output:

```
Outputs:

backend_url  = "http://<YOUR_IP>:5000"
frontend_url = "http://<YOUR_IP>"
public_ip    = "<YOUR_IP>"
ssh_command  = "ssh -i student-notes-key.pem ubuntu@<YOUR_IP>"
```

Open the `frontend_url` in your browser. 🎉

---

## Step 7 — (Optional) SSH into the Server

If you want to check what is running on the server:

```bash
ssh -i student-notes-key.pem ubuntu@<YOUR_IP>
```

Inside the server, useful commands:
```bash
pm2 status              # see if backend and frontend are running
pm2 logs backend        # see backend logs
pm2 logs frontend       # see frontend logs
cat /var/log/cloud-init-output.log  # see the full setup script log
```

---

## Step 8 — Destroy Everything When Done

**Always do this after your presentation** to avoid AWS charges:

```bash
terraform destroy -auto-approve
```

This cleanly deletes every AWS resource that was created.

---

## Troubleshooting

**Website not loading after 5 minutes?**

SSH into the server and check the setup log:
```bash
cat /var/log/cloud-init-output.log
```
Look for any error messages near the bottom of the file.

---

**PM2 apps stopped after server restart?**

SSH into the server and run:
```bash
pm2 resurrect
```

If that does not work:
```bash
cd /home/ubuntu/app/backend
pm2 start server.js --name backend

cd /home/ubuntu/app/frontend
pm2 start serve --name frontend -- -s dist -l 80

pm2 save
```
