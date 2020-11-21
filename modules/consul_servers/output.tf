# WEB-SERVER OUTPUT

output "servers_public_address" {
    value = aws_instance.servers.*.public_ip
}
