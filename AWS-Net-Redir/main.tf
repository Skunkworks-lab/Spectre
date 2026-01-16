variable "use_tor_exec" {
  description = "Indica se utilizzare il primo tipo di provisioner remote-exec"
  type        = bool
  default     = false
}

variable "use_net_exec" {
  description = "Indica se utilizzare il secondo tipo di provisioner remote-exec"
  type        = bool
  default     = false
}

resource "aws_instance" "http-rdir" {
    	provider = aws.region
    	ami = var.ami_key
    	instance_type = var.InstanceType
    	key_name = "${aws_key_pair.localkey.key_name}"
    	vpc_security_group_ids = ["${aws_security_group.http-redirector-security.id}"]
    	subnet_id = "${aws_subnet.default.id}"
    	associate_public_ip_address = true
	private_ip = "10.0.0.1${var.index}"
	
	
tags = {
    Name = "http-rdir-${var.index}"
    # Aggiungi altre etichette se necessario...
  }
provisioner "remote-exec" {
        inline = [
        	"echo WOOOOOOOOOOOW we are Connect TO : ${var.transport_ip}",
        	"echo 'Hello AWS EC2'"
		]
		connection {
            		host = self.public_ip
            		type = "ssh"
            		user = "ubuntu"
            		private_key = "${file("${var.pvt_key}")}"
        	}
    	}
        	
        provisioner "file" {
        	source = "repo/Redirector/Caddyfile"
        	destination = "/home/ubuntu/Caddyfile"
		connection {
			host = self.public_ip
            		type = "ssh"
            		user = "ubuntu"
            		private_key = file(var.pvt_key)
        	}
    	}	
    	
    	provisioner "file" {
        	source = "repo/Redirector/caddy.service"
        	destination = "/tmp/caddy.service"
		connection {
			host = self.public_ip
            		type = "ssh"
            		user = "ubuntu"
            		private_key = file(var.pvt_key)
        	}
    	}
	
	provisioner "file" {
        	source = "repo/Onion/cache/hostname_${var.index}"
        	destination = "/home/ubuntu/hostname__${var.index}"
		connection {
			host = self.public_ip
            		type = "ssh"
            		user = "ubuntu"
            		private_key = file(var.pvt_key)
        	}
    	}
    	
    	
    	provisioner "remote-exec" {
        inline = [
        	"echo ${var.transport_ip}",
		"sudo su -c 'echo \"reflector-${var.index}\" > /etc/hostname; echo \"127.0.0.1 reflector-${var.index}\" > /etc/hosts'",
		"sudo su -c 'echo \"127.0.0.1 $(hostname)\" >> /etc/hosts'",
		"sudo su -c 'rm /etc/resolv.conf'",
		"sudo su -c 'echo nameserver 8.8.8.8 > /etc/resolv.conf'",
		"sudo apt install -y apt-transport-https",
		"sudo echo deb https://deb.torproject.org/torproject.org bionic main >> /etc/apt/sources.list",
		#"echo deb-src https://deb.torproject.org/torproject.org bionic main >>  /etc/apt/sources.list",
		"curl https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --import",
		"echo \"deb https://artifacts.elastic.co/packages/6.x/apt stable main\" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list",
		"wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add",	
		"sudo apt-get update",
		"sudo apt install -y tor deb.torproject.org-keyring",
		"sudo apt install -y tor",
		"sudo apt install -y daemonize",
		"sudo apt-get update",
		"sudo apt install -y socat",
		"sudo apt install -y daemonize",
		"sudo apt install -y tor",
		"sudo cp /tmp/caddy.service /etc/systemd/system/caddy.service",
            	"echo \"sleep 30s\" > socat.sh"
            	]
		connection {
            		host = self.public_ip
            		type = "ssh"
            		user = "ubuntu"
            		private_key = "${file("${var.pvt_key}")}"
        	}
    	}
    	
    	
    	# Settaggio File per incanalare comandi attraverso TOR
	provisioner "remote-exec" {
	
        inline = [    	
		#"sudo su -c 'echo \"socat tcp4-listen:443,reuseaddr,fork SOCKS4A:127.0.0.1:$(cat hostname1):443,socksport=9050\" > /etc/rc.local'",
		"echo \"daemonize /usr/bin/socat tcp4-listen:${var.ssh_port},reuseaddr,fork SOCKS4A:127.0.0.1:aaaa-aaaa-aaaa-aaaa:14443,socksport=9050\" >> tor.sh",
            	"echo \"daemonize /usr/bin/socat tcp4-listen:8080,reuseaddr,fork SOCKS4A:127.0.0.1:aaaa-aaaa-aaaa-aaaa:18080,socksport=9050\" >> tor.sh",
            	"echo \"daemonize /usr/bin/socat tcp4-listen:8081,reuseaddr,fork SOCKS4A:127.0.0.1:aaaa-aaaa-aaaa-aaaa:18081,socksport=9050\" >> tor.sh",
		"echo \"daemonize /usr/bin/socat UDP4-listen:53,reuseaddr,fork SOCKS4A:127.0.0.1:aaaa-aaaa-aaaa-aaaa:153,socksport=9050\" >> tor.sh",
		"sed -i \"s/aaaa-aaaa-aaaa-aaaa/$(cat /home/ubuntu/hostname__${var.index})/g\" tor.sh"
		]
		
		connection {
            		host = self.public_ip
            		type = "ssh"
            		user = "ubuntu"
            		private_key = "${file("${var.pvt_key}")}"
        	}
    	}	
    	
    	
        # Settaggio File per incanalare comandi attraverso NET
    	provisioner "remote-exec" {
        inline = [    	
		#"echo \"sudo daemonize /usr/bin/socat tcp4-listen:4443,reuseaddr,fork tcp:aaaa-aaaa-aaaa-aaaa:4443\" >> net.sh",
            	"echo \"sudo daemonize /usr/bin/socat tcp4-listen:8080,reuseaddr,fork tcp:aaaa-aaaa-aaaa-aaaa:8080\" >> net.sh",
            	"echo \"sudo daemonize /usr/bin/socat tcp4-listen:8081,reuseaddr,fork tcp:aaaa-aaaa-aaaa-aaaa:8081\" >> net.sh",
            	"echo \"sudo daemonize /usr/bin/socat tcp4-listen:8181,reuseaddr,fork tcp:aaaa-aaaa-aaaa-aaaa:8181\" >> net.sh",
            	#"echo \"sudo sysctl net.ipv4.conf.ens5.route_localnet=1\"  >> net.sh",
        	"echo \"echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward\"  >> net.sh",
		"echo \"sudo iptables -t nat -F\" >> net.sh",
		"echo \"sudo iptables -t nat -A PREROUTING -p tcp --dport ${var.ssh_port} -j DNAT --to-destination aaaa-aaaa-aaaa-aaaa:4443\" >> net.sh",
		#"echo \"sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 8080 -j DNAT --to-destination aaaa-aaaa-aaaa-aaaa:8080\" >> net.sh",
		#"echo \"sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 8081 -j DNAT --to-destination aaaa-aaaa-aaaa-aaaa:8081\" >> net.sh",
		#"echo \"sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 8181 -j DNAT --to-destination aaaa-aaaa-aaaa-aaaa:8181\" >> net.sh",
		"echo \"sudo iptables -t nat -A POSTROUTING -j MASQUERADE\" >> net.sh",
            	"echo \"sudo daemonize /usr/bin/socat udp4-listen:53,reuseaddr,fork tcp:aaaa-aaaa-aaaa-aaaa:53\" >> net.sh",
		"sed -i \"s/aaaa-aaaa-aaaa-aaaa/${var.transport_ip}/g\" net.sh"
		]
		
		connection {
            		host = self.public_ip
            		type = "ssh"
            		user = "ubuntu"
            		private_key = "${file("${var.pvt_key}")}"
        	}
    	}		
		
	provisioner "remote-exec" {
        inline = [	
		"sudo systemctl disable systemd-resolved",
		"sudo systemctl stop systemd-resolved",
		"cp ${var.name_connection}.sh socat.sh",
		"chmod +x ./socat.sh",
		"echo \"echo Hello World!!!\" >> socat.sh",
		"sudo su -c './socat.sh'",
		"sed -i \"s/##-##-##/${var.dns_name_aws}/g\" /home/ubuntu/Caddyfile",
		"sed -i \"s/#####/${var.dns_subname_aws}/g\" /home/ubuntu/Caddyfile",
		"sed -i \"s/----------/${var.dns_redirsite_aws}/g\" /home/ubuntu/Caddyfile",
		"sed -i 's|MYUSERAGENT|'\"${var.useragent}\"'|g' /home/ubuntu/Caddyfile",
		"wget https://github.com/caddyserver/caddy/releases/download/v2.5.2/caddy_2.5.2_linux_amd64.tar.gz",
                "sudo tar -C /usr/local/bin -xzf caddy_2.5.2_linux_amd64.tar.gz",
                "sudo chmod +x /usr/local/bin/caddy",
                "sudo systemctl daemon-reload",
		"sudo systemctl start caddy",
		"sudo systemctl enable caddy"
		]
		connection {
            		host = self.public_ip
            		type = "ssh"
            		user = "ubuntu"
            		private_key = "${file("${var.pvt_key}")}"
        	}
    	}




}

#####################################################################################################################


module "CloudFlareName" { # modiuficato

  execution = var.name_record

  source = "../CFL-Sys/CloudFlare-NAME"
  aws_public_ip = aws_instance.http-rdir.public_ip
  zone_id =  "37ddccdb2be7e49c1d7b3a106aaa89f3"
  index = "1"
  dns_name_cf= var.dns_name_aws
  dns_subname_cf= var.dns_subname_aws
  CDN_PROXY_1 = "false"

}



module "CloudFlareMail" {

 execution = var.mail_record

  source = "../CFL-Sys/CloudFlare-Mail"
  aws_public_ip = aws_instance.http-rdir.public_ip
  zone_id = "37ddccdb2be7e49c1d7b3a106aaa89f3"
  index = "1"
  
  mail_record_cf = "mx"
  
  dns_name_cf= var.dns_name_aws
  dns_subname_cf= var.dns_subname_aws
  CDN_PROXY_1 = "false"

}





module "CloudFlareNS" {

 execution = var.mail_record

  source = "../CFL-Sys/CloudFlare-NS"
  aws_public_ip = aws_instance.http-rdir.public_ip
  zone_id = "37ddccdb2be7e49c1d7b3a106aaa89f3"
  index = "1"
  
  ns_record_cf = "nameserver"
  
  dns_name_cf= var.dns_name_aws
  dns_subname_cf= var.dns_subname_aws
  CDN_PROXY_1 = "false"

}



module "Rand_To" {
  source = "./Rand" 
}



module "CloudfrontNet" {
  source = "./AWS-Net-Front" 
  key = module.Rand_To.random_lowercase_string
  execution = var.front_execution
  region = var.front_region
  dns_name_aws= var.dns_name_aws
  dns_subname_aws = var.dns_subname_aws
}



## possibilità di inserirlo nel nodo per il canale tor

output "front_uri" {
  value = module.CloudfrontNet.disturl
}


output "aws_public_ip" {
  value = aws_instance.http-rdir.public_ip
}
