# This data source is included for ease of sample architecture deployment
# and can be swapped out as necessary.
data "aws_availability_zones" "available" {}

resource "aws_vpc" "eks_jk" {
  cidr_block = "10.0.0.0/16"

  tags = "${
    map(
     "Name", "terraform-eks-jk",
     "kubernetes.io/cluster/${var.cluster_name}", "shared"
    )
  }"
}

resource "aws_subnet" "eks_jk_subnet" {
  count = 2

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = "${aws_vpc.eks_jk.id}"

  tags = "${
    map(
     "Name", "terraform-eks-jk",
     "kubernetes.io/cluster/${var.cluster_name}", "shared"
    )
  }"
}

resource "aws_internet_gateway" "eks_jk" {
  vpc_id = "${aws_vpc.eks_jk.id}"

  tags {
    Name = "terraform-eks-jk"
  }
}

resource "aws_route_table" "eks_jk" {
  vpc_id = "${aws_vpc.eks_jk.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.eks_jk.id}"
  }

  tags {
    Name = "terraform-eks-jk"
  }
}

resource "aws_route_table_association" "eks_jk" {
  count = 2

  subnet_id      = "${aws_subnet.eks_jk_subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.eks_jk.id}"
}