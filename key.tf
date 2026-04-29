# Auto-generate SSH key pair — no manual key management needed
resource "tls_private_key" "app_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "app_key" {
  key_name   = "student-notes-tf-key"
  public_key = tls_private_key.app_key.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.app_key.private_key_pem
  filename        = "${path.module}/student-notes-key.pem"
  file_permission = "0400"
}
