# 🏗️ Student Note Books — Infrastructure as Code (Terraform)

> **This repository contains the DevOps/Terraform code** that fully automates deploying our MERN-stack web application to AWS Cloud.

---

## 💡 What is this project?

Normally, setting up a cloud server requires hours of manual work — clicking through AWS settings, installing software, configuring databases, and managing SSH keys. One mistake can break everything.

**We solved this using Infrastructure as Code (IaC) with Terraform.**

We wrote code that does all of that automatically. Run one command → get a fully working server with the web app live on the internet in under 5 minutes.

---

## 🗂️ Two Repositories — How They Work Together

This project is split into **two GitHub repositories** for clean separation of concerns:

| Repository | What it contains | Link |
|---|---|---|
| `devops_terraform` ← **(You are here)** | Terraform IaC code that builds the AWS server | [View Repo](https://github.com/Vilvashini-T/devops_terraform) |
| `student-notebooks-mern-aws` | The actual MERN web application code | [View Repo](https://github.com/Vilvashini-T/student-notebooks-mern-aws) |

> ✅ **You only need to clone this repo (`devops_terraform`) to deploy everything.**
> Terraform automatically pulls the MERN app from GitHub during deployment. No need to clone it manually.

---

## 🌟 What Gets Created Automatically

When you run `terraform apply`, it automatically:

- ✅ Creates an **EC2 virtual server** on AWS (Ubuntu 22.04, t3.small)
- ✅ Generates a **secure SSH key pair** (no manual key setup needed)
- ✅ Creates a **Security Group** (cloud firewall) with only required ports open
- ✅ Assigns a **Static Elastic IP** so the website URL never changes
- ✅ Runs a **bootstrap script** on the server that:
  - Installs Node.js 20 and MongoDB 7.0
  - Clones the MERN app code from GitHub
  - Sets up environment variables automatically
  - Seeds the database with initial data
  - Starts the app and keeps it running with PM2

---

## 📂 File Structure

```
devops_terraform/
├── main.tf          → Declares AWS as the cloud provider and sets the region
├── variables.tf     → Stores reusable values (e.g. server size, app name)
├── ec2.tf           → Creates the EC2 server, firewall, IAM role, and runs the setup script
├── key.tf           → Auto-generates the SSH key pair for secure server access
├── outputs.tf       → Prints the website URL and SSH command after deployment
├── ARCHITECTURE.md  → Full infrastructure diagram and resource breakdown
└── DEPLOYMENT.md    → Step-by-step guide to deploy the project
```

---

## 🚀 Quick Start

```bash
# 1. Clone this repo
git clone https://github.com/Vilvashini-T/devops_terraform.git
cd devops_terraform

# 2. Initialize Terraform
terraform init

# 3. Deploy everything to AWS
terraform apply -auto-approve

# 4. Wait 3-5 minutes, then open the URL printed in the terminal!

# 5. When done, destroy all AWS resources
terraform destroy -auto-approve
```

> 📖 See [DEPLOYMENT.md](./DEPLOYMENT.md) for the full step-by-step guide with screenshots and troubleshooting.

---

## 📄 Presentation

The full viva presentation slides for this project are available here:

👉 [DevOps_Viva_Presentation.pdf](./DevOps_Viva_Presentation.pdf)
