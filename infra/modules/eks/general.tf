locals {
  common_tags = {
    env = "${var.APP_NAME}_${var.APP_ENVIRONMENT}_eks"
  }
}