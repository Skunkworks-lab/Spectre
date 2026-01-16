


resource "aws_cloudfront_distribution" "example_distribution" {
count = var.execution == true ? 1 : 0
provider = aws.region

  origin {
    domain_name =  "${var.dns_subname_aws}.${var.dns_name_aws}" # Il tuo server HTTP/HTTPS
    origin_id   = "custom-example-com"
    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "match-viewer"
      origin_ssl_protocols = ["TLSv1"]
    }
  }
  http_version        = "http1.1"
  enabled             = true
  # default_root_object = "/"
/*

Accept-Charset

Authorization

Origin

Accept

Referer

User-Agent

Accept-Language

Accept-Encoding

Accept-Datetime

564b40e5-4e1d-4fef-aed8-57954d11abfe

*/

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id =  "custom-example-com"
    compress         = false

    forwarded_values {
      query_string = true
      headers      = ["Accept-Charset","Authorization","Origin","Accept","Referer","User-Agent","Accept-Language","Accept-Encoding","Accept-Datetime"]

      cookies {
        forward = "all"
      }
    }


    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

    restrictions {
      geo_restriction {
        restriction_type = "none"
    locations = []
      }
    }

  tags = {
    Environment = "Production"
    Owner        = "RedTeam"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}


output "disturl" {
  value = aws_cloudfront_distribution.example_distribution[*].domain_name
}











