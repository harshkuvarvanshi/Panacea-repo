terraform {
  backend "s3" {}
}

resource "aws_cloudwatch_log_group" "ec2_logs" {
  name              = "ec2-logs"
  retention_in_days = 7
}



# # =========================================
# # CLOUDWATCH LOG GROUP
# # =========================================
# resource "aws_cloudwatch_log_group" "this" {
#   name              = var.log_group_name
#   retention_in_days = var.retention_days

#   tags = {
#     Name        = var.log_group_name
#     Environment = var.environment
#   }
# }

# # =========================================
# # SUBSCRIPTION FILTER (TO FIREHOSE)
# # =========================================
# resource "aws_cloudwatch_log_subscription_filter" "this" {
#   name            = "${var.log_group_name}-subscription"
#   log_group_name  = aws_cloudwatch_log_group.this.name
#   filter_pattern  = ""
#   destination_arn = var.firehose_arn

#   depends_on = [
#     aws_cloudwatch_log_group.this
#   ]
# }