


resource "null_resource" "firewall_all" {
  # Imposta dipendenza dall'istanza AWS


  provisioner "local-exec" {

      command = <<-EOT
      ssh root@${var.ip_transport}  -i '${var.pvt_key}' -o UserKnownHostsFile=/dev/null -o "StrictHostKeyChecking no" 'ufw allow in on tun0 to any port 22'
      ssh root@${var.ip_transport}  -i '${var.pvt_key}' -o UserKnownHostsFile=/dev/null -o "StrictHostKeyChecking no" 'ufw allow in on eth0 from ${var.ip_aws_net} proto tcp to any port 4443,443,80,8080,8081,9050' 
      ssh root@${var.ip_transport}  -i '${var.pvt_key}' -o UserKnownHostsFile=/dev/null -o "StrictHostKeyChecking no" 'ufw allow in on eth0 from ${var.ip_aws_net} proto udp to any port 53'
      ssh root@${var.ip_transport}  -i '${var.pvt_key}' -o UserKnownHostsFile=/dev/null -o "StrictHostKeyChecking no" 'ufw allow in on eth0 from ${var.ip_aws_tor} proto tcp to any port 4443,443,80,8080,8081,9050'
      ssh root@${var.ip_transport}  -i '${var.pvt_key}' -o UserKnownHostsFile=/dev/null -o "StrictHostKeyChecking no" 'ufw allow in on eth0 from ${var.ip_aws_tor} proto udp to any port 53'
      ssh root@${var.ip_transport}  -i '${var.pvt_key}' -o UserKnownHostsFile=/dev/null -o "StrictHostKeyChecking no" 'ufw --force enable'
      ssh root@${var.ip_transport}  -i '${var.pvt_key}' -o UserKnownHostsFile=/dev/null -o "StrictHostKeyChecking no" 'ufw status verbose'
      ssh root@${var.ip_spectre} -i '${var.pvt_key}' -o UserKnownHostsFile=/dev/null -o "StrictHostKeyChecking no" 'ufw allow in on tun0 proto tcp to any port 22,50050'
      ssh root@${var.ip_spectre} -i '${var.pvt_key}' -o UserKnownHostsFile=/dev/null -o "StrictHostKeyChecking no" 'ufw allow in on eth0 to any port 22'
      ssh root@${var.ip_spectre} -i '${var.pvt_key}' -o UserKnownHostsFile=/dev/null -o "StrictHostKeyChecking no" 'ufw allow in on eth0 proto udp to any port 1194'
      ssh root@${var.ip_spectre} -i '${var.pvt_key}' -o UserKnownHostsFile=/dev/null -o "StrictHostKeyChecking no" 'ufw allow from 10.30.30.2'
      ssh root@${var.ip_spectre} -i '${var.pvt_key}' -o UserKnownHostsFile=/dev/null -o "StrictHostKeyChecking no" 'ufw allow from 10.30.30.3'
      ssh root@${var.ip_spectre} -i '${var.pvt_key}' -o UserKnownHostsFile=/dev/null -o "StrictHostKeyChecking no" 'ufw --force enable'
      ssh root@${var.ip_spectre}  -i '${var.pvt_key}' -o UserKnownHostsFile=/dev/null -o "StrictHostKeyChecking no" 'ufw status verbose'
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
 
}



