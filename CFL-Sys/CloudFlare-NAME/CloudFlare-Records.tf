
##################################################
##################################################
#########
######### Cloudflare Crypto Settings
######### SSL = FULL
######### Always Use HTTPS = ON
######### Authenticated Origin Pulls = ON
######### Minimum TLS Version = TLS 1.0 (DEFAULT)
######### Opportunistic Encryption = ON
######### Onion Routing = ON
######### TLS 1.3 = Disabled
######### Automatic HTTPS Rewrites = ON
######### 
######### Cloudflare Firewall Settings
######### Browser Integrity Check = OFF
#########
#################################################
#################################################






######## record attraverso cloudflare ###########

resource "cloudflare_record" "a-name" {
count = var.execution == true ? 1 : 0
    name = "${var.dns_subname_cf}"
    zone_id  = var.zone_id
    value  = var.aws_public_ip
    type   = "A"
    ttl    = 1
    proxied = var.CDN_PROXY_1
}

/*
resource "cloudflare_record" "c-name" {
count = var.execution == true ? 1 : 0
  name = "pizza"
    zone_id  = var.zone_id
    value  = var.aws_public_ip
    type   = "A"
    ttl    = 1
    proxied = var.CDN_PROXY_1
}
*/



/*
resource "cloudflare_record" "c-name" {
    name = "sky1"
    zone_id  = var.zone_id
    value  = "${var.dns_subname_cf}${var.index}.sky-warp.net"
    type   = "CNAME"
    ttl    = 1
    proxied = var.CDN_PROXY_1
}
*/

