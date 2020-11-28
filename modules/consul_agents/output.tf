
output "agent_public_address" {
    value = aws_instance.ec2_agents.*.public_ip
}

output "agents_id" {
    value = aws_instance.ec2_agents.*.id
    description = "The ID of the ec2_agents instances"
}
