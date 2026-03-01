# Patch Management - Miaodong Technology
# AWS Systems Manager Patch Manager

# Maintenance Window
resource "aws_ssm_maintenance_window" "patch_window" {
  name     = "miaodong-${var.environment}-patch-window"
  schedule = "cron(0 2 ? * SUN *)"
  duration = 3
  cutoff   = 1

  tags = {
    Environment = var.environment
    Company     = "Shenzhen-Miaodong-Technology"
  }
}

# Patch Baseline
resource "aws_ssm_patch_baseline" "baseline" {
  name             = "miaodong-${var.environment}-baseline"
  operating_system = "AMAZON_LINUX_2023"
  
  approval_rule {
    approve_after_days = 7
    compliance_level   = "CRITICAL"
    
    patch_filter {
      key    = "CLASSIFICATION"
      values = ["Security", "Bugfix"]
    }
    
    patch_filter {
      key    = "SEVERITY"
      values = ["Critical", "Important"]
    }
  }

  tags = {
    Environment = var.environment
    Company     = "Shenzhen-Miaodong-Technology"
  }
}

# Patch Group
resource "aws_ssm_patch_group" "group" {
  baseline_id = aws_ssm_patch_baseline.baseline.id
  patch_group = "miaodong-${var.environment}"
}

# Maintenance Window Target
resource "aws_ssm_maintenance_window_target" "target" {
  window_id     = aws_ssm_maintenance_window.patch_window.id
  resource_type = "INSTANCE"

  targets {
    key    = "tag:PatchGroup"
    values = ["miaodong-${var.environment}"]
  }
}

# Maintenance Window Task
resource "aws_ssm_maintenance_window_task" "patch_task" {
  window_id        = aws_ssm_maintenance_window.patch_window.id
  task_type        = "RUN_COMMAND"
  task_arn         = "AWS-RunPatchBaseline"
  priority         = 1
  service_role_arn = aws_iam_role.ssm_maintenance.arn
  max_concurrency  = "2"
  max_errors       = "1"

  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.target.id]
  }

  task_invocation_parameters {
    run_command_parameters {
      parameter {
        name   = "Operation"
        values = ["Install"]
      }
    }
  }
}

# IAM Role for SSM
resource "aws_iam_role" "ssm_maintenance" {
  name = "miaodong-${var.environment}-ssm-maintenance"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ssm.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_maintenance" {
  role       = aws_iam_role.ssm_maintenance.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSSMMaintenanceWindowRole"
}

output "patch_baseline_id" {
  value = aws_ssm_patch_baseline.baseline.id
}

output "maintenance_window_id" {
  value = aws_ssm_maintenance_window.patch_window.id
}
