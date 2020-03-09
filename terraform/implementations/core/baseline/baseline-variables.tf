
variable "config_name" {  
    default = "aws_lz_config"
    description = "Config Service name"
}

variable "cloudtrail_name" {
  default = "aws_lz_cloudtrail"
  description = "Config Service name"
}

variable "local_topic_name" {
  default = "aws_lz_local_sns_topic"
  description = "Name of topic for Config service"
}