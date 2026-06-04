// outputs.tf
output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id" {
  value = aws_subnet.public.id
}

output "instance_id" {
  value = aws_instance.app.id
}

output "instance_public_ip" {
  value = aws_instance.app.public_ip
}

output "bucket_name" {
  value = var.create_bucket ? aws_s3_bucket.data[0].bucket : null
}

output "bucket_arn" {
  value = var.create_bucket ? aws_s3_bucket.data[0].arn : null
}
