locals {
    peerings = {
        dimitar-staging = { 
            vpc_peer_id   = "vpc-12343465dw"
            peer_owner_id = "12479054323455"
            vpc_id        = "vpc-567654ewsa"
        }
    }
}

module "ec2" {
    source = "../../modules/peering"
    for_each = locals.peerings

    name          = each.key
    vpc_peer_id   = lookup(each.value, "vpc_peer_id", "")
    peer_owner_id = lookup(each.value, "peer_owner_id", "")
    vpc_id        = lookup(each.value, "vpc_id", "")
} 