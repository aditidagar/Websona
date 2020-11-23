provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "us-east-1"
}

data "aws_availability_zones" "all" {
}

resource "aws_s3_bucket" "websona-backend-s3bucket" {
  bucket = "websona-backend-s3bucket"
  acl    = "private"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "GET"]
    allowed_origins = ["*"]
    expose_headers  = []
    max_age_seconds = 3000
  }

  tags = {
    Name        = "Bucket for Websona API Server"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_object" "object" {
  bucket = "websona-backend-s3bucket"
  key    = ".env"
  source = "../backend/.env"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("../backend/.env")
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "thewebsonaapp.com"
  validation_method = "DNS"
  subject_alternative_names = [ "*.thewebsonaapp.com" ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  allow_overwrite = true
  name = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
  records = [ tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value ]
  type = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type
  zone_id = var.dns_zone_id
  ttl = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [ aws_route53_record.cert_validation.fqdn ]
}

resource "aws_launch_configuration" "instance_launch_config" {
  image_id        = "ami-0b69ea66ff7391e80"
  instance_type   = "t2.micro"
  security_groups = ["webson-api-server-network-rules"]
  depends_on      = [aws_security_group.webson-api-server-network-rules]

  user_data = <<-EOF
              #!/bin/bash
              mkdir /home/backend
              curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
              export NVM_DIR="$HOME/.nvm"
              [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
              nvm install 10.15.3
              cd /home/backend
              aws configure set aws_access_key_id "${var.access_key}"
              aws configure set aws_secret_access_key "${var.secret_key}"
              aws configure set default_region_name "us-east-1"
              sudo yum install git -y
              git clone https://${var.github_user}:${var.github_pass}@github.com/csc301-fall-2020/team-project-29-websona.git
              cd team-project-29-websona/backend
              aws s3 cp s3://websona-backend-s3bucket/.env ./.env
              npm i
              sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 3000
              npm start
EOF


  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "websona-autoscaler" {
  launch_configuration = aws_launch_configuration.instance_launch_config.id
  availability_zones   = data.aws_availability_zones.all.names
  depends_on           = [aws_lb.websona-alb]

  min_size = 1
  max_size = 3

  target_group_arns = [aws_lb_target_group.backend_target_group.arn]
  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "websona-backend"
    propagate_at_launch = true
  }
}

resource "aws_lb" "websona-alb" {
  name               = "websona-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.webson-api-server-network-rules.id]
  subnets         = data.aws_subnet_ids.all.ids

  tags = {
    Enviroment = "development"
  }
}

resource "aws_lb_target_group" "backend_target_group" {
  name     = "backend-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.default.id

  health_check {
    interval            = 10
    path                = "/"
    port                = 80
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-299"
  }
}

# HTTP listener to redirect clients to HTTPS
resource "aws_lb_listener" "request_listener" {
  load_balancer_arn = aws_lb.websona-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "request_listener_https" {
  load_balancer_arn = aws_lb.websona-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn = aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_target_group.arn
  }
}

resource "aws_security_group" "webson-api-server-network-rules" {
  name        = "webson-api-server-network-rules"
  description = "Websona API server network rules for development enviroment"
  vpc_id      = aws_default_vpc.default.id

  # to allow for ssh (ONLY FOR DEVELOPMENT ENVIROMENT, NEEDS TO BE REMOVED FOR PRODUCTION)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_route53_record" "api" {
  zone_id = var.dns_zone_id
  name = "api.thewebsonaapp.com"
  type = "A"

  alias {
    name = aws_lb.websona-alb.dns_name
    zone_id = aws_lb.websona-alb.zone_id
    evaluate_target_health = false
  }
}

data "aws_subnet_ids" "all" {
  vpc_id = aws_default_vpc.default.id
}

output "lb_address" {
  value = "${aws_lb.websona-alb.dns_name}"
}

output "dns_fqdn" {
  value = "${aws_route53_record.api.fqdn}"
}

