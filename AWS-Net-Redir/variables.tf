variable "name_connection" {
  description = "Nome della tecnologia di connessione Tor/Net"
}

variable "transport_ip" {
  description = "IP address of SpectreC4"
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


variable "aws_akey" {
  	description = "Token API di DigitalOcean"
  	type        = string
  	default     = "AKIAI5ZOANY[REDACTED]"
}

variable "aws_skey" {
  	description = "Token API di DigitalOcean"
  	type        = string
  	default     = "bFfRPRbNM[REDACTED]jDuGLccE/"
}


variable "local_key" {
  	description = "Token API di DigitalOcean"
  	type        = string
  	default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAA[... REDACTED ...]DuXGygFNIQicm6gsUb9y09ABSL2FhKERAQiZfTV4lZlOjBdW8KCZFOJRbC/DmDrjIwXdLHM2EWpULkiq7eNEa1YUdxw8BG/M/ZdE9zn1lHp0JLNbz2p/IwwWOyLR42Y1aaoXwyczThNuo2t8LgB0hPiocfioN3B6mohaRt6FgE5lICRBTKzYno66YAdWJzZoVqNsB1jtqPLiltg5lkO9rpioXp78/IpBybejAHMH12xPsD2tk/y02G/Kd0pJcY0KikMkL+cn root@Ev1lMan"
}


variable "ami_key" {
  	description = "Token API di DigitalOcean"
  	type        = string
}


# https://ap-northeast-1.console.aws.amazon.com/ec2/home?region=ap-northeast-1#KeyPairs:v=3;$case=tags:false%5C,client:false;$regex=tags:false%5C,client:false
## Fine parte di collegamento #############################################################################################################
###########################################################################################################################################


variable "InstanceType" {
  	description = "Hardware Profile"
  	type        = string
  	default = "t2.micro"
}



variable "ssh_port" {
  	description = "ssh tunnel"
  	type        = string
}

variable "Reflector_zone" {
  	description = "Token API di DigitalOcean"
  	type        = string
}


provider "aws" {
	access_key = var.aws_akey
	secret_key = var.aws_skey
	region = var.Reflector_zone
	alias = "region"
}


variable "index" {
  	description = "Indice di collegamento"
  	type        = string
  	default     = "1"
}


variable "dns_name_aws" {
  	description = "Nome che indica in caddyfile il nome dns del c2"
  	type        = string
  	default     = "sky-warp.net"
}


variable "dns_subname_aws" {
  	description = "nome subdomain del c2"
  	type        = string
  	default     = "upgrade"
}


variable "dns_redirsite_aws" {
  	description = "sito su cui redirezionare"
  	type        = string
  	default     = "www.repubblica.it"
}


variable "useragent" {
	description = "reflector useragent"
  	type        = string

}


variable "mail_record" {
type = bool
}

variable "name_record" {
type = bool
}


variable "ns_record" {
type = bool
}


variable "front_execution" {
type = bool
}

variable "front_region" {
type = string
}










