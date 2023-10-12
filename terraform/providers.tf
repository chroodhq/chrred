terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.21.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4.0"
    }
  }

  backend "s3" {
    region  = "eu-central-1"
    encrypt = true
  }

  required_version = "~> 1.6.0"
}


# -----------------------------------------------------------------------------
# PROVIDERS TO USE FOR DIFFERENT AWS REGIONS
# -----------------------------------------------------------------------------

provider "aws" {
  region = local.aws_regions.frankfurt
  default_tags {
    tags = local.common_tags
  }
  allowed_account_ids = [var.allowed_account_id]
}

provider "aws" {
  alias  = "ireland"
  region = local.aws_regions.ireland
  default_tags {
    tags = local.common_tags
  }
  allowed_account_ids = [var.allowed_account_id]
}

provider "aws" {
  alias  = "virginia"
  region = local.aws_regions.virginia
  default_tags {
    tags = local.common_tags
  }
  allowed_account_ids = [var.allowed_account_id]
}
