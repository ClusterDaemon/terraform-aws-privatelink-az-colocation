output "availability_zones" {
  description = "Availability zone name list who's first elements overlap with those described by the input VPC endpoint service, with the remainding available AZs as later elements. There will be as many elements as there are availability zones, or the length of az_count_max -- whichever is lower."
  value = local.colocated_availability_zones
}

output "vpc_endpoint_service_availability_zones" {
  description = "Availability zone names used by the specified VPC endpoint service."
  value = local.endpoint_service_availability_zones
}

output "vpc_endpoint_service_attributes" {
  description = "Map of VPC endpoint service data objects, keyed by endpoint service name."
  value = {
    for endpoint in data.aws_vpc_endpoint_service.this : endpoint.service_name => endpoint
  }
}
