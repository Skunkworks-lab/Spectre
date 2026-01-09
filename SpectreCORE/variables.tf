
variable "do_token" {
  	description = "Token API di DigitalOcean"
  	type        = string
  	default     = "dop_v1_[redacted]"
}
variable "pub_key" {
	description = "public"
  	type        = string
  	default     = "./repo/Key/.ssh/id_rsa.pub"
}


variable "pvt_key" {
	description = "private"
  	type        = string
  	default     = "./repo/Key/.ssh/id_rsa"
}



variable "ssh_fingerprint" {
	description = "Token API di DigitalOcean"
  	type        = string
  	default     = "[redacted]"
}



variable "c4_nation" {
	description = "Token API di DigitalOcean"
  	type        = string
}





