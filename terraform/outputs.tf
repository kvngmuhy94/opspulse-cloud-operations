output "public_ip" {
  value = aws_instance.opspulse.public_ip
}

output "health_url" {
  value = "http://${aws_instance.opspulse.public_ip}:8000/health"
}
