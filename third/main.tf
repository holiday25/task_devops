# Указываем провайдера AWS
provider "aws" {
  region = "us-west-2"
  profile = "default"
}

# Создаем новую VPC для кластера EKS
resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Создаем подсети внутри VPC для размещения рабочих узлов EKS
resource "aws_subnet" "eks_subnet_a" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "eks_subnet_b" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"
}

# Создаем IAM роль для управления кластером EKS
resource "aws_iam_role" "eks_cluster_role" {
  name               = "eks-cluster-role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "eks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })

  # Прикрепляем политику с разрешениями к роли
  inline_policy {
    name = "eks-cluster-policy"
    policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "ec2:CreateVpc",
            "ec2:DeleteVpc",
            "ec2:DescribeVpcAttribute",
            "ec2:ModifyVpcAttribute",
            "ec2:CreateSubnet",
            "ec2:DeleteSubnet",
            "ec2:CreateSecurityGroup",
            "ec2:DescribeSecurityGroupRules",
            "ec2:ModifySubnetAttribute",
            "ec2:CreateSecurityGroup",
            "ec2:DeleteSecurityGroup",
            "ec2:RevokeSecurityGroupEgress",
            "ec2:AuthorizeSecurityGroupEgress",
            "ec2:CreateInternetGateway",
            "ec2:DeleteInternetGateway",
            "ec2:AttachInternetGateway",
            "eks:CreateCluster",
            "eks:DeleteCluster",
            "eks:DescribeCluster",
            "eks:CreateNodegroup",
            "eks:TagResource",
            "iam:PassRole",
            "ec2:CreateRoute"
          ],
          "Resource": [
            "arn:aws:ec2:us-west-2::vpc/*",
            "arn:aws:ec2:us-west-2::subnet/*",
            "arn:aws:ec2:us-west-2::security-group/*",
            "arn:aws:ec2:us-west-2::internet-gateway/*",
            "arn:aws:ecs:us-west-2::route-table/*",
            "arn:aws:eks:us-west-2::cluster/*",
            "arn:aws:iam::aws:425748291343:role/*"
          ]
        },
        {
          "Effect": "Allow",
          "Action": [
            "ec2:DescribeVpcs",
            "ec2:DescribeInternetGateways",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeSubnets",
            "ec2:DescribeNetworkInterfaces",
            "iam:GetRole",
            "ec2:CreateTags",
            "ec2:CreateRouteTable",
            "ec2:DeleteRouteTable",
            "ec2:DescribeRouteTables",
            "ec2:AssociateRouteTable"
          ],
          "Resource": [
            "*"
          ]
        }
      ]
    })
  }
}

# Создаем Amazon EKS кластер
resource "aws_eks_cluster" "my_cluster" {
  name     = "my-cluster"
  role_arn = "arn:aws:iam::425748291343:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS"

  vpc_config {
    subnet_ids = [
      aws_subnet.eks_subnet_a.id,
      aws_subnet.eks_subnet_b.id
    ]
  }
}

# Создаем группу узлов EKS
resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "example-node-group"
  node_role_arn   = "arn:aws:iam::425748291343:role/default-nodegroup"

  subnet_ids = [
    aws_subnet.eks_subnet_a.id,
    aws_subnet.eks_subnet_b.id
  ]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }
}

