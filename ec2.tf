# ─── IAM Role for SSM ────────────────────────────────────────────────────────
resource "aws_iam_role" "ssm_role" {
  name = "student-notes-ssm-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{ Action = "sts:AssumeRole", Effect = "Allow", Principal = { Service = "ec2.amazonaws.com" } }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "student-notes-ssm-profile"
  role = aws_iam_role.ssm_role.name
}

# ─── Security Group ─────────────────────────────────────────────────────────
resource "aws_security_group" "app_sg" {
  name        = "student-notes-sg"
  description = "Allow SSH, HTTP (80), Frontend (3000) and Backend API (5000)"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ─── Elastic IP (Static IP) ─────────────────────────────────────────────────
resource "aws_eip" "app_eip" {
  instance = aws_instance.app_server.id
  domain   = "vpc"
}

# ─── EC2 Instance ────────────────────────────────────────────────────────────
resource "aws_instance" "app_server" {
  ami           = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS
  instance_type = "t3.small"

  key_name               = aws_key_pair.app_key.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  user_data_replace_on_change = true

  user_data = <<-EOF
#!/bin/bash
exec &> /var/log/cloud-init-output.log
echo "======= STARTING MASTER DEPLOYMENT (PORT 80 + LOGIN FIX) ======="

export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y git curl gnupg net-tools

# 1. Install Node.js 20
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

# 2. Install MongoDB 7.0 and ensure it is running
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list
apt-get update -y
apt-get install -y mongodb-org
systemctl start mongod
systemctl enable mongod

# WAIT for MongoDB to be ready (Critical for Seeder)
for i in {1..30}; do
    if nc -z localhost 27017; then
        echo "MongoDB is up!"
        break
    fi
    echo "Waiting for MongoDB..."
    sleep 2
done

# 3. Global tools
npm install -g pm2 serve

# 4. App setup
cd /home/ubuntu
git clone https://github.com/Vilvashini-T/student-notebooks-mern-aws.git app
chown -R ubuntu:ubuntu app
cd app

# 5. Backend Configuration
cd backend
echo "MONGO_URI=mongodb://127.0.0.1:27017/student-note-books" > .env
echo "PORT=5000" >> .env
npm install
node seeder.js
pm2 start server.js --name backend --user ubuntu

# 6. Frontend Configuration (IP Injection - Variable must NOT be escaped)
cd ../frontend
IP=$(curl -s http://checkip.amazonaws.com)
echo "VITE_API_BASE_URL=http://$IP:5000" > .env
cat .env
npm install
npm run build
pm2 start serve --name frontend -- -s dist -l 80

# 7. Persistence
pm2 save
pm2 startup systemd -u ubuntu --hp /home/ubuntu
echo "======= MASTER DEPLOYMENT COMPLETE ======="
EOF
}