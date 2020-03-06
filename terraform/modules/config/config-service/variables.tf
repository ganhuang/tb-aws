
variable "config_logs_bucket" {    
    default = ""
}

variable "config_logs_bucket_arn" { 
    default = ""
}

variable "config_name" {  
    default = ""
}

variable "config_tags" {
  default = {} 
}

variable "s3_log_prefix" { 
    default = ""
}

variable "sns_topic_arn" {
  description = "The ARN of topic."
}

variable "config_delivery_frequency" {
  description = "The frequency with which AWS Config delivers configuration snapshots."
  default     = "Six_Hours"
}

variable "topic_account_id" {
  description = "topic_account_id"
  default = ""
}
