data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
}

data "aws_subnet" "subnet" {
  for_each   = toset(data.aws_subnets.subnets.ids)
  id         = each.value
}

/*data "aws_subnet" "subnet" {
  for_each = data.aws_subnets.subnet-id-list.ids
  id       = each.value
}*/


module "ec2_instance" {
  depends_on = [
    aws_key_pair.test
  ]
  source     = "terraform-aws-modules/ec2-instance/aws"
  version    = "~> 3.0"

  for_each = data.aws_subnet.subnet

  ami           = "ami-0022f774911c1d690"
  instance_type = "t2.micro"
  key_name      = "test"
  monitoring    = true
  //vpc_security_group_ids = ["sg-12345678"]
  subnet_id              = each.value.id
  vpc_security_group_ids = [aws_security_group.ssh-access.id]
  tags = {
    "Name" = replace(each.value.tags["Name"], module.vpc.name, "ec2")
  }
}

resource "aws_security_group" "ssh-access" {
  name   = "ssh-access"
  vpc_id = module.vpc.vpc_id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }
  /*ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 80
    to_port   = 81
    protocol  = "tcp"
  }

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
  }*/

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*resource "aws_security_group" "web-access" {
  name = "web-access"
  vpc_id = module.vpc.vpc_id
  ingress = [ {
    cidr_blocks = [ ".0.0.0.0/0" ]
    from_port = 80
    protocol = "tcp"
    to_port = 80
  } ]

  egress = 
}

resource "aws_security_group" "s3-access" {
  
}

resource "aws_security_group" "cw-logs-access" {
  
}

resource "aws_security_group" "sts-access" {
  
}

resource "aws_security_group" "ec2-access" {
  
}

resource "aws_security_group" "ecr-api-access" {
  
}

resource "aws_security_group" "ecr-docker-acccess" {
  
}*/

//map_public_ip_on_launch
