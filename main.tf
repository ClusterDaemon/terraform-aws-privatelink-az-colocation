terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      version = ">= 2.41"
    }
  }
}

data "aws_vpc_endpoint_service" "this" {
  count = length(var.vpc_endpoint_service_names)

  service_name = var.vpc_endpoint_service_names[count.index]
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {

  # Use input AZ list if exists. Otherwise, obtain from data source.
  availability_zones = tolist(var.availability_zones) == tolist([ "_", ]) ? data.aws_availability_zones.available.names : var.availability_zones

  endpoint_service_availability_zones = distinct(
    concat(
      [
        for service in data.aws_vpc_endpoint_service.this : service.availability_zones
      ]
    )...
  )

  # Produce availability zone list to first include AZs that overlap with desired VPC endpoint services.
  # Select requested amount of AZs from that re-arranged list, guaranteeing VPC endpoint connectivity.
  # If no minimum or maximum amount is requested, provide a full re-arranged list of availability zones for this region.
  colocated_availability_zones = [
    for az in range(
      # Amount of elements; more than the minimum, less than the max.
      max(
        min(
          length(local.availability_zones),
          var.az_count_max
        ),
        var.az_count_min
      )
    ) : element(
      concat(
        tolist(local.endpoint_service_availability_zones),
        tolist(setsubtract(
          local.availability_zones,
          local.endpoint_service_availability_zones,
        ))
      ),
      az
    )
  ]

}


