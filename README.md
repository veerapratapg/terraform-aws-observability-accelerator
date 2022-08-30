# AWS Observability Accelerator for Terraform

Welcome to AWS Observability Accelerator for Terraform!

The AWS Observability accelerator for Terraform is a set of modules to help you configure Observability for your Amazon EKS clusters with AWS Observability services.

This project proposes a core module to bootstrap your cluster with the AWS Distro for OpenTelemetry (ADOT) Operator for EKS, Amazon Managed Service for Prometheus (AMP), Amazon Managed Grafana (AMG). Additionally we have a set of workloads modules to leverage curated ADOT collector configurations, Grafana dashboards, Prometheus rules and alerts.

You can check our examples (https://github.com/aws-observability/terraform-aws-observability-accelerator/tree/main/examples) for different end-to-end integrations scenarios.

We will be leveraging EKS Blueprints (https://github.com/aws-ia/terraform-aws-eks-blueprints) repository to deploy the solution.

## Getting Started

Prerequisites for each of the examples are covered with in the examples directory.

## Deployment Steps
Clone the repository that contains the EKS blueprints:

`git clone https://github.com/aws-observability/terraform-aws-eks-blueprints.git`


# Generate Grafana API Key

* Give admin access to the SSO user you set up when creating the Amazon Managed Grafana Workspace:
* In the AWS Console, navigate to Amazon Grafana. In the left navigation bar, click **All workspaces**, then click on the workspace name you are using for this example.
* Under **Authentication** within **AWS Single Sign-On (SSO)**, click **Configure users and user groups**
* Check the box next to the SSO user you created and click **Make admin**
* From the workspace in the AWS console, click on the `Grafana workspace` URL to open the workspace
* If you don't see the gear icon in the left navigation bar, log out and log back in.
* Click on the gear icon, then click on the **API keys** tab.
* Click **Add API key**, fill in the *Key name* field and select *Admin* as the Role.
* Copy your API key 


## Documentation

For complete project documentation, please visit our documentation (https://github.com/aws-observability/terraform-aws-observability-accelerator/tree/main/docs) site.

## Examples

To view examples for how you can leverage AWS Observability accelerator, please see the examples (https://github.com/aws-observability/terraform-aws-observability-accelerator/tree/main/examples) directory.

## Usage

The below demonstrates how you can leverage AWS Observability Accelerator to enable monitoring to an existing EKS cluster, Managed Service for Prometheus and Amazon Managed Grafana workspaces. Configure the environment variables like below

### Base Module Snippet

This base module allows you to customize whether you would like to use the existing Managed Service for Prometheus and Amazon Managed Grafana workspaces or you can update to create new workspaces.

`
# deploys the base module
module "eks_observability_accelerator" {
  # source = "aws-observability/terrarom-aws-observability-accelerator"
  source = "../../"

  aws_region     = var.aws_region
  eks_cluster_id = var.eks_cluster_id

  # deploys AWS Distro for OpenTelemetry operator into the cluster
  enable_amazon_eks_adot = true

  # reusing existing certificate manager? defaults to true
  enable_cert_manager = true

  # creates a new AMP workspace, defaults to true
  enable_managed_prometheus = false

  # reusing existing AMP -- needs data source for alerting rules
  managed_prometheus_workspace_id     = var.managed_prometheus_workspace_id
  managed_prometheus_workspace_region = null # defaults to the current region, useful for cross region scenarios (same account)

  # sets up the AMP alert manager at the workspace level
  enable_alertmanager = true

  # reusing existing Amazon Managed Grafana workspace
  enable_managed_grafana       = false
  managed_grafana_workspace_id = var.managed_grafana_workspace_id
  grafana_api_key              = var.grafana_api_key

  tags = local.tags
}
`

The values being passed either via environment variables or files would be used here to refer to the existing EKS cluster and its region.

`
  aws_region     = var.aws_region
  eks_cluster_id = var.eks_cluster_id
`

By default, it tries to use the existing Managed Service for Prometheus and Amazon Managed Grafana workspaces however, you can customize them by toggling the below variables.

`
# creates a new AMP workspace, defaults to true
  enable_managed_prometheus = false

...

# reusing existing Amazon Managed Grafana workspace
  enable_managed_grafana       = false

`

You need to turn on `enable_managed_prometheus` and `enable_managed_grafana` variables to create a new managed workspaces for both Prometheus and Grafana.

### Example on how to enable monitoring using existing EKS Cluster, Managed Service for Prometheus and Amazon Managed Grafana workspaces by setting up the necessary environment variables. 

1. Make sure to complete the prerequisites and clone the repository. 

2. Change the directory 

`cd terraform-aws-observability-accelerator/examples/existing-cluster-with-base-and-infra/`

3. Initialize terraform

`terraform init`

`
export TF_VAR_eks_cluster_id=xxx                        # existing EKS clusterid
export TF_VAR_managed_prometheus_workspace_id=ws-xxx    #existing workspace id otherwise new workspace will be created
export TF_VAR_managed_grafana_workspace_id=g-xxx        #existing workspace id otherwise new workspace will be created
export TF_VAR_grafana_api_key="xxx"                     #refer getting started section which shows the steps to create Grafana api key
`

4. Deploy using environment variables

`terraform apply`


The code above will provision the following:

* Enables the AWS EKS Add-on for ADOT operator (https://docs.aws.amazon.com/eks/latest/userguide/opentelemetry.html) to the existing Amazon EKS Cluster (specified in the environment variable) and deploys the ADOT collector with appropriate scrape configuration to ingest metrics to Amazon Managed Service for Prometheus
* Deploys kube-state-metrics (https://github.com/kubernetes/kube-state-metrics) to generate Prometheus format metrics based on the current state of the Kubernetes native resource
* Deploys Node_exporter (https://github.com/prometheus/node_exporter) to collect infrastructure metrics like CPU, Memory and Disk size etc
* Deploys rule files in the Amazon Managed Service for Prometheus Workspace(specified in the terraform variable file) containing rule groups with over 200 rules to gather metrics about Kubernetes native objects
* Configures the Amazon Managed Service for Prometheus workspace as a datasource in the Amazon Managed Grafana workspace
* Creates an Observability folder within the Amazon Managed Grafana workspace(specified in the terraform variable file) and deploys 25 grafana dashboards which visually displays the metrics collected by Amazon Managed Service for Prometheus


## Motivation

Kubernetes is a powerful and extensible container orchestration technology that allows you to deploy and manage containerized applications at scale. The extensible nature of Kubernetes also allows you to use a wide range of popular open-source tools, commonly referred to as add-ons, in Kubernetes clusters. With such a large number of tooling and design choices available however, building a tailored EKS cluster that meets your application’s specific needs can take a significant amount of time. It involves integrating a wide range of open-source tools and AWS services and requires deep expertise in AWS and Kubernetes.

AWS customers have asked for examples that demonstrate how to integrate the landscape of Kubernetes tools and make it easy for them to provision complete, opinionated EKS clusters that meet specific application requirements. Customers can use AWS Observability Accelerator to configure and deploy purpose built EKS clusters, and start onboarding workloads in days, rather than months.

## Support & Feedback

AWS Oservability Accelerator for Terraform is maintained by AWS Solution Architects. It is not part of an AWS service and support is provided best-effort by the AWS Oservability Accelerator community.

To post feedback, submit feature ideas, or report bugs, please use the Issues (https://github.com/aws-observability/terraform-aws-observability-accelerator/issues) section of this GitHub repo.

If you are interested in contributing to EKS Blueprints, see the Contribution (https://github.com/aws-observability/terraform-aws-observability-accelerator/blob/main/CONTRIBUTING.md) guide.

---

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0, < 5.0.0 |
| <a name="requirement_awscc"></a> [awscc](#requirement\_awscc) | >= 0.24.0 |
| <a name="requirement_grafana"></a> [grafana](#requirement\_grafana) | 1.25.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0.0, < 5.0.0 |
| <a name="provider_grafana"></a> [grafana](#provider\_grafana) | 1.25.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_managed_grafana"></a> [managed\_grafana](#module\_managed\_grafana) | terraform-aws-modules/managed-service-grafana/aws | ~> 1.3 |
| <a name="module_operator"></a> [operator](#module\_operator) | ./modules/add-ons/adot-operator | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_prometheus_alert_manager_definition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/prometheus_alert_manager_definition) | resource |
| [aws_prometheus_workspace.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/prometheus_workspace) | resource |
| [grafana_data_source.amp](https://registry.terraform.io/providers/grafana/grafana/1.25.0/docs/resources/data_source) | resource |
| [grafana_folder.this](https://registry.terraform.io/providers/grafana/grafana/1.25.0/docs/resources/folder) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_grafana_workspace.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/grafana_workspace) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region | `string` | n/a | yes |
| <a name="input_eks_cluster_id"></a> [eks\_cluster\_id](#input\_eks\_cluster\_id) | EKS Cluster Id | `string` | n/a | yes |
| <a name="input_enable_alertmanager"></a> [enable\_alertmanager](#input\_enable\_alertmanager) | Create AMP AlertManager for all workloads | `bool` | `false` | no |
| <a name="input_enable_amazon_eks_adot"></a> [enable\_amazon\_eks\_adot](#input\_enable\_amazon\_eks\_adot) | n/a | `bool` | `true` | no |
| <a name="input_enable_cert_manager"></a> [enable\_cert\_manager](#input\_enable\_cert\_manager) | Allow reusing an existing installation of cert-manager | `bool` | `true` | no |
| <a name="input_enable_managed_grafana"></a> [enable\_managed\_grafana](#input\_enable\_managed\_grafana) | n/a | `bool` | `true` | no |
| <a name="input_enable_managed_prometheus"></a> [enable\_managed\_prometheus](#input\_enable\_managed\_prometheus) | n/a | `bool` | `true` | no |
| <a name="input_grafana_api_key"></a> [grafana\_api\_key](#input\_grafana\_api\_key) | n/a | `string` | `null` | no |
| <a name="input_irsa_iam_permissions_boundary"></a> [irsa\_iam\_permissions\_boundary](#input\_irsa\_iam\_permissions\_boundary) | IAM permissions boundary for IRSA roles | `string` | `""` | no |
| <a name="input_irsa_iam_role_path"></a> [irsa\_iam\_role\_path](#input\_irsa\_iam\_role\_path) | IAM role path for IRSA roles | `string` | `"/"` | no |
| <a name="input_managed_grafana_region"></a> [managed\_grafana\_region](#input\_managed\_grafana\_region) | AWS Managed Grafana Workspace Region | `string` | `null` | no |
| <a name="input_managed_grafana_workspace_id"></a> [managed\_grafana\_workspace\_id](#input\_managed\_grafana\_workspace\_id) | n/a | `string` | `""` | no |
| <a name="input_managed_prometheus_workspace_id"></a> [managed\_prometheus\_workspace\_id](#input\_managed\_prometheus\_workspace\_id) | AWS Managed Prometheus Workspace ID | `string` | `""` | no |
| <a name="input_managed_prometheus_workspace_region"></a> [managed\_prometheus\_workspace\_region](#input\_managed\_prometheus\_workspace\_region) | AWS Managed Prometheus Workspace Region | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit`,`XYZ`) | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_region"></a> [aws\_region](#output\_aws\_region) | EKS Cluster Id |
| <a name="output_eks_cluster_id"></a> [eks\_cluster\_id](#output\_eks\_cluster\_id) | EKS Cluster Id |
| <a name="output_eks_cluster_version"></a> [eks\_cluster\_version](#output\_eks\_cluster\_version) | n/a |
| <a name="output_grafana_dashboards_folder_id"></a> [grafana\_dashboards\_folder\_id](#output\_grafana\_dashboards\_folder\_id) | n/a |
| <a name="output_managed_grafana_workspace_endpoint"></a> [managed\_grafana\_workspace\_endpoint](#output\_managed\_grafana\_workspace\_endpoint) | n/a |
| <a name="output_managed_prometheus_workspace_endpoint"></a> [managed\_prometheus\_workspace\_endpoint](#output\_managed\_prometheus\_workspace\_endpoint) | n/a |
| <a name="output_managed_prometheus_workspace_id"></a> [managed\_prometheus\_workspace\_id](#output\_managed\_prometheus\_workspace\_id) | n/a |
| <a name="output_managed_prometheus_workspace_region"></a> [managed\_prometheus\_workspace\_region](#output\_managed\_prometheus\_workspace\_region) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

Apache-2.0 Licensed. See [LICENSE](https://github.com/aws-observability/terraform-aws-eks-blueprints/blob/main/LICENSE).
