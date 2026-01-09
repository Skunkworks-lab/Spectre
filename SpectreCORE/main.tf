
resource "digitalocean_droplet" "SpectreC4" {
    image = "ubuntu-23-10-x64"
    name = "SpectreC4"
    region = var.c4_nation
    size = "s-1vcpu-1gb"
    ipv6 = false

    ssh_keys = [var.ssh_fingerprint]

    connection {
	host = self.ipv4_address
        user = "root"
        type = "ssh"
        private_key = "${file(var.pvt_key)}"
        timeout = "2m"
      }


# provisioner "local-exec" {
#command = "openvpn --daemon ./scripts/VpnExit/vpnbook-de4-tcp443.ovpn"
#    }


    provisioner "remote-exec" {
        inline = [	
		"apt update",
                "sleep 10",
		"export DEBIAN_FRONTEND=noninteractive ; apt install -y openvpn"
        ]

        connection {
            type = "ssh"
            user = "root"
            private_key = file(var.pvt_key)
        }
    }

   #### su kali generazione chiave ca
    provisioner "local-exec" {
	command = <<EOT
            hostname
            rm -rf pki
            rm -rf /etc/openvpn/client
	    repo/easy-rsa/easyrsa3/easyrsa init-pki --batch
	    EASYRSA_BATCH='yes' repo/easy-rsa/easyrsa3/easyrsa build-ca nopass
	    repo/easy-rsa/easyrsa3/easyrsa gen-dh --batch
	    openvpn --genkey secret pki/ta.key 
	    EASYRSA_BATCH='yes' repo/easy-rsa/easyrsa3/easyrsa build-server-full ${digitalocean_droplet.SpectreC4.name} nopass --batch
            EASYRSA_BATCH='yes' repo/easy-rsa/easyrsa3/easyrsa build-client-full local-server nopass
	    repo/easy-rsa/easyrsa3/easyrsa gen-crl
            mkdir /etc/openvpn/client
            cp pki/ca.crt /etc/openvpn/client/ca.crt
            cp pki/ta.key /etc/openvpn/client/ta.key
            cp pki/issued/local-server.crt /etc/openvpn/client/client.crt
            cp pki/private/local-server.key /etc/openvpn/client/client.key
            cp repo/openvpn/clients/client.conf /etc/openvpn/client/client.conf
            sed -i 's/openvpnserverplaceholder/${digitalocean_droplet.SpectreC4.ipv4_address}/g' /etc/openvpn/client/client.conf
            cp repo/openvpn/clients/openvpn-server@client.service /etc/systemd/system/multi-user.target.wants/openvpn-server@client.service
            systemctl stop openvpn-client@client.service
            systemctl start openvpn-client@client.service

	sysctl net.ipv4.ip_forward=1

	EOT
    }

    provisioner "file" {
	#chiave pubblica CA
        source = "pki/ca.crt"
        destination = "/etc/openvpn/server/ca.crt"

        connection {
            type = "ssh"
            user = "root"
            private_key = file(var.pvt_key)
        }
    }

    provisioner "file" {
	#chiave simmetrica
        source = "pki/ta.key"
        destination = "/etc/openvpn/server/ta.key"

        connection {
            type = "ssh"
            user = "root"
            private_key = file(var.pvt_key)
        }
    }
    provisioner "file" {
	#bupload chiave pubblica server VPN
        source = "pki/issued/${digitalocean_droplet.SpectreC4.name}.crt"
        destination = "/etc/openvpn/server/server.crt"

        connection {
            type = "ssh"
            user = "root"
            private_key = file(var.pvt_key)
        }
    }
    provisioner "file" {
	#upload chiave privata
        source = "pki/private/${digitalocean_droplet.SpectreC4.name}.key"
        destination = "/etc/openvpn/server/server.key"

        connection {
            type = "ssh"
            user = "root"
            private_key = file(var.pvt_key)
        }
    }
    provisioner "file" {
	# upload diffie Hellman
        source = "pki/dh.pem"
        destination = "/etc/openvpn/server/dh.pem"

        connection {
            type = "ssh"
            user = "root"
            private_key = file(var.pvt_key)
        }
    }

    provisioner "file" {
	#upload file configurazione server vpn
        source = "repo/openvpn/server/server.conf"
        destination = "/etc/openvpn/server/server.conf"

        connection {
            type = "ssh"
            user = "root"
            private_key = file(var.pvt_key)
        }
    }
    
  

   provisioner "file" {
        source = "repo/openvpn/server/openvpn-server@server.service"
        destination = "/etc/systemd/system/multi-user.target.wants/openvpn-server@server.service"

        connection {
            type = "ssh"
            user = "root"
            private_key = file(var.pvt_key)
        }
    }

    provisioner "remote-exec" {
        inline = [	
	# tira su i server
		"systemctl enable openvpn-server@server.service",
		"systemctl start openvpn-server@server.service"
        ]

        connection {
            type = "ssh"
            user = "root"
            private_key = file(var.pvt_key)
        }
    }
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################


    
/*


provisioner "file" {
        source = "repo/Spectre/hellgateC2.service"
        destination = "/etc/systemd/system/hellgateC2.service"

        connection {
            type = "ssh"
            user = "root"
            private_key = file(var.pvt_key)
        }
    }


   */ 
    
    ###################################################################


provisioner "file" {
        source = "repo/Spectre/Tinyproxy/tinyproxy.conf"
        destination = "/root/tinyproxy.conf"

        connection {
            type = "ssh"
            user = "root"
            private_key = "${file("${var.pvt_key}")}"
        }
    }


provisioner "file" {
        source = "repo/Spectre/CertificateNcat/keyDif.pem"
        destination = "/keyDif.pem"

        connection {
            type = "ssh"
            user = "root"
            private_key = "${file("${var.pvt_key}")}"
        }
    }
    
    
provisioner "file" {
        source = "repo/Spectre/CertificateNcat/certDif.pem"
        destination = "/certDif.pem"

        connection {
            type = "ssh"
            user = "root"
            private_key = "${file("${var.pvt_key}")}"
        }
    }




provisioner "remote-exec" {
	inline = [
		#"export DEBIAN_FRONTEND=noninteractive ;  apt install -y socat",
		"export DEBIAN_FRONTEND=noninteractive ;  apt install -y tinyproxy-bin",
		"export DEBIAN_FRONTEND=noninteractive ;  apt install -y net-tools",
		#"systemctl start hellgateC2.service",
		"tinyproxy -c /root/tinyproxy.conf",
		"echo 'AllowAgentForwarding yes' >> /etc/ssh/sshd_config",
		"echo 'AllowTcpForwarding yes' >> /etc/ssh/sshd_config",
		"echo 'GatewayPorts yes' >> /etc/ssh/sshd_config",
		"echo 'UsePrivilegeSeparation yes' >> /etc/ssh/sshd_config",
		"echo 'ClientAliveInterval 120' >> /etc/ssh/sshd_config",
		"systemctl restart ssh"
	]
	connection {
            
            type = "ssh"
            user = "root"
            private_key = file(var.pvt_key)
        }
    }


}


#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################




output "spectreC4_ip" {
  value = digitalocean_droplet.SpectreC4.ipv4_address
}

