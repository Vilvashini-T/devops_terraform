output "public_ip" {
  description = "Public IP (Elastic IP) of the EC2 instance"
  value       = aws_eip.app_eip.public_ip
}

output "frontend_url" {
  description = "Frontend URL — Open in browser after 5 minutes"
  value       = "http://${aws_eip.app_eip.public_ip}"
}

output "backend_url" {
  description = "Backend API URL"
  value       = "http://${aws_eip.app_eip.public_ip}:5000"
}

output "ssh_command" {
  description = "SSH command to connect to the server"
  value       = "ssh -i student-notes-key.pem ubuntu@${aws_eip.app_eip.public_ip}"
}