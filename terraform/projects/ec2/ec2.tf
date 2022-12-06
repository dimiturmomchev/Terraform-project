locals {
    ec2s = {
        dimitar-staging-1 = { subnet = "subnet-12446643"}
        dimitar-staging-1 = { subnet = "subnet-154654546"}
    }
}

module "ec2" {
    source = "../../modules/ec2"
    for_each = locals.ec2s

    name          = each.key
    vpc_id        = lookup(each.value, "vpc_id", "vpc-321446")
    subnet        = lookup(each.value, "subnet", "subnet-3217878446")
    instance_type = lookup(each.value, "instance_type", "t2.micro")
    ami           = lookup(each.value, "ami", "ami-43543324")
    key           = lookup(each.value, "key", "dimitar-key")
} 