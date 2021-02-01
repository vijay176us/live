terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "terraform-up-and-running-state-vk-stage"
    key            = "stage/data-stores/mysql/terraform.tfstate"
    region         = "us-east-2"
    # # Replace this with your DynamoDB table name!
    # dynamodb_table = "terraform-up-and-running-locks"
    # encrypt        = true
  }
}

provider "aws" {
  region = "us-east-2"
}
resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-up-and-running"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  name                = "example_database"
  username            = var.db_username
  password            = var.db_password
  tags = {
    Department = "IT"
  }
}