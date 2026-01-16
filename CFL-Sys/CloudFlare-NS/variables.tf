variable "aws_public_ip" {
  description = "IP address of SpectreC4"
}



variable "CDN_PROXY_1" {
	description = "public"
  	type        = string
  	default     = "false"
}


variable "zone_id" {
	description = "public"
	type        = string
 	default     = "37ddccdb2[REDACTED]"
}


variable "execution" {
type = bool
}


# variable "cf_email" {
#	description = "public"
#  	type        = string
# 	default     = "miamail@miamail.it[REDACTED]"
# }
# 

variable "index" {
  	description = "Indice di collegamento"
  	type        = string
  	default     = "1"
}



variable "dns_subname_cf" {
  	description = "Indice di collegamento"
  	type        = string
}




variable "dns_name_cf" {
	description = "public"
	type        = string
 	
}



variable "ns_record_cf" {
	description = "public"
	type        = string
 	
}



