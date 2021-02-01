#https://www.youtube.com/watch?v=q3bdXrHb6WM

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
    key            = "stage/services/frontend-app/terraform.tfstate"
    region         = "us-east-2"
    
    # # Replace this with your DynamoDB table name!
    # dynamodb_table = "terraform-up-and-running-locks"
    # encrypt        = true
  }
}

## Getting output data from stage/data-stores/mysql/terraform.tfstate file ..
# data "terraform_remote_state" "db" {
#   backend = "s3"
#   config = {
#     # Replace this with your bucket name!
#     bucket = "terraform-up-and-running-state-vk-stage"
#     key    = "stage/data-stores/mysql/terraform.tfstate"
#     region = "us-east-2"
#   }
# }

# # The default provider configuration; resources that begin with `aws_` will use
# # it as the default, and it can be referenced as `aws`.
# provider "aws" {
#   region = "us-east-1"
# }

# # Additional provider configuration for west coast region; resources can
# # reference this as `aws.west`.
# provider "aws" {
#   alias  = "west"
#   region = "us-west-2"
# }

# resource "aws_instance" "foo" {
#   provider = aws.west

#   # ...
# }

provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-up-and-running-state-vk-stage"
  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }
  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = {
    "Department" = "IT"
  }
}

resource "aws_instance" "example" {
  for_each = toset(var.instances)
  ami                    = "ami-0c55b159cbfafe1f0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name = "rk-aws-keypair"
  # counts = [for count in var.subnets : count]
  #subnet_id = element(var.subnets, each.value.index)  ## Create VM in each subnets (if count > 1)
  subnet_id = each.key
  # user_data = <<-EOF
  #             #!/bin/bash
  #             echo "Hello, World" > index.html
  #             nohup busybox httpd -f -p 8080 &
  #             EOF
  user_data = <<EOF
              #!/bin/bash
              db_address="${data.terraform_remote_state.db.outputs.address}"
              db_port="${data.terraform_remote_state.db.outputs.port}"
              echo "Hello, World. DB is at $db_address:$db_port" >> index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
  tags = {
    # Name = "terraform-example"
    # Name  = "Terraform-${instance_count.index + 1}"
    #"value" = [for name in var.instances : upper(name)]
    "name2" = "${var.env}.${var.product}-${each.key}"
    "Department" = "IT"

  }
  lifecycle {
    create_before_destroy = true
  }
}

# resource "aws_instance" "example" {
#   count =  var.instance_count
#   ami                    = "ami-0c55b159cbfafe1f0"
#   instance_type          = "t2.micro"
#   vpc_security_group_ids = [aws_security_group.instance.id]
#   key_name = "rk-aws-keypair"
#   subnet_id = element(var.subnets, count.index)  ## Create VM in each subnets (if count > 1)
#   # user_data = <<-EOF
#   #             #!/bin/bash
#   #             echo "Hello, World" > index.html
#   #             nohup busybox httpd -f -p 8080 &
#   #             EOF
#   user_data = <<EOF
#   #!/bin/bash
#   db_address="${data.terraform_remote_state.db.outputs.address}"
#   db_port="${data.terraform_remote_state.db.outputs.port}"
#   echo "Hello, World. DB is at $db_address:$db_port" >> index.html
#   nohup busybox httpd -f -p "${var.server_port}" &
#   EOF
#   tags = {
#     # Name = "terraform-example"
#     Name  = "Terraform-${count.index + 1}"
#     name2 = "${var.env}.${var.product}-${count.index + 1}"
#     "Department" = "IT"

#   }
#   lifecycle {
#     create_before_destroy = true
#   }
# }

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  tags = {
    Department = "IT"
  }
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# resource "aws_instance" "example-vk" {
#   ami           = "ami-0c55b159cbfafe1f0"
#   instance_type = "t2.micro"
# }


# output "dynamodb_table_name" {
#   value       = aws_dynamodb_table.terraform_locks.name
#   description = "The name of the DynamoDB table"
# }