terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}


variable "cf_token" {
	description = "public"
	type        = string
 	default     = "95329516eda9463c8c5956315a4d9bb7b6fe8"
}



provider "cloudflare" {
    api_key = var.cf_token
    email   = "delaurentis@live.it"
}

