#!/bin/bash
# test line

# Variables
export TF_VAR_aws_default_region=${DEV_region}
export TF_VAR_aws_access_key_id=${access_key}
export TF_VAR_aws_secret_access_key=${secret_key}

# Paths
MAIN_PATH=$(pwd)
AUTOMATION_SCRIPTS="${MAIN_PATH}/automation/cicd"
TERRAFORM_PATH="${MAIN_PATH}/terraform"

# Files preparation
python3 automation/cicd/terraform-pre-run.py


cd ${TERRAFORM_PATH}
terraform init

terraform validate
#terraform refresh
#terraform plan