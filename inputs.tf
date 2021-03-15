variable "vpc_endpoint_service_names" {
  description = "VPC interface endpoint services which should be used to order a colocated AZ list."
  type = list(string)
  default = ["_"]
}

# The default is impossibly high, rendering the full list of available AZs always lower, and thus used instead of the impossibly high default max value.
variable "az_count_max" {
  description = "Maximum amount of avilability zones to produce in output AZ list."
  type = number
  default = 100
}

variable "az_count_min" {
  description = "Minimum amount of availability zones to produce in output AZ list."
  type = number
  default = 0
}

variable "availability_zones" {
  description = "List of availability zones to choose from. Optional; calculated if value of [ '_', ] is provided."
  type = list(string)
  default = ["_"]
}
