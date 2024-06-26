# Existing Cluster with the AWS Observability accelerator EKS Infrastructure monitoring

This example demonstrates how to use the AWS Observability Accelerator Terraform
modules with Infrastructure monitoring enabled.
The current example deploys the [AWS Distro for OpenTelemetry Operator](https://docs.aws.amazon.com/eks/latest/userguide/opentelemetry.html)
for Amazon EKS with its requirements and make use of an existing Amazon Managed Grafana workspace.
It creates a new Amazon Managed Service for Prometheus workspace unless provided with an existing one to reuse.

It uses the `EKS monitoring` [module](../../modules/eks-monitoring/)
to provide an existing EKS cluster with an OpenTelemetry collector,
curated Grafana dashboards, Prometheus alerting and recording rules with multiple
configuration options on the cluster infrastructure.

View the full documentation for this example [here](https://aws-observability.github.io/terraform-aws-observability-accelerator/eks/)


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.4.1 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 2.0.3 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks_monitoring"></a> [eks\_monitoring](#module\_eks\_monitoring) | ../../modules/eks-monitoring | n/a |
| <a name="module_grafana_key_rotation"></a> [grafana\_key\_rotation](#module\_grafana\_key\_rotation) | ../../modules/grafana-key-rotation | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_grafana_workspace.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/grafana_workspace) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region | `string` | n/a | yes |
| <a name="input_eks_cluster_id"></a> [eks\_cluster\_id](#input\_eks\_cluster\_id) | Name of the EKS cluster | `string` | `"eks-cluster-with-vpc"` | no |
| <a name="input_enable_dashboards"></a> [enable\_dashboards](#input\_enable\_dashboards) | Enables or disables curated dashboards. Dashboards are managed by the Grafana Operator | `bool` | `true` | no |
| <a name="input_enable_grafana_key_rotation"></a> [enable\_grafana\_key\_rotation](#input\_enable\_grafana\_key\_rotation) | Enables or disables Grafana API key rotation | `bool` | `true` | no |
| <a name="input_eventbridge_scheduler_schedule_expression"></a> [eventbridge\_scheduler\_schedule\_expression](#input\_eventbridge\_scheduler\_schedule\_expression) | Schedule Expression for EventBridge Scheduler in Grafana API Key Rotation | `string` | `"rate(60 minutes)"` | no |
| <a name="input_grafana_api_key"></a> [grafana\_api\_key](#input\_grafana\_api\_key) | API key for authorizing the Grafana provider to make changes to Amazon Managed Grafana | `string` | n/a | yes |
| <a name="input_grafana_api_key_interval"></a> [grafana\_api\_key\_interval](#input\_grafana\_api\_key\_interval) | Number of seconds for secondsToLive value while creating API Key | `number` | `5400` | no |
| <a name="input_grafana_api_key_refresh_interval"></a> [grafana\_api\_key\_refresh\_interval](#input\_grafana\_api\_key\_refresh\_interval) | Refresh Internal to be used by External Secrets for Grafana API Key rotation | `string` | `"5m"` | no |
| <a name="input_lambda_runtime_grafana_key_rotation"></a> [lambda\_runtime\_grafana\_key\_rotation](#input\_lambda\_runtime\_grafana\_key\_rotation) | Python Runtime Identifier for the Lambda Function | `string` | `"python3.12"` | no |
| <a name="input_managed_grafana_workspace_id"></a> [managed\_grafana\_workspace\_id](#input\_managed\_grafana\_workspace\_id) | Amazon Managed Grafana Workspace ID | `string` | n/a | yes |
| <a name="input_managed_prometheus_workspace_id"></a> [managed\_prometheus\_workspace\_id](#input\_managed\_prometheus\_workspace\_id) | Amazon Managed Service for Prometheus Workspace ID | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_id"></a> [eks\_cluster\_id](#output\_eks\_cluster\_id) | EKS Cluster Id |
| <a name="output_eks_cluster_version"></a> [eks\_cluster\_version](#output\_eks\_cluster\_version) | EKS Cluster version |
| <a name="output_grafana_key_rotation_eventbridge_scheduler_arn"></a> [grafana\_key\_rotation\_eventbridge\_scheduler\_arn](#output\_grafana\_key\_rotation\_eventbridge\_scheduler\_arn) | ARN of the EventBridge Scheduler invoking Lambda Function for Key rotation |
| <a name="output_grafana_key_rotation_eventbridge_scheduler_role_arn"></a> [grafana\_key\_rotation\_eventbridge\_scheduler\_role\_arn](#output\_grafana\_key\_rotation\_eventbridge\_scheduler\_role\_arn) | ARN of the IAM Role of EventBridge Scheduler invoking Lambda Function for Key rotation |
| <a name="output_grafana_key_rotation_lambda_function_arn"></a> [grafana\_key\_rotation\_lambda\_function\_arn](#output\_grafana\_key\_rotation\_lambda\_function\_arn) | ARN of the Lambda function performing Key rotation |
| <a name="output_grafana_key_rotation_lambda_function_role_arn"></a> [grafana\_key\_rotation\_lambda\_function\_role\_arn](#output\_grafana\_key\_rotation\_lambda\_function\_role\_arn) | ARN of the Lambda function execution role |
| <a name="output_managed_prometheus_workspace_endpoint"></a> [managed\_prometheus\_workspace\_endpoint](#output\_managed\_prometheus\_workspace\_endpoint) | Amazon Managed Prometheus workspace endpoint |
| <a name="output_managed_prometheus_workspace_id"></a> [managed\_prometheus\_workspace\_id](#output\_managed\_prometheus\_workspace\_id) | Amazon Managed Prometheus workspace ID |
| <a name="output_managed_prometheus_workspace_region"></a> [managed\_prometheus\_workspace\_region](#output\_managed\_prometheus\_workspace\_region) | AWS Region |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
