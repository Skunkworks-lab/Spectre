

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

variable "ip_transport" {
	description = "private"
  	type        = string

}

variable "ip_spectre" {
	description = "private"
  	type        = string

}


variable "ip_aws_net" {
	description = "private"
  	type        = string

}


variable "ip_aws_tor" {
	description = "private"
  	type        = string

}






