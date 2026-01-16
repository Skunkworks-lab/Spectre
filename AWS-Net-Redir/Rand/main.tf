resource "random_string" "random" {
  length  = 7 // Numero di caratteri della stringa
  lower   = true
  upper   = false
  numeric  = true
  special = false
}

output "random_lowercase_string" {
  value = random_string.random.result
}
