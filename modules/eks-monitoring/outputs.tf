output "eks_cluster_version" {
  description = "EKS Cluster version"
  value       = data.aws_eks_cluster.eks_cluster.version
}

output "eks_cluster_id" {
  description = "EKS Cluster Id"
  value       = var.eks_cluster_id
}

output "adot_irsa_arn" {
  description = "IRSA Arn for ADOT"
  value       = module.helm_addon.irsa_arn
}

output "ssmparameter_name" {
  description = "Name of the SSM Parameter"
  value       = module.external_secrets[0].ssmparameter_name
}

output "ssmparameter_arn" {
  description = "Name of the SSM Parameter"
  value       = module.external_secrets[0].ssmparameter_arn
}

output "kms_key_arn" {
  description = "Name of the SSM Parameter"
  value       = module.external_secrets[0].kms_key_arn_ssm
}

output "managed_prometheus_workspace_endpoint" {
  description = "Amazon Managed Prometheus workspace endpoint"
  value       = local.managed_prometheus_workspace_endpoint
}

output "managed_prometheus_workspace_id" {
  description = "Amazon Managed Prometheus workspace ID"
  value       = local.managed_prometheus_workspace_id
}

output "managed_prometheus_workspace_region" {
  description = "Amazon Managed Prometheus workspace region"
  value       = local.managed_prometheus_workspace_region
}
