variable "access_key" {
}

variable "secret_key" {
}

variable "github_user" {
    type = string
    description = "Github Username"
}

variable "github_pass" {
    type = string
    description = "Github Password"
}

variable "dns_zone_id" {
  type = string
  description = "Zone ID for the Route53 hosted zone for DNS"
}

variable "cert" {
  type = string
  description = "SSL certificate for the API server"
}
