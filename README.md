# terraform-aws-privatelink-az-colocation

Terraform data module that guarantees VPC fault domain colocation with a given VPC interface endpoint service.

Colocation "guarantees" are provided by an availability zone list which includes the AZs that the input VPC endpoint service uses as the first elements, with any remaining AZs included as later elements.

This list of AZs should then be used to create subnet allocations when defining a VPC. It is best used with the [VPC module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.33.0) and the "azs" input variable in that module.

- [terraform-aws-privatelink-az-colocation](#terraform-aws-privatelink-az-colocation)
  - [Resource Types](#resource-types)
  - [Features](#features)
  - [Usage](#usage)
  - [Inputs](#inputs)
  - [Outputs](#outputs)
  - [Contributing](#contributing)
  - [Change Log](#change-log)
  - [Authors](#authors)


## Resource Types

 * None


## Features:

This module aims to enable resilient inter-VPC communication when using VPC endpoints by providing guarantees that a VPC occupies the save AZs as a peer VPC endpoint service.

 - Automatic available AZ discovery with optional list override
 - Optional output list length limit


## Usage:

```hcl
provider "aws" {
  region = "us-east-1"
}

module "az_colocate" {
  source = "git@github.com:ClusterDaemon/terraform-aws-privatelink-az-colocation.git?ref=v3.0"

  vpc_endpoint_service_names = [ "com.amazonaws.vpce.us-east-1.vpce-svc-05b1514b390f69ca0", ]
}

output "azs" {
  value = module.az_colocate.availability_zones
}
```


## Providers

Name | Version
--- | ---
AWS | >= 2.41


## Inputs:

| Name | Description | Type | Default | Required |
| --- | --- | --- | --- | --- |
| vpc\_endpoint\_service\_names | List of VPC interface endpoint services which will be queried for AZs used. These AZs will appear as the earliest output elements of the "availability\_zones" output variable. | list(string) | nil | yes |
| az\_count\_max | Maximum amount of avilability zones to produce in output AZ list. This amount or the total amount of available fault domains will be produced, whichever is lower. Defaults to an impossibly high number. | number | 100 | no |
| az\_count\_min | Minimum amount of availability zones to produce in output AZ list. | number | 0 | no |
| availability\_zones | List of availability zones to choose from. Calculated if not provided. | list(string) | nil | no |


## Outputs:

| Name | Description | Type |
| --- | --- | --- |
| availability\_zones | Availability zone name list who's first elements overlap with those described by the input VPC endpoint services, with the remainding available AZs as later elements. There will be as many output elements as there are input availability zones, or the length of az\_count\_max -- whichever is lower. | list(string)
| vpc\_endpoint\_service\_availability\_zones | Availability zones used by the specified VPC endpoint services. | list(string) |
| vpc\_endpoint\_service\_attributes | Map of VPC endpoint service data objects, keyed by endpoint service name. See the related [data source documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint_service) for details regarding which object attributes are exported. | map(object(any)) |


## Contributing

Report issues/questions/feature requests on in the [issues](https://github.com/ClusterDaemon/terraform-aws-privatelink-az-colocation/issues/new) section.

Full contributing [guidelines are covered here](https://github.com/ClusterDaemon/terraform-aws-privatelink-az-colocation/blob/master/CONTRIBUTING.md).


## Change Log

The [changelog](https://github.com/ClusterDaemon/terraform-aws-privatelink-az-colocation/tree/master/CHANGELOG.md) captures all important release notes.


## Authors

Created and maintained by David Hay - david.hay@nebulate.tech
