
variable "spectreC4_ip" {
  description = "IP address of SpectreC4"
}

variable "do_token" {
  	description = "Token API di DigitalOcean"
  	type        = string
  	default     = "dop_v1_[REDACTED]"
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
  	default     = "ce:64:de:[REDACTED]"
}



variable "Transport_nation" {
	description = "Token API di DigitalOcean"
  	type        = string

}


variable "transport_ip" {
  description = "IP address of SpectreC4"
}



