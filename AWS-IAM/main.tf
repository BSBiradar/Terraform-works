terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.60.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

locals {
  users_data = yamldecode(file("./users.yaml")).users

  user_role_pair = flatten([for user in local.users_data : [for role in user.roles : {
    username = user.username
    role     = role
  }]])
}

output "output" {
  value = local.user_role_pair
}


resource "aws_iam_user" "cli_users" {
    for_each = toset(local.users_data[*].username)
    name = each.value

}


resource "aws_iam_user_policy_attachment" "main" {
  for_each = {
    for pair in local.user_role_pair :
    "${pair.username}-${pair.role}" => pair
  }

  user       = aws_iam_user.cli_users[each.value.username].name
  policy_arn = "arn:aws:iam::aws:policy/${each.value.role}"
}



