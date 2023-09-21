
#Create an aws ecr
resource "aws_ecr_repository" "aws_ecr" {
  name                 = "${var.app_name}-ecr"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = "${var.app_name}-ecr"
  }
}
