

locals {
  index1 = "1"

}


resource "digitalocean_droplet" "Transport1" {
  
    name = "Transport${local.index1}"
    image = "ubuntu-23-10-x64"
    region = var.Transport_nation
    size = "s-1vcpu-1gb"
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

/*
provisioner "local-exec" {
	command = <<-EOT
    		rm -f ./repo/Transport/SocatService.tar.gz ;
    		tar -czvf ./repo/Transport/SocatService.tar.gz -C ./repo/Transport SocatService ;
	EOT
  }


 provisioner "file" {
        source = "repo/Transport/SocatService.tar.gz"
        destination = "/root/SocatService.tar.gz"
        connection {
            type = "ssh"
            user = "root"
            private_key = file(var.pvt_key)
        }
    }

*/

provisioner "file" {
        source = "repo/Transport/SocatService/socatDNS_convert.service"
        destination = "/root/socatDNS_convert.service"
        connection {
            type = "ssh"
            user = "root"
            private_key = file(var.pvt_key)
        }
    }

provisioner "remote-exec" {
        inline = [
        "export DEBIAN_FRONTEND=noninteractive ; apt -y install socat",
	"echo \"deb https://deb.torproject.org/torproject.org $(lsb_release -sc) main\" > /etc/apt/sources.list.d/tor-project.list",
	"sleep 10; curl https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor --output tor.gpg",
	"sleep 10; sudo mv tor.gpg /etc/apt/trusted.gpg.d/tor.gpg",
	"apt update",
	"sleep 10; export DEBIAN_FRONTEND=noninteractive ; apt install -y tor deb.torproject.org-keyring",
	"echo 'nameserver 8.8.8.8' > /etc/resolv.conf",
	#iptable
	"cp /root/socatDNS_convert.service /etc/systemd/system/socatDNS_convert.service",
	"echo 1 > /proc/sys/net/ipv4/ip_forward",
	"sudo iptables -t nat -F",
	"sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 4443 -j DNAT --to-destination 10.30.30.1:22",
	"sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 8081 -j DNAT --to-destination 10.30.30.4:80",
	"sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 8181 -j DNAT --to-destination 10.30.30.1:80",
	"sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 8080 -j DNAT --to-destination 10.30.30.1:443",
	"sudo iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE",
	"sudo iptables -A FORWARD -s 10.30.30.0/24 -j ACCEPT",
	"sudo iptables -A FORWARD -d 10.30.30.0/24 -j ACCEPT",
       #"tar xvzf SocatService.tar.gz",
	#"cp -R /root/SocatService/* /etc/systemd/system/",
	"systemctl daemon-reload",
	#"systemctl enable socatHTTPS.service",
	#"systemctl enable socatNGINX.service",
	#"systemctl enable socatHTTP.service",
	#"systemctl enable socatDNS.service",
	# # lsscio qui un listener da 53 TCP a 53 UDP verso il C2
	"systemctl enable socatDNS_convert.service",
	#"systemctl enable socatTUNNEL.service",
	#"systemctl start socatHTTPS.service",
	#"systemctl start socatNGINX.service",
	#"systemctl start socatHTTP.service",
	#"systemctl start socatDNS.service",
	"systemctl start socatDNS_convert.service",
	#"systemctl start socatTUNNEL.service",
	"systemctl disable systemd-resolved",
	"systemctl stop systemd-resolved"
       ]
        connection {
            type = "ssh"
            user = "root"
            private_key = file(var.pvt_key)
        }
    }


provisioner "file" {
        source = "repo/Onion/torrc_5"
        destination = "/etc/tor/torrc"

        connection {
            type = "ssh"
            user = "root"
            private_key = file(var.pvt_key)
        }
    }



provisioner "remote-exec" {
        inline = [
	"service tor restart"
	
	]
	
        connection {
            type = "ssh"
            user = "root"
            private_key = file(var.pvt_key)
        }
    }





provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${var.pvt_key} root@${self.ipv4_address}:/var/lib/tor/hidden_service/hostname repo/Onion/cache/hostname_${local.index1}"
	
  }




provisioner "local-exec" {
    
	command = "cat repo/Onion/cache/hostname_${local.index1} | tr -d '\\n' | tee repo/Onion/cache/hostname__${local.index1}"
  }


}


output "transport_ip" {
  value = digitalocean_droplet.Transport1.ipv4_address
}


