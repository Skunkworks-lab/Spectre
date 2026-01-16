

locals {
  index1 = "2"

}


resource "digitalocean_droplet" "Service2" {
  
    name = "Service${local.index1}"
    image = "ubuntu-23-10-x64"
    region = var.Transport_nation
    size = "s-4vcpu-8gb"
    #depends_on = [module.SpectreCORE]
    ipv6 = false

    
    ssh_keys = [
       "${var.ssh_fingerprint}"
    ]

    connection {
	host = self.ipv4_address
        user = "root"
        type = "ssh"
        private_key = file(var.pvt_key)
        timeout = "2m"
      }






##>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>VPN


provisioner "remote-exec" {
        inline = [	
		"apt update",
                "export DEBIAN_FRONTEND=noninteractive ;  apt install -y openvpn"
	]
        connection {
            type = "ssh"
            user = "root"
            private_key = file(var.pvt_key)
        }
    }

    provisioner "local-exec" {
        
	command = <<EOT
            
           if [ ! -f pki/issued/Shark${local.index1}.crt ]; then
               EASYRSA_BATCH='yes' repo/easy-rsa/easyrsa3/easyrsa build-client-full Shark${local.index1} nopass
           fi
	EOT
    }

    provisioner "file" {
        source = "pki/ca.crt"
        destination = "/etc/openvpn/client/ca.crt"
        connection {
            type = "ssh"
            user = "root"
            private_key = file(var.pvt_key)
        }
    }

    provisioner "file" {
        source = "pki/ta.key"
        destination = "/etc/openvpn/client/ta.key"

        connection {
            type = "ssh"
            user = "root"
            private_key = file(var.pvt_key)
        }
    }

    provisioner "file" {
        source = "pki/issued/Shark${local.index1}.crt"
        destination = "/etc/openvpn/client/client.crt"
        connection {
            type = "ssh"
            user = "root"
            private_key = file(var.pvt_key)
        }
    }

    provisioner "file" {
        source = "pki/private/Shark${local.index1}.key"
        destination = "/etc/openvpn/client/client.key"
        connection {
            type = "ssh"
            user = "root"
            private_key = file(var.pvt_key)
        }
    }

    provisioner "file" {
        source = "repo/openvpn/clients/client.conf"
        destination = "/etc/openvpn/client/client.conf"
        connection {
            type = "ssh"
            user = "root"
            private_key = file(var.pvt_key)
        }
    }

   provisioner "file" {
        source = "repo/openvpn/clients/openvpn-server@client.service"
        destination = "/etc/systemd/system/multi-user.target.wants/openvpn-server@client.service"
        connection {
            type = "ssh"
            user = "root"
            private_key = file(var.pvt_key)
        }
    }

    provisioner "remote-exec" {
        inline = [	
		#"sed -i 's/openvpnserverplaceholder/${module.SpectreCORE.spectreC4_ip}/g' /etc/openvpn/client/client.conf",
		"sed -i 's/openvpnserverplaceholder/${var.spectreC4_ip}/g' /etc/openvpn/client/client.conf",
                "systemctl enable openvpn-client@client.service",
                "systemctl start openvpn-client@client.service"
		 ]
        connection {
            type = "ssh"
            user = "root"
            private_key = file(var.pvt_key)
        }
    }

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>vpn
provisioner "remote-exec" {
        inline = [
        	"echo WOOOOOOOOOOOW we are Connect TO : ${var.transport_ip}",
        	"echo 'Hello AWS EC2'"
		]
		connection {
            		type = "ssh"
            		user = "root"
            		private_key = file(var.pvt_key)
        	}
    	}





provisioner "remote-exec" {
        inline = [
        "export DEBIAN_FRONTEND=noninteractive ;  apt -y install socat",
        "apt update",
        # sudo apt install -y docker.io
        # curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	# chmod +x /usr/local/bin/docker-compose
	# mkdir ~/BloodHoundProject
	"apt -y install nginx",
	"mkdir /var/www/html/store",
	"git clone https://github.com/r3motecontrol/Ghostpack-CompiledBinaries.git /var/www/html/store",
	"systemctl start nginx",
	"chown -R www-data:www-data /var/www/html/store",
        "chmod -R 755 /var/www/html/store",
        # install bloodhound
        "apt -y install ca-certificates curl",
        "install -m 0755 -d /etc/apt/keyrings",
        "curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc",
        "chmod a+r /etc/apt/keyrings/docker.asc",
        "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null ; ",
        "export DEBIAN_FRONTEND=noninteractive ; sudo apt-get update",
	"export DEBIAN_FRONTEND=noninteractive ;  apt-get install  -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",
	#"wget -P /var/www/html/store https://raw.githubusercontent.com/SpecterOps/bloodhound/main/examples/docker-compose/docker-compose.yml",
	#"curl -L https://ghst.ly/getbhce | docker compose  - up -d",
	#"docker logs root-bloodhound-1  | grep 'Initial Password Set To' > /var/www/html/store/cache_password.txt"
       ]
        connection {
            type = "ssh"
            user = "root"
            private_key = file(var.pvt_key)
        }
    }



provisioner "file" {
        source = "repo/services/NginxPayload/default"
        destination = "/etc/nginx/sites-available/default"
        connection {
            type = "ssh"
            user = "root"
            private_key = file(var.pvt_key)
        }
    }



   provisioner "file" {
        source = "repo/docker/bloodhound/docker-compose.yml"
        destination = "/root/docker-compose.yml"
        connection {
            type = "ssh"
            user = "root"
            private_key = file(var.pvt_key)
        }
    }

provisioner "remote-exec" {
        inline = [
        "sudo systemctl restart nginx"
       ]
        connection {
            type = "ssh"
            user = "root"
            private_key = file(var.pvt_key)
        }
    }




provisioner "local-exec" {
    command = "ssh -o 'StrictHostKeyChecking no' -i ${var.pvt_key} root@${self.ipv4_address} '(docker compose up -d)&' "
	
  }


provisioner "local-exec" {
    command = "ssh -o 'StrictHostKeyChecking no' -i ${var.pvt_key} root@${self.ipv4_address} '(docker logs root-bloodhound-1 2>&1 | grep \"Initial Password Set To\" > /var/www/html/store/cache_password.txt)&' "
	
  }


}


output "service_ip" {
  value = digitalocean_droplet.Service2.ipv4_address
}


