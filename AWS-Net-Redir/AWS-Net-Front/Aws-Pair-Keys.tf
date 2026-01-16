
/*
resource "aws_key_pair" "localkey" {
    key_name   = "lokalkey"
    public_key = "${var.local_key}"
}
*/
resource "aws_key_pair" "localkey" {
    key_name   = "key-pair-${var.key}-${formatdate("YYYYMMDDHHmmss", timestamp())}"
    public_key = "${var.local_key}"
provider = aws.region
}

