/*locals {
  vpc_attachments_without_default_route_table_association = {
  for k, v in var.vpc_attachments : k => v if lookup(v, "transit_gateway_default_route_table_association", true) != true
  }

  vpc_attachments_without_default_route_table_propagation = {
  for k, v in var.vpc_attachments : k => v if lookup(v, "transit_gateway_default_route_table_propagation", true) != true
  }

  // List of maps with key and route values
  vpc_attachments_with_routes = chunklist(flatten([
  for k, v in var.vpc_attachments : setproduct([map("key", k)], v["tgw_routes"]) if length(lookup(v, "tgw_routes", {})) > 0
  ]), 2)
}*/

resource "aws_ec2_transit_gateway" "aws_lz_tgw" {
  count = var.create_tgw ? 1 : 0

  description                     = coalesce(var.description, var.name)
  amazon_side_asn                 = var.amazon_side_asn
  default_route_table_association = var.enable_default_route_table_association ? "enable" : "disable"
  default_route_table_propagation = var.enable_default_route_table_propagation ? "enable" : "disable"
  auto_accept_shared_attachments  = var.enable_auto_accept_shared_attachments ? "enable" : "disable"
  vpn_ecmp_support                = var.enable_vpn_ecmp_support ? "enable" : "disable"
  dns_support                     = var.enable_dns_support ? "enable" : "disable"

  tags = merge(
  {
    "Name" = format("%s", var.name)
  },
  var.tags,
  var.tgw_tags,
  )
}

/*#########################
# Route table and routes
#########################
resource "aws_ec2_transit_gateway_route_table" "this" {
  count = var.create_tgw ? 1 : 0

  transit_gateway_id = aws_ec2_transit_gateway.this[0].id

  tags = merge(
  {
    "Name" = format("%s", var.name)
  },
  var.tags,
  var.tgw_route_table_tags,
  )
}

// VPC attachment routes
resource "aws_ec2_transit_gateway_route" "this" {
  count = length(local.vpc_attachments_with_routes)

  destination_cidr_block = local.vpc_attachments_with_routes[count.index][1]["destination_cidr_block"]
  blackhole              = lookup(local.vpc_attachments_with_routes[count.index][1], "blackhole", null)

  transit_gateway_route_table_id = var.create_tgw ? aws_ec2_transit_gateway_route_table.this[0].id : var.transit_gateway_route_table_id
  transit_gateway_attachment_id  = tobool(lookup(local.vpc_attachments_with_routes[count.index][1], "blackhole", false)) == false ? aws_ec2_transit_gateway_vpc_attachment.this[local.vpc_attachments_with_routes[count.index][0]["key"]].id : null
}*/

##########################
# Resource Access Manager
##########################
resource "aws_ram_resource_share" "aws_lz_ram_share" {
  count = var.create_tgw && var.share_tgw ? 1 : 0

  name                      = coalesce(var.ram_name, var.name)
  allow_external_principals = var.ram_allow_external_principals

  tags = merge(
  {
    "Name" = format("%s", coalesce(var.ram_name, var.name))
  },
  var.tags,
  var.ram_tags,
  )
}

resource "aws_ram_resource_association" "aws_lz_ram_association" {
  count = var.create_tgw && var.share_tgw ? 1 : 0

  resource_arn       = aws_ec2_transit_gateway.aws_lz_tgw[0].arn
  resource_share_arn = aws_ram_resource_share.aws_lz_ram_share[0].id
}

resource "aws_ram_principal_association" "aws_lz_ram_principal" {
  count = var.create_tgw && var.share_tgw ? length(var.ram_principals) : 0

  principal          = var.ram_principals[count.index]
  resource_share_arn = aws_ram_resource_share.aws_lz_ram_share[0].arn
}
