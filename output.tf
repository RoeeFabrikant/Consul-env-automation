
output "agents_public_address" {
    value = module.consul_agents.agent_public_address
}

output "consul_servers_public_address" {
  value = module.consul_servers.servers_public_address
}