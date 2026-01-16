

variable "pub_key" {
	description = "public"
  	type        = string
  	default     = "/home/[REDACTED]/Spectre/repo/digitalocean/.ssh/id_rsa.pub"
}


variable "pvt_key" {
	description = "private"
  	type        = string
  	default     = "/home/[REDACTED]/Spectre/repo/digitalocean/.ssh/id_rsa"
}


variable "aws_akey" {
  	description = "Token API di DigitalOcean"
  	type        = string
  	default     = "AKIAI5ZOANY[REDACTED]"
}

variable "aws_skey" {
  	description = "Token API di DigitalOcean"
  	type        = string
  	default     = "bFfRPRbNMpCeiIe7hM[REDACTED]GLccE/"
}


variable "local_key" {
  	description = "Token API di DigitalOcean"
  	type        = string
  	default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCj4 [... REDACTED ...]Qicm6gsUb9y09ABSL2FhKERAQiZfTV4lZlOjBdW8KCZFOJRbC/DmDrjIwXdLHM2EWpULkiq7eNEa1YUdxw8BG/M/ZdE9zn1lHp0JLNbz2p/IwwWOyLR42Y1aaoXwyczThNuo2t8LgB0hPiocfioN3B6mohaRt6FgE5lICRBTKzYno66YAdWJzZoVqNsB1jtqPLiltg5lkO9rpioXp78/IpBybejAHMH12xPsD2tk/y02G/Kd0pJcY0KikMkL+cn root@Ev1lMan"
}



# https://ap-northeast-1.console.aws.amazon.com/ec2/home?region=ap-northeast-1#KeyPairs:v=3;$case=tags:false%5C,client:false;$regex=tags:false%5C,client:false
## Fine parte di collegamento #############################################################################################################
###########################################################################################################################################


variable "region" {
type = string
}




provider "aws" {

	access_key = var.aws_akey
	secret_key = var.aws_skey
	region = var.region
	alias = "region"	
}


variable "dns_name_aws" {
  	description = "Nome che indica in caddyfile il nome dns del c2"
  	type        = string

}


variable "dns_subname_aws" {
  	description = "nome subdomain del c2"
  	type        = string

}



variable "key" {
  	description = "randomstring"
  	type        = string

}





variable "execution" {
type = bool
}




