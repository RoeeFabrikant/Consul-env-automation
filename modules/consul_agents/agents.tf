
resource "aws_instance" "ec2_agents" {
    count                  = var.num_of_agents
    subnet_id              = var.public_sub_id[count.index%2]
    ami                    = data.aws_ami.ubuntu.id
    instance_type          = var.ec2_agents_intance_type
    key_name               = var.intances_private_key_name
    vpc_security_group_ids = [var.sg]
    iam_instance_profile   = var.iam
    user_data              = file("./files/consul-agent.sh")
    tags = {
        Name    = "${var.project_name}_agent_${count.index}"
        purpose = "${var.project_name} learning"
        owner   = var.owner_name
  }
}