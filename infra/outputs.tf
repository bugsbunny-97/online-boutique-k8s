output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "region" {
  value = var.region
}

output "availability_zones" {
  value = data.aws_availability_zones.available.names
}
