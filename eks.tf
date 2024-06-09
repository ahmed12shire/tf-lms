# Import existing IAM roles
data "aws_iam_role" "lms-cluster-role" {
  name = "lms-cluster-role" 
}

data "aws_iam_role" "lms-node-role" {
  name = "lms-node-role" 
}

# CREATING EKS CLUSTER
resource "aws_eks_cluster" "lms-cluster" {
  name     = "lms-cluster-production"
  role_arn = data.aws_iam_role.lms-cluster-role.arn

  vpc_config {
    subnet_ids = [aws_subnet.lms-projectb-pub-subnet.id]
  }
}

output "endpoint" {
  value = aws_eks_cluster.lms-cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.lms-cluster.certificate_authority[0].data
}

# CREATING NODE GROUP
resource "aws_eks_node_group" "lms-eks-nodegroup" {
  cluster_name    = aws_eks_cluster.lms-cluster.name
  node_group_name = "lms-eks-node-group"
  node_role_arn   = data.aws_iam_role.lms-node-role.arn
  subnet_ids      = aws_subnet.lms-projectb-pub-subnet[*].id

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }
}

# Define security group for EKS cluster
resource "aws_security_group" "eks-cluster-sg" {
  name        = "eks-cluster-security-group"
  description = "Security group for EKS cluster"
  vpc_id      = aws_vpc.lms-projectb-vpc.id

#   Adding inbound rule to allow traffic from IP address 3.96.170.219
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["3.96.170.219/32"]
  }

}