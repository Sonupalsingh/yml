# Set up the provider for AWS
provider "aws" {
  region = "us-east-1" # specify the region where you want to create the VPC and subnets
}

# Data source to pull all available availability zones (AZs) in the specified region
data "aws_availability_zones" "available" {}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

# Create subnets in all AZs of the selected region
resource "aws_subnet" "subnet" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-${count.index + 1}"
  }
}

# Output the subnet IDs and their respective availability zones
output "subnets" {
  value = {
    for idx, subnet in aws_subnet.subnet : subnet.id => {
      az = subnet.availability_zone
      cidr = subnet.cidr_block
    }
  }
}