#!/bin/bash
# test line   

# Variables
export AWS_ACCESS_KEY_ID=${access_key}
export AWS_SECRET_ACCESS_KEY=${secret_key}
export AWS_DEFAULT_REGION=${DEV_region}

# Paths
MAIN_PATH=$(pwd)
AUTOMATION_SCRIPTS="${MAIN_PATH}/automation/cicd"
TERRAFORM_PATH="${MAIN_PATH}/terraform"

# Files preparation
python3 automation/cicd/terraform-pre-run.py

cd ${TERRAFORM_PATH}
echo "------------------------TERRAFORM INIT--------------------------------------------"
terraform init
#cat main.tf
#echo "------------------------TERRAFORM IMPORT--------------------------------------------"
#terraform import module.aws_lz_organization_main.aws_organizations_organization.aws_lz_organization o-8lg1h3pzea
#terraform import module.aws_lz_account_security.aws_organizations_account.aws_lz_account 971696596064
#terraform import module.aws_lz_account_logarchive.aws_organizations_account.aws_lz_account 371811507364
terraform import module.aws_lz_account_sharedservices.aws_organizations_account.aws_lz_account 268856297607
cat main.tf
echo "------------------------TERRAFORM VALIDATE----------------------------------------"
terraform validate
#terraform refresh
#echo "--------------------------------------------------------------------"
echo "------------------------TERRAFORM PLAN--------------------------------------------"
terraform plan
echo "------------------------TERRAFORM APPLY--------------------------------------------"
terraform apply -refresh=true -auto-approve