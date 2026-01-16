


resource "null_resource" "C2_Sliver" {
  # Imposta dipendenza dall'istanza AWS

provisioner "remote-exec" {
	inline = [		
		"curl https://sliver.sh/install|sudo bash"
	]
	
	
	 connection {
		host = var.C2_ip
            	user = "root"
            	type     = "ssh"
    		private_key = file(var.pvt_key)
           
         }
	
    }


provisioner "local-exec" {
    command = "echo $(pwd) "
	
  }


provisioner "local-exec" {
    command = "sudo curl https://sliver.sh/install|sudo bash"
	
  }
  
  
  provisioner "local-exec" {
    command = "sudo scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${var.pvt_key} root@${var.C2_ip}:/root/.sliver-client/configs/root_localhost.cfg /root/.sliver-client/configs/root_localhost.cfg"
	
  }


provisioner "local-exec" {
    command = "sudo sed -i \"s/localhost/${var.C2_ip}/g\" /root/.sliver-client/configs/root_localhost.cfg"
	
  }
  
  
  provisioner "local-exec" {
    command = "sudo cp ./repo/Sliver/http-c2.json /root/.sliver/configs/http-c2.json "
	
  }
  
  
provisioner "file" {
        	source = "repo/Sliver/http-c2.json"
        	destination = "/root/.sliver/configs/http-c2.json"
		connection {
			host = var.C2_ip
            		type = "ssh"
            		user = "root"
            		private_key = file(var.pvt_key)
        	}
    	}



provisioner "remote-exec" {
	inline = [
		"sed -i \"s/MY-USER-AGENT/${var.useragent}/g\" /root/.sliver/configs/http-c2.json"
	
	]
	
	
	 connection {
		host = var.C2_ip
            	user = "root"
            	type     = "ssh"
    		private_key = file(var.pvt_key)
           
         }


  }
