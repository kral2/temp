// Copyright (c) 2018, 2021, Oracle and/or its affiliates.

variable "tenancy_ocid" {}
variable "region" {}

terraform {
  required_version = ">= 0.12, < 0.13" // this example is intended to run with Terraform v0.12
  }

/*
* This example shows how to create a compartement and two sub-compartemnt.
*
* This example also shows how to create:
* - several users with a single module block,
* - a group and add group members to it,
* - a policy pertaining to a compartment and group,
* - some more directives to show dynamic groups and policy for it.
*
* Note: The compartment resource internally resolves name collisions and returns a reference to the preexisting compartment.
* All resources created by this example can be deleted by using the Terraform destroy command.
 */

module "iam_users" {
  source       = "oracle-terraform-modules/iam/oci//modules/iam-user"
  version      = "2.0.0"
  tenancy_ocid = var.tenancy_ocid
  users = [
    { # user1
      name        = "tf_example_user1@example.com"
      description = "user1 created by terraform"
      email       = null
    },
    { # user2
      name        = "tf_example_user2@example.com"
      description = "user2 created by terraform"
      email       = "tf_example_user2@example.com"
    },
    { # user3
      name        = "tf_example_user3@example.com"
      description = "user3 created by terraform"
      email       = "tf_example_user3@example.com"
    }, # add more users below if needed
  ]
}

module "iam_group" {
  source                = "oracle-terraform-modules/iam/oci//modules/iam-group"
  version               = "2.0.0"
  tenancy_ocid          = var.tenancy_ocid
  group_name            = "tf_example_group"
  group_description     = "an example group - terraformed"
  user_ids              = [element(module.iam_users.user_id, 0), element(module.iam_users.user_id, 1), element(module.iam_users.user_id, 2)] # a list of user ocids
  policy_name           = "tf-example-policy"
  policy_compartment_id = var.tenancy_ocid
  policy_description    = "policy created by terraform aaaaaaaaaah"
  policy_statements = [
    "Allow group ${module.iam_group.group_name} to read instances in compartment tf_example_compartment",
    "Allow group ${module.iam_group.group_name} to inspect instances in compartment tf_example_compartment",
  ]
}
