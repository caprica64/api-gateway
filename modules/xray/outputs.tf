# X-Ray module outputs

output "xray_enabled" {
  description = "Whether X-Ray tracing is enabled"
  value       = var.enable_xray_tracing
}

output "xray_role_arn" {
  description = "ARN of the X-Ray IAM role"
  value       = var.enable_xray_tracing ? aws_iam_role.xray_role[0].arn : null
}

output "xray_policy_arn" {
  description = "ARN of the X-Ray IAM policy"
  value       = var.enable_xray_tracing ? aws_iam_policy.xray_policy[0].arn : null
}

output "xray_log_group_name" {
  description = "Name of the X-Ray CloudWatch log group"
  value       = var.enable_xray_tracing ? aws_cloudwatch_log_group.xray_log_group[0].name : null
}

output "xray_sampling_rule_name" {
  description = "Name of the X-Ray sampling rule"
  value       = var.enable_xray_tracing ? aws_xray_sampling_rule.api_sampling_rule[0].rule_name : null
}