### Core Network System ################################################################################

module "SpectreCORE" {
  source = "./SpectreCORE"
  c4_nation = "FRA1"
  dns_name = var.dns_name
}


module "Transport" {
  source = "./Transport"
  spectreC4_ip = module.SpectreCORE.spectreC4_ip
  Transport_nation= "LON1"
  
  
}



/*
module "Rand_Store" { 
source = "./AWS-Net-Redir/Rand" 
}
*/

module "Service" {
  source = "./SRV-Sys"
  spectreC4_ip = module.SpectreCORE.spectreC4_ip
  Transport_nation= "AMS3"
  transport_ip = module.Transport.transport_ip
  # Servizio "store"
}


######################################################################################################

module "Rand_Tor" { 
source = "./AWS-Net-Redir/Rand" 
}

module "aws_tor_node" {
  source = "./AWS-Net-Redir"
  
  transport_ip = module.Transport.transport_ip
  
  ssh_port = "9443"
  
  Reflector_zone =  "eu-south-1" 
  ami_key = "ami-0a196592622fa712c"
  InstanceType= "t3.micro"

  name_connection = "tor" # tipologia : net o tor
  
  mail_record = true
  name_record = true
  ns_record = false

  front_execution = true
  front_region = "eu-central-1"

  index ="1"
  dns_name_aws= "sky-warp.net"
  dns_subname_aws = "tor-${module.Rand_Tor.random_lowercase_string}"
  dns_redirsite_aws = "www.repubblica.it"
  useragent = "Mozilla/5.0 (Windows NT 6.3.1; Trident/7.0; rv:11.1.0) like Gecko"
}




module "Rand_Net" { 
source = "./AWS-Net-Redir/Rand" 
}

module "aws_net_node" {
  source = "./AWS-Net-Redir"
 
  transport_ip = module.Transport.transport_ip
 
 ssh_port = "9443"
 
  Reflector_zone =  "us-east-2" 
  ami_key = "ami-0f97a2e81782245a9"
  InstanceType= "t3.micro"
  
  name_connection = "net" # tipologia
  
  mail_record = false
  name_record = true
  ns_record = true
  
  front_execution = true
  front_region = "eu-central-1"
  
  index ="1"
  dns_name_aws= "sky-warp.net"
  dns_subname_aws = "net-${module.Rand_Net.random_lowercase_string}"
  dns_redirsite_aws = "www.ansa.it"
  useragent = "Mozilla/5.0 (Windows NT 6.3.1; Trident/7.0; rv:11.1.0) like Gecko"
}


######################################################################################################
# CloudFront Optional  


######################################################################################################
# Security Core System

module "Firewall" {
  source = "./SEC-Sys"
  
  ip_transport = "10.30.30.3"
  ip_spectre    = "10.30.30.1"
  
  ip_aws_net = module.aws_net_node.aws_public_ip
  ip_aws_tor = module.aws_tor_node.aws_public_ip

}


######################################################################################################


module "C2" {

  source = "./C2S-Sys/Cobalt" # Option Cobalt / Sliver
 transport_ip = module.Transport.transport_ip
  C2_ip    = "10.30.30.1"
  useragent = "Mozilla/5.0 (Windows NT 6.3.1; Trident/7.0; rv:11.1.0) like Gecko" #   <---   Beacon
  
}

######################################################################################################


module "GEO" {

 source = "./GEO-Sys" 
 geo_target = "91.218.114.206"
 
 geo_spectreC4_ip=module.SpectreCORE.spectreC4_ip
 geo_transport_ip = module.Transport.transport_ip
 geo_service_ip= module.Service.service_ip
 geo_aws_tor_public_ip=module.aws_tor_node.aws_public_ip
 geo_aws_net_public_ip=module.aws_net_node.aws_public_ip

  
}

######################################################################################################

output "out_spectreC4_ip" {
  value = module.SpectreCORE.spectreC4_ip
}

output "out_transport1_ip" {
  value = module.Transport.transport_ip
}

output "out_service_ip" {
  value = module.Service.service_ip
}

output "out_aws_tor_ip" {
  value = module.aws_tor_node.aws_public_ip
}

output "out_aws_net_ip" {
  value = module.aws_net_node.aws_public_ip
}

#<-------------->#

output "CloudFront_TOR" {
  value = module.aws_tor_node.front_uri
}

output "CloudFront_NET" {
  value = module.aws_net_node.front_uri
}

#<-------------->#

output "Domain_TOR" {
  value =  "tor-${module.Rand_Tor.random_lowercase_string}.sky-warp.net"
}

output "Domain_NET" {
  value = "net-${module.Rand_Net.random_lowercase_string}.sky-warp.net"
}

/*

Codice Regione	Nome Immagine		Versione	Architettura		Tipo di Storage		Data		AMI ID					Virtual	Città
eu-north-1		Mantic Minotaur		23.10		amd64			hvm:ebs-ssd-gp3		20240409	ami-088f19f7a057ea8c1	hvm	Stoccolma, Svezia
me-central-1		Mantic Minotaur		23.10		amd64			hvm:ebs-ssd-gp3		20240409	ami-0a6caf40c806c498b	hvm	Bahrain
eu-west-1		Mantic Minotaur		23.10		amd64			hvm:ebs-ssd-gp3		20240409	ami-07dd83c0e8173da11	hvm	Irlanda
ca-central-1		Mantic Minotaur		23.10		amd64			hvm:ebs-ssd-gp3		20240409	ami-064e8a4a6fd26f2b1	hvm	Montreal, Canada
eu-south-1		Mantic Minotaur		23.10		amd64			hvm:ebs-ssd-gp3		20240409	ami-0a196592622fa712c	hvm	Milano, Italia
us-west-1		Mantic Minotaur		23.10		amd64			hvm:ebs-ssd-gp3		20240409	ami-0e72121a28f32689d	hvm	California, USA
il-central-1		Mantic Minotaur		23.10		amd64			hvm:ebs-ssd-gp3		20240409	ami-0dc6bc95270a55f77	hvm	Tel Aviv, Israele
ap-southeast-1	Mantic Minotaur		23.10		amd64			hvm:ebs-ssd-gp3		20240409	ami-0ac1fedaa0f393737	hvm	Singapore
af-south-1		Mantic Minotaur		23.10		amd64			hvm:ebs-ssd-gp3		20240409	ami-0bbf2fa1c72c6b3df	hvm	Città del Capo, Sudafrica
ap-east-1		Mantic Minotaur		23.10		amd64			hvm:ebs-ssd-gp3		20240409	ami-073205de29ed93c75	hvm	Hong Kong
ca-west-1		Mantic Minotaur		23.10		amd64			hvm:ebs-ssd-gp3		20240409	ami-0717aef05c152c249	hvm	Vancouver, Canada
sa-east-1		Mantic Minotaur		23.10		amd64			hvm:ebs-ssd-gp3		20240409	ami-026af315d78031c7e	hvm	San Paolo, Brasile
ap-south-1		Mantic Minotaur		23.10		amd64			hvm:ebs-ssd-gp3		20240409	ami-063508c06d3ca5fbb	hvm	Mumbai, India
eu-central-1		Mantic Minotaur		23.10		amd64			hvm:ebs-ssd-gp3		20240409	ami-00828886c6555e883	hvm	Francoforte, Germania
ap-northeast-1	Mantic Minotaur		23.10		amd64			hvm:ebs-ssd-gp3		20240409	ami-0ecd1a391c2ef3481	hvm	Tokyo, Giappone
me-south-1		Mantic Minotaur		23.10		amd64			hvm:ebs-ssd-gp3		20240409	ami-02fd33db69befbb75	hvm	Dubai, Emirati Arabi Uniti
us-east-1		Mantic Minotaur		23.10		amd64			hvm:ebs-ssd-gp3		20240409	ami-0a44aefa5a8df82eb	hvm	Virginia, USA

aws ec2 describe-instance-type-offerings --location-type availability-zone --filters Name=instance-type,Values=t2.micro --region eu-south-2

aws ec2 describe-instance-type-offerings --location-type availability-zone  --region eu-south-1

https://cloud-images.ubuntu.com/locator/ec2/

"
ap-south-1	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-0bd6748b1e79717d9	hvm
eu-central-1	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-08f3676630093c0b6	hvm
af-south-1	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-0491a95f98bd4fc04	hvm
il-central-1	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-06966c94f514c7619	hvm
eu-north-1	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-07a504aac5bbb51dc	hvm
me-central-1	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-04c04ed6c22bdc4b9	hvm
eu-south-1	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208		hvm
me-south-1	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-0f224452a55623940	hvm
ca-west-1	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-04b2aadbb15be015e	hvm
ap-east-1	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-04d256ff6ba86269f	hvm
ap-northeast-1	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-03327662924d774c9	hvm
sa-east-1	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-0a97a2603d4e125bc	hvm
us-east-1	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-0ea09f73e400d0c98	hvm
ap-southeast-1	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-0877e6703a9c2fea8	hvm
cn-northwest-1	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-0b18fc9c3e66cdd30	hvm
cn-north-1	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-028116f979d9bae96	hvm
ca-central-1	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-0f1a6e6f6edf13acf	hvm
eu-west-1	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-01cea3535540416c2	hvm
us-west-1	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-07ad5d832a8fdfcea	hvm
ap-south-2	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-0337a9e2f9e61b90e	hvm
eu-west-2	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-052afa779db8565b4	hvm
us-west-2	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-0353305cd3c20be96	hvm
eu-south-2	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-02fff7d5ad5f047df	hvm
ap-northeast-2	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-00fae4dd7228b420a	hvm
us-east-2	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-0f97a2e81782245a9	hvm
ap-southeast-2	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-070116ae436832efc	hvm
eu-central-2	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-06c4310928b454dde	hvm
eu-west-3	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-0d2b9b59831236d3e	hvm
ap-northeast-3	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-05633f9c8d3516000	hvm
ap-southeast-3	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-0180f2b22cd907c70	hvm
ap-southeast-4	Mantic Minotaur	23.10	amd64	hvm:ebs-ssd-gp3	20240208	ami-067232dc6dbc99dee	hvm


NYC1: New York City 1, Stati Uniti
NYC2: New York City 2, Stati Uniti
NYC3: New York City 3, Stati Uniti
SFO1: San Francisco 1, Stati Uniti
SFO2: San Francisco 2, Stati Uniti
SFO3: San Francisco 2, Stati Uniti
AMS2: Amsterdam 2, Paesi Bassi
AMS3: Amsterdam 3, Paesi Bassi
LON1: Londra 1, Regno Unito
FRA1: Francoforte 1, Germania
TOR1: Toronto 1, Canada
SGP1: Singapore 1, Singapore
BLR1: Bangalore 1, India
SYD1: Sydney 1, Australia
*/



