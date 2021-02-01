terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "terraform-up-and-running-state-vk-stage"
    # key            = "global/s3/terraform.tfstate"
    key            = "stage/services/webserver-cluster/terraform.tfstate"
    region         = "us-east-2"
    
    # # Replace this with your DynamoDB table name!
    # dynamodb_table = "terraform-up-and-running-locks"
    # encrypt        = true
  }
}

# For private git repo  ----  > source = "git::git@github.com:<OWNER>/<REPO>.git//<PATH>?ref=<VERSION>"
# For example:
# source = "git::git@github.com:gruntwork-io/terraform-google-gke.git//modules/gke-cluster?ref=v0.1.2"

module "webserver_cluster" {
#   source = "github.com/foo/modules//webserver-cluster?ref=v0.0.1"
#   source = "github.com/vijay176us/modules//services//webserver-cluster?ref=v0.0.1"

  source = "github.com/vijay176us/modules//services//webserver-cluster?ref=v0.0.3"
  cluster_name  = "webservers-stage"
  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 3
  custom_tags   = {"Name":"", "Department":"HR", "Env":"Stage", "CC":1023}
}

