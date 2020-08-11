locals {
  az_names  = data.aws_availability_zones.available.names
  az_length = length(local.az_names)
  # https://www.hashicorp.com/blog/terraform-0-12-conditional-operator-improvements/
  pub_sub_ids    = var.region == "ap-south-1" ? slice(aws_subnet.public.*.id, 0, 2) : aws_subnet.public.*.id
  pri_sub_ids    = aws_subnet.private.*.id
  pub_sub_length = length(local.pub_sub_ids)
}
