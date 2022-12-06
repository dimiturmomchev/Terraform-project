locals {
    clusters = {
        dimitar-staging = { subnet_ids = ["subnet-12446643", "subnet-536546"]}
        dimitar-dev     = { subnet_ids = ["subnet-89543547", "subnet-536946"]}
    }
}

module "ec2" {
    source = "../../modules/eks"
    for_each = locals.clusters

    name          = each.key
    subnet_ids    = lookup(each.value, "subnet_ids", [])
    instance_type = lookup(each.value, "instance_type", ["t3.medium"])
} 