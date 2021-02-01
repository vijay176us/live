variable "env" {
  default = "dev"
}
variable "product" {
  default = "sales"
}

variable "instances" {
  type = list(string)
  default = ["VM1", "VM2", "VM3"]
}

# variable "instance_count" {
#   type = number
#   default = 3
# }

#"subnet-0ecbd174",
variable "subnets" {
  type = list
  default = ["subnet-e9973b82", "subnet-0ecbd174", "subnet-a30548ef"]
}



# type: This allows you enforce type constraints on the variables a user passes in. Terraform supports a number of type constraints, 
# including string, number, bool, list, map, set, object, tuple, and any. 
# If you don’t specify a type, Terraform assumes the type is any.

# This would prompt for entering a Port number you want to run your web server to...
variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
}


#   OR

# terraform apply -var "server_port=8080" 

#   OR 

# export TF_VAR_server_port=8080
# terraform apply

#   OR

# And if you don’t want to deal with remembering extra command-line arguments every time you run plan or apply, 
#you can specify a default value:
# variable "server_port" {
#   description = "The port the server will use for HTTP requests"
#   type        = number
#   default     = 8080
# }


# To use the value from an input variable in your Terraform code, you can use a new type of expression called a variable reference, 
# which has the following syntax:
# var.<VARIABLE_NAME>
# For example, here is how you can set the from_port and to_port parameters of the security group to the value of the server_port variable:
# resource "aws_security_group" "instance" {
#   name = "terraform-example-instance"
#   ingress {
#     from_port   = var.server_port
#     to_port     = var.server_port
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# # }


# It’s also a good idea to use the same variable when setting the port in the User Data script. To use a reference inside of a string literal,
# you need to use a new type of expression called an interpolation, which has the following syntax:
# "${...}"

# You can put any valid reference within the curly braces and Terraform will convert it to a string. For example, here’s how you can use var.server_port inside of the User Data string:
#   user_data = <<-EOF
#               #!/bin/bash
#               echo "Hello, World" > index.html
#               nohup busybox httpd -f -p "${var.server_port}" &
#               EOF