// Copyright (c) 2018, 2021, Oracle and/or its affiliates.

output "iam_users" {
  description = "list of username and associated ocid"
  value       = module.iam_users.name_ocid
}

output "iam_group" {
  description = "group name and associated ocid"
  value       = module.iam_group.name_ocid
}
