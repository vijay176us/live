terraform {
  # This module is now only being tested with Terraform 0.13.x. However, to make upgrading easier, we are setting
  # 0.12.26 as the minimum version, as that version added support for required_providers with source URLs, making it
  # forwards compatible with 0.13.x code.
  required_version = ">= 0.12.26"
}

provider "aws" {
  region = "us-east-2"
}
module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"
  cluster_name = "webservers-prod"
  instance_type = "t2.micro" #"m4.large"
  min_size      = 2
  max_size      = 10
}

# You can access module output variables the same way as resource output attributes. The syntax is:
# module.<MODULE_NAME>.<OUTPUT_NAME>

resource "aws_autoscaling_schedule" "scale_out_business_hours" {
  scheduled_action_name = "scale-out-during-business-hours"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 10
  recurrence            = "0 9 * * *"
  autoscaling_group_name = module.webserver_cluster.asg_name
}
resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name = "scale-in-at-night"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 2
  recurrence            = "0 17 * * *"
  autoscaling_group_name = module.webserver_cluster.asg_name
}

