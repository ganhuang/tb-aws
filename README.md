# AWS Landing Zone - Tranquility Base
  
## Overview      
 
## Folder Structure
```  
├── terraform               
│   ├── main.tf                             [RO File Autogenerated] Entry point for Terraform
│   ├── variables.tf                        [RO File Autogenerated] Variables in TF
│   ├── output.tf                           [RO File Autogenerated] Outputs in TF
│   ├── implementations             
|   |    ├── imports.txt                    Reference of all files to be merged.
│   |    └── core
│   |         ├── security                  Directory will security elements 
│   |         |    └── security-*-.tf       
│   |         ├── logarchive                Directory will logarchive elements 
│   |         |    └── logarchive-*-.tf       
│   |         ├── sharedservices            Directory will sharedservices elements 
│   |         |    └── sharedservices-*-.tf       
│   |         ├── network                   Directory will network elements 
│   |         |    └── network-*-.tf       
│   |         ├── *-template.tf            Files to be used as modules instanciations 
│   |         ├── *-variables.tf           Files to be used as modules variables
│   |         └── *-outputs.tf             Files to be used as modules outputs
│   └── modules                            Module dirctory where you can have modules and submodules
│       ├── organizations
│       ├── common                         Services modules use by other services
│       │    ├── s3
│       │    └── iam
│       ├── config
│       └── guard-duty
├── automation
│    ├── cicd                                (CI/CD scripts)
│    │   ├── terraform-pre-run.py       
│    │   ├── prepare.sh
│    │   └── provision.sh      
│    ├── credentials                         (Credentials generated and used by scripts)
│    └── deploy                              (Deployment scripts)
└── config
     └── main.config.yml                    Main configuration
```

## Local / Remote Execution sequence steps

1 - Export your environment variables to be used by terraform
``` sh
export AWS_ACCESS_KEY_ID=[your access ID ]
export AWS_SECRET_ACCESS_KEY=[your secret key]
```

2- Execute pre run in which all files are going to be merged
``` sh
python3 automation/cicd/terrraform-pre-run.py
```

3- Execute terraform initialization command
``` sh
terraform init ./terraform
```

4- Execute terraform plan command
``` sh
terraform plan ./terraform
```

5- Execute terraform plan command
``` sh
terraform apply ./terraform
```
## Coding standards and naming conventions

* Read carefully names used in AWS LZ and try to follow the same convention. 
* Modules has to represent a module in our application. 
* Modules promotes reusability and are part of building pattern if you think that your module cannot be part of a module or your module will not be generic enough please discuss first doing any implementation of it.
* Modules with submodules is allowed but make sure if that module has to be tied with main module and not be part of more generic / common service if more than one module use it.
* Each template must have a header with a reference of what is instantiating in that block of code and it dependencies.
* Inner modules variables generic because can be used in differents intantiations
* Outter variables uses by templates must to be very specific to make reference to what is being store on them.
* Module required variables must match with Provider API values not provided can be default.
* All resources in which provider accept tags must follow our tagging convention 
* Naming for resouces in modules are the following
    ``` 
    aws_lz_[module]
    aws_lz_[sub-element]
    aws_lz_[sub-element]_[custom implementation]
    ```
* Naming for module instance is more specific to give context of it using 
    ```
        module "aws_lz_organizations_ou_core" {
    ```
* Tags conventions must to be provided in all AWS element that support them. 
    * **ProjectID**    Project ID
    * **Environment**  Environment in which that componets was created
    * **AccountID**    Account ID
    * **Key Name**     Key name to identify that item in the cloud 

    _Make sure to respect names and case_    

     


## Module Reference
| Module         | Completeness  | Documentation  |
| ----------------- |:-------------:| -----:|
| organizations     | WIP            |[README](/terraform/modules/organization/README.md)|
| config            | WIP            |[README](/terraform/modules/confg/README.md) |
| security          | WIP            |[README](/terraform/modules/security/README.md) |
| shared-services   | NO            |[README](/terraform/modules/sharedservices/README.md) |
| common            | NO            |[README](/terraform/modules/common/README.md) |


## Module dependencies 
| Module    			| common  		| shared-services  	| organizations | security 		| config 		|
| --------------------- |:-------------:| :-------------: 	|:-------------:| :------------:| -------------:|
|common					|     			|       			|       		|       		|  	     		|
|shared-services		|     			| 	     			|       		|       		|  	     		|
|security				|     			|  	     			|       		|       		|  	     		|
|organizations			|     			|  	     			|       		|       		|  	     		|
|config					|     			|       			|       		|       		|  	     		|
