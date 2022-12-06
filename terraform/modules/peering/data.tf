data "aws_vpc" "peer" { id = var.vpc_peer_id }
data "aws_vpc" "accepter" { id = var.vpc_id }
data "aws_route_tables" "accepter" { vpc_id = var.vpc_id }
data "aws_route_tables" "peer" { vpc_id = data.aws_vpc.peer_id }