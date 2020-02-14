locals {
  common_tags = {
    ProjectID = var.awslz_proj_id
    Environment = var.awslz_environment
    AccountID = var.awslz_account_id
  }
}

variable "aws_default_region" {
  type        = string
  description = "Default region for the landing zone"
}

variable "aws_access_key_id" {
  type        = string
  description = "access key"
}

variable "aws_secret_access_key" {
  type        = string
  description = "access key"
}

variable "tag_key_project_id" {
  type = string
  default = "project_id"
}
variable "tag_key_environment" {
  type = string
  default = "environment"
}
variable "tag_key_account_id" {
  type = string
  default = "account_id"
}
variable "tag_key_name" {
  type = string
  default = "name"
}
variable "awslz_proj_id" {
  type = string
  default = "11111"
}
variable "awslz_environment" {
  type = string
  default = "DEV"
}
variable "awslz_account_id" {
  type = string
  default = "22222"
}


variable "aws_organizations_account_sharedservices_name" {
    description = "Shared Services details"
    default ="sharedservice"
}
variable "aws_organizations_account_sharedservices_email" {
    description = "Shared Services details"
    default = "sharedservice@nn.com"
}
variable "aws_organizations_account_logarchive_name" {
    description = "Log Archive accounts details"
    default = "logarchive"
}
variable "aws_organizations_account_logarchive_email" {
    description = "Log Archive accounts details"
    default = "logarchive@nn.com"
}

variable "org_tags" {
  default = {} 
}