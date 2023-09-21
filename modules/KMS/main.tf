#Create kms
resource "aws_kms_key" "ecs-kms-key" {
  description             = "${var.app_name}-eks__kms"
  deletion_window_in_days = 7
  is_enabled              = true
  #   enable_key_rotation=true
  tags = {
    Name = "${var.app_name}-kms_key"
  }
}

resource "aws_kms_alias" "ecs-kms-key-alias" {
  name          = "alias/${var.app_name}-ekskms"
  target_key_id = aws_kms_key.ecs-kms-key.key_id
}
