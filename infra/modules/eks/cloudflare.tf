# my DNS provider is cloudflare, so I need to create a NS record in cloudflare to point to the route53 name servers.
data "cloudflare_zone" "parent" {
  filter = {
    name = var.DOMAIN
  }
}

locals {
    name_servers_map = {
    a = aws_route53_zone.eks.name_servers[0]
    b = aws_route53_zone.eks.name_servers[1]
    c = aws_route53_zone.eks.name_servers[2]
  }
}


resource "cloudflare_dns_record" "dns_record" {
  depends_on = [aws_route53_zone.eks, data.cloudflare_zone.parent]
  # it's strange, cloudflare_zone.parent.id, does not work in planning phase !
  zone_id    = var.CLOUDFLARE_ZONE_ID
  for_each   = local.name_servers_map
  content    = each.value
  name       = var.SUB_DOMAIN
  ttl        = 3600
  type       = "NS"
}