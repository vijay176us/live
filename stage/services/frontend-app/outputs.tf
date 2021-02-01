# Setting up output variable
output "s3_bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "The ARN of the S3 bucket"
}

# output "instance-1_public_ip" {
#   value       = aws_instance.example[*].public_ip
#   # value       = aws_instance.example.public_ip
#   description = "The public IP of the web server"
# }

# output "instance-2_public_ip" {
#   value       = aws_instance.example[1].public_ip
#   # value       = aws_instance.example.public_ip
#   description = "The public IP of the web server"
# }

# output "instance-3_public_ip" {
#   value       = aws_instance.example[2].public_ip
#   # value       = aws_instance.example.public_ip
#   description = "The public IP of the web server"
# }

# $ terraform output
# public_ip = 54.174.13.5