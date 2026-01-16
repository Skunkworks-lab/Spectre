
/*
resource "aws_key_pair" "localkey" {
    key_name   = "lokalkey"
    public_key = "${var.local_key}"
}


resource "random_string" "random" {
  length  = 5 # Lunghezza della stringa
  special = false
  upper   = false
  number  = false
}

output "random_string_output" {
  value = random_string.random.result
}

*/

resource "aws_key_pair" "localkey" {
    key_name   = "key-pair-${formatdate("YYYYMMDDHHmmss", timestamp())}"
    public_key = "${var.local_key}"
provider = aws.region
}

