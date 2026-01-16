
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







##################################################################################
##################################################################################
##################################################################################
### DNS Redirector apploocker.biz - 
resource "cloudflare_record" "dns-s1-ns1" {
count = var.execution == true ? 1 : 0
    zone_id  = var.zone_id
    name   = "ns1"
    value  = var.aws_public_ip
    type   = "A"
    ttl    = 300
}

resource "cloudflare_record" "dns-s1-a" {
count = var.execution == true ? 1 : 0
    zone_id  = var.zone_id
    name   = var.ns_record_cf
    value  = "ns1.${var.dns_name_cf}"
    type   = "NS"
    ttl    = 300
}

##################################################################################


##################################################################################
##################################################################################
##################################################################################

