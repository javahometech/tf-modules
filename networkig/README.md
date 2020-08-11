# AWS VPC/Networking module

This module create vpc with private and public subnets, NAT instance is used for privte subet internet connections

## Module Usage
```
module "dev" {
  source = "github.com/javahometech/tf-modules//networkig"
  vpc_cidr = "173.16.0.0/16"
}
```

## Module Arguments
* region  chose the region you want to create your stack, default is ``` ap-south-1 ```
* vpc_cidr cidr block for your vpc, default is ``` 10.0.0.0/16 ```
* vpc_tenancy, default is ```default```
* nat_amis
    ```
      default = {
        ap-south-1     = "ami-00b3aa8a93dd09c13"
        ap-southeast-2 = "ami-00c1445796bc0a29f"
      }
    ```
