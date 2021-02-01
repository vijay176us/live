module "webserver_cluster" {
#   source = "github.com/foo/modules//webserver-cluster?ref=v0.0.1"
#   source = "github.com/vijay176us/modules//services//webserver-cluster?ref=v0.0.1"

  source = "github.com/vijay176us/modules//services//webserver-cluster?ref=v0.0.2"
  cluster_name  = "webservers-stage"
  instance_type = "m4.large"
  min_size      = 2
  max_size      = 4
}