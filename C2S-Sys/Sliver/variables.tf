

variable "C2_ip" {
	description = "public"
  	type        = string

}


variable "useragent" {
	description = "reflector useragent"
  	type        = string

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


variable "transport_ip" {
  description = "IP address of SpectreC4"
}


