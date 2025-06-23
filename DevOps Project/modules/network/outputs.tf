output "vpc_id" {
  value = aws_vpc.main.id
}

output "pub_subnets" {
  value = aws_subnet.public.*.id
}

output "pri_subnets" {
  value = aws_subnet.private.*.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.main.*.name
}