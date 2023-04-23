variable "stack_name" {
  type        = string
  description = "The deployment name of this stack"
}

variable "environment" {
  type        = string
  description = "The environment of this stack"
  default     = "local"
}

variable "aws_regions" {
  type    = map(string)
  default = {}
}

variable "common_tags" {
  type        = map(string)
  description = "Common Aws resource tags"
  default     = {}
}

variable "source_repository_url" {
  type        = string
  description = "The URL of this code repository"
}

variable "allowed_account_id" {
  type        = string
  description = "The AWS account ID"
}

variable "root_domain" {
  type        = string
  description = "The root domain name"
  default     = "chr.red"
}


# -----------------------------------------------------------------------------
# LOCAL VARIABLES
# -----------------------------------------------------------------------------

locals {
  resource_prefix = "${var.stack_name}-${var.environment}"
  common_tags = merge(var.common_tags, {
    managed_by        = "Terraform"
    environment       = var.environment
    deployment        = var.stack_name
    source_repository = var.source_repository_url
  })
  aws_regions = merge(var.aws_regions, {
    frankfurt = "eu-central-1"
    ireland   = "eu-west-1"
    virginia  = "us-east-1"
  })
  domain = var.environment == "live" ? var.root_domain : "${var.environment}.${var.root_domain}"
}
