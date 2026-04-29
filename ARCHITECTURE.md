# 🏗️ Infrastructure Architecture

## Overview

This project uses Terraform to deploy a full-stack MERN application on AWS with zero manual configuration.

## Architecture Diagram

```
                        ┌─────────────────────────────────────────┐
                        │              AWS Cloud (us-east-1)       │
                        │                                          │
  User's Browser  ───► │  ┌──────────┐      ┌─────────────────┐  │
  http://<EIP>         │  │ Elastic  │─────►│   EC2 Instance  │  │
                        │  │   IP     │      │   (t3.small)    │  │
                        │  └──────────┘      │  Ubuntu 22.04   │  │
                        │                    │                  │  │
                        │  ┌──────────────┐  │  ┌───────────┐  │  │
                        │  │   Security   │  │  │  React    │  │  │
                        │  │   Group      │  │  │ Frontend  │  │  │
                        │  │              │  │  │  Port 80  │  │  │
                        │  │  Port 22  ✅ │  │  └───────────┘  │  │
                        │  │  Port 80  ✅ │  │  ┌───────────┐  │  │
                        │  │  Port 3000✅ │  │  │  Node.js  │  │  │
                        │  │  Port 5000✅ │  │  │  Backend  │  │  │
                        │  └──────────────┘  │  │  Port 5000│  │  │
                        │                    │  └───────────┘  │  │
                        │  ┌──────────────┐  │  ┌───────────┐  │  │
                        │  │  IAM Role    │  │  │  MongoDB  │  │  │
                        │  │  (SSM Access)│  │  │  Port     │  │  │
                        │  └──────────────┘  │  │  27017    │  │  │
                        │                    │  └───────────┘  │  │
                        │                    └─────────────────┘  │
                        └─────────────────────────────────────────┘
```

## AWS Resources Created

| Resource | Name | Purpose |
|---|---|---|
| `aws_instance` | `app_server` | Ubuntu EC2 VM running the MERN app |
| `aws_eip` | `app_eip` | Static public IP address for the server |
| `aws_security_group` | `app_sg` | Firewall rules controlling traffic |
| `aws_iam_role` | `ssm_role` | Grants EC2 access to AWS Systems Manager |
| `aws_key_pair` | `app_key` | Auto-generated SSH key for server access |
| `tls_private_key` | `app_key` | RSA 4096-bit key generation |
| `local_file` | `private_key` | Saves the .pem key locally |

## Bootstrap Automation Flow (`user_data` script)

When the EC2 instance first boots, it automatically runs the following steps:

```
Step 1: Update Linux packages
Step 2: Install Node.js 20
Step 3: Install MongoDB 7.0
Step 4: Wait for MongoDB to be ready
Step 5: Install PM2 and serve globally
Step 6: Clone MERN app from GitHub
Step 7: Configure backend .env (MONGO_URI, PORT)
Step 8: Install backend dependencies
Step 9: Seed the database (node seeder.js)
Step 10: Start backend with PM2
Step 11: Detect server's public IP dynamically
Step 12: Configure frontend .env (VITE_API_BASE_URL)
Step 13: Build frontend for production (npm run build)
Step 14: Serve frontend on port 80 with PM2
Step 15: Save PM2 process list for auto-restart on reboot
```

## Security Design

- SSH key pair is **auto-generated** by Terraform — no manual key management needed.
- IAM Role uses **least privilege** — only SSM permissions are granted.
- Security Group exposes **only required ports** — all other traffic is blocked by default.
- The `.pem` key file and `.tfstate` files are excluded from Git via `.gitignore`.
