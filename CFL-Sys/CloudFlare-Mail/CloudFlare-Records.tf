
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
# es: https://Cloudflare-dns.com/dns-query?ct=application/dns-json&name=message.moroder.club&type=TXT




##################################################################################


##################################################################################
##################################################################################
##################################################################################
# POSTA su redir 1
/*
resource "cloudflare_record" "mail" {
    name = "mx"
  #  zone_id  = var.zone_id
    value  = var.aws_public_ip
    type   = "MX"
}
*/




resource "cloudflare_record" "mailname" {
count = var.execution == true ? 1 : 0
    name =  var.mail_record_cf
    zone_id  = var.zone_id
    value  = var.aws_public_ip
    type   = "A"
    ttl    = 1
    proxied = var.CDN_PROXY_1
}


resource "cloudflare_record" "mail" {
count = var.execution == true ? 1 : 0
  zone_id = var.zone_id
  name    = "@"
  type    = "MX"
  ttl     = 3600

  # Priorità del record MX
  priority = 10

  # Elenco dei server di posta (hostname) associati al dominio
  value = "mx.${var.dns_name_cf}"
}


resource "cloudflare_record" "spf" {
count = var.execution == true ? 1 : 0

    
    zone_id  = var.zone_id
    name   = "@"
    value  = "v=spf1 a mx a:mx.${var.dns_name_cf} a:${var.dns_name_cf} ip4:${var.aws_public_ip} ~all"
 
    type   = "TXT"
    ttl    = 1
    
}

