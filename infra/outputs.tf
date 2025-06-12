output "public_ip" {
  description = "The public IP of the Minecraft server"
  value       = aws_instance.minecraft.public_ip
}

output "instance_id" {
  description = "The EC2 instance ID"
  value       = aws_instance.minecraft.id
}
