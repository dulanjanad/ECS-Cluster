cidr = "10.5.0.0/16"

vpc_name = "Demo"

aws_region = "eu-west-2"

environment = "dev"

app_name = "demo-app"

app_containerPort = 8080

db_name = "demo"

engine = "mysql"

engine_version = "8.0.27"

family = "mysql8.0" # DB parameter group

major_engine_version = "8.0" # DB option group

instance_class = "db.t2.small"

allocated_storage = 20

max_allocated_storage = 100

port = 3306

db_username = "rds_user"