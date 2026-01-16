


resource "null_resource" "cobalt" {
  # Imposta dipendenza dall'istanza AWS



provisioner "local-exec" {
	command = <<-EOT
    		echo ${var.transport_ip} ;
    		cp -r ./repo/Cobalt/Client /root/client ;
    		rm -f ./repo/Cobalt/teamserver.tar.gz ;
    		tar -czvf ./repo/Cobalt/teamserver.tar.gz -C ./repo/Cobalt teamserver ;
	EOT
  }


provisioner "file" {
        	source = "repo/Cobalt/teamserver.tar.gz"
        	destination = "/root/teamserver.tar.gz"
		connection {
			host = var.C2_ip
            		type = "ssh"
            		user = "root"
            		private_key = file(var.pvt_key)
        	}
    	}

provisioner "remote-exec" {
	inline = [
		"tar xvzf teamserver.tar.gz",
		"DEBIAN_FRONTEND=noninteractive apt-get -yq install default-jdk",
		"chmod +x ./teamserver/agscript",
		"sed -i \"s/MYPASSWORD/password/g\" /root/teamserver/teamserver.service",
		"sed -i \"s/INDIRIZZOIP/${var.C2_ip}/g\" /root/teamserver/teamserver.service",
		"sed -i 's|MYUSERAGENT|'\"${var.useragent}\"'|g' /root/teamserver/m.profile",
		"cp /root/teamserver/teamserver.service /etc/systemd/system/teamserver.service",
		"sudo systemclt daemon-reload",
		"sudo systemctl start teamserver.service"
		
	
	]
	
	
	 connection {
		host = var.C2_ip
            	user = "root"
            	type     = "ssh"
    		private_key = file(var.pvt_key)
           
         }
	
    }


 
}

# TEST IT
# nmap -Pn -sS -T4 -p 22,80,8080,445,443,4443,9050,2222 138.197.173.81 -vv


# ufw allow in on tun0 to any port 22
# ufw allow in on eth0 from 54.183.9.148,34.230.23.2  to any port 4443,9050,8080,80,2222
