
############################################################################
##### https://us-west-2.console.aws.amazon.com/ec2/v2/home?region=us-west-2#Home:


resource "aws_vpc" "default" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
provider = aws.region
}

resource "aws_subnet" "default" {
    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "10.0.0.0/24"
provider = aws.region
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
provider = aws.region
}

resource "aws_route_table" "default" {
    vpc_id = "${aws_vpc.default.id}"
provider = aws.region

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }
}

resource "aws_route_table_association" "default" {
provider = aws.region
    subnet_id = "${aws_subnet.default.id}"
    route_table_id = "${aws_route_table.default.id}"

}



################################################################################
################################################################################

