resource "aws_vpc_peering_connection" "this" {
  peer_owner_id = var.peer_owner_id
  peer_vpc_id   = data.aws_vpc.id
  vpc_id        = var.vpc_id
  auto_accept   = true
  tags          = { Name = "${var.name}"}
}

resource "aws_route" "accepter" {
  count                     = length(data.aws_route_tables.accepter.ids)
  route_table_id            = data.aws_route_tables.accepter.ids[count.idex]
  destination_cidr_block    = data.aws_vpc.peer.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}

resource "aws_route" "peer" {
  count                     = length(data.aws_route_tables.peer.ids)
  route_table_id            = data.aws_route_tables.peer.ids[count.idex]
  destination_cidr_block    = data.aws_vpc.accepter.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}