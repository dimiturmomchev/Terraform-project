locals {
    vpcs = {
        dimitar-staging = {
            vpc_cidr_block              = "10.0.0.0/16"
            public_subnet_cidr_block    = "10.0.0.0/24"
            private_subnet_cidr_block   = "10.0.1.0/24"
            private_subnet_cidr_block_2 = "10.0.2.0/24"
            availability_zone           = "eu-central-1a"
            availability_zone_2         = "eu-central-1b"
        }
    }
}

module "vpc" {
    source = "../../modules/eks"
    for_each = locals.vpcs

    name                        = each.key
    vpc_cidr_block              = lookup(each.value, "vpc_cidr_block", "")
    public_subnet_cidr_block    = lookup(each.value, "public_subnet_cidr_block", "")
    private_subnet_cidr_block   = lookup(each.value, "private_subnet_cidr_block", "")
    private_subnet_cidr_block_2 = lookup(each.value, "private_subnet_cidr_block_2", "")
    availability_zone           = lookup(each.value, "availability_zone", "")
    availability_zone_2         = lookup(each.value, "availability_zone_2", "")
} 
