

resource "aws_instance" "servers" {
    count                     = var.num_of_servers
    subnet_id                 = var.public_sub_id[count.index%2]
    ami                       = data.aws_ami.ubuntu.id
    instance_type             = var.servers_intance_type
    key_name                  = var.intances_private_key_name
    vpc_security_group_ids    = [var.sg]
    iam_instance_profile      = var.iam
    user_data                 = file("./files/consul-server.sh")
    tags = {
        Name    = "${var.project_name}-server_${count.index}"
        purpose = "${var.project_name} learning"
        consul_server = "true"
        owner   = var.owner_name
  }
}
