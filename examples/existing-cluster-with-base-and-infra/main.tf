provider "aws" {
  region = local.region
}

data "aws_eks_cluster_auth" "this" {
  name = var.eks_cluster_id
}

data "aws_eks_cluster" "this" {
  name = var.eks_cluster_id
}

data "aws_grafana_workspace" "this" {
  workspace_id = var.managed_grafana_workspace_id
}

provider "kubernetes" {
  host                   = local.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = local.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

locals {
  region               = var.aws_region
  eks_cluster_endpoint = data.aws_eks_cluster.this.endpoint
  create_new_workspace = var.managed_prometheus_workspace_id == "" ? true : false
  tags = {
    Source = "github.com/aws-observability/terraform-aws-observability-accelerator"
  }
}

module "eks_monitoring" {
  source = "../../modules/eks-monitoring"
  # source = "github.com/aws-observability/terraform-aws-observability-accelerator//modules/eks-monitoring?ref=v2.0.0"

  eks_cluster_id = var.eks_cluster_id

  # deploys AWS Distro for OpenTelemetry operator into the cluster
  enable_amazon_eks_adot = true

  # reusing existing certificate manager? defaults to true
  enable_cert_manager = true

  # enable EKS API server monitoring
  enable_apiserver_monitoring = true

  # deploys external-secrets in to the cluster
  enable_external_secrets          = true
  grafana_api_key                  = var.grafana_api_key
  target_secret_name               = "grafana-admin-credentials"
  target_secret_namespace          = "grafana-operator"
  grafana_url                      = "https://${data.aws_grafana_workspace.this.endpoint}"
  grafana_api_key_refresh_interval = var.grafana_api_key_refresh_interval

  # control the publishing of dashboards by specifying the boolean value for the variable 'enable_dashboards', default is 'true'
  enable_dashboards = var.enable_dashboards

  # creates a new Amazon Managed Prometheus workspace, defaults to true
  enable_managed_prometheus       = local.create_new_workspace
  managed_prometheus_workspace_id = var.managed_prometheus_workspace_id

  # sets up the Amazon Managed Prometheus alert manager at the workspace level
  enable_alertmanager = true

  # optional, defaults to 60s interval and 15s timeout
  prometheus_config = {
    global_scrape_interval = "60s"
    global_scrape_timeout  = "15s"
  }

  enable_logs = true

  tags = local.tags
}

# Enabling Grafana API Key Rotation
module "grafana_key_rotation" {
  source = "../../modules/grafana-key-rotation"
  count  = var.enable_grafana_key_rotation ? 1 : 0

  managed_grafana_workspace_id              = var.managed_grafana_workspace_id
  grafana_api_key_interval                  = var.grafana_api_key_interval
  eventbridge_scheduler_schedule_expression = var.eventbridge_scheduler_schedule_expression
  lambda_runtime_grafana_key_rotation       = var.lambda_runtime_grafana_key_rotation

  ssmparameter_name = module.eks_monitoring.ssmparameter_name
  ssmparameter_arn  = module.eks_monitoring.ssmparameter_arn
  kms_key_arn_ssm   = module.eks_monitoring.kms_key_arn
}
