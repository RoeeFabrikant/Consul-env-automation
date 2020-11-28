module "vpc" {
  source = "./modules/vpc"

  project_name              = "consul"
  vpc_cidr                  = "10.10.0.0/16"
  public_subnet_cidr        = ["10.10.20.0/24", "10.10.21.0/24"]
  
}

module "consul_servers" {
    source = "./modules/consul_servers"

    public_sub_id                = module.vpc.public_sub            # Don't change this line
    sg                           = module.vpc.sg                    # Don't change this line
    iam                          = module.vpc.consul_iam_profile    # Don't change this line

    project_name                 = "consul"
    num_of_servers               = 3
    servers_intance_type         = "t2.micro"
    intances_private_key_name    = "<YOUR PRIVATE KEY HERE>"
    owner_name                   = "opsschool"

}

module "consul_agents" {
    source = "./modules/consul_agents"

    public_sub_id               = module.vpc.public_sub             # Don't change this line
    sg                          = module.vpc.sg                     # Don't change this line
    iam                         = module.vpc.consul_iam_profile     # Don't change this line

    project_name                = "consul"
    num_of_agents               = 1
    ec2_agents_intance_type     = "t2.micro"
    intances_private_key_name   = "<YOUR PRIVATE KEY HERE>"
    owner_name                  = "opsschool"

}