terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_security_group" "opspulse" {
  name        = "opspulse-sg"
  description = "Allow SSH and application traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    description = "OpsPulse API"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "opspulse" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.opspulse.id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.opspulse.name

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y docker git
              systemctl enable docker
              systemctl start docker
              usermod -aG docker ec2-user
              EOF

  tags = {
    Name    = "OpsPulse"
    Project = "DevOps-Portfolio"
  }
}

resource "aws_cloudwatch_metric_alarm" "opspulse_high_cpu" {
  alarm_name          = "opspulse-high-cpu"
  alarm_description   = "Triggers when OpsPulse EC2 CPU usage exceeds 70 percent"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 70

  dimensions = {
    InstanceId = aws_instance.opspulse.id
  }

  alarm_actions = [aws_sns_topic.opspulse_alerts.arn]
  ok_actions    = [aws_sns_topic.opspulse_alerts.arn]

  tags = {
    Project = "OpsPulse"
  }
}

resource "aws_cloudwatch_log_group" "opspulse" {
  name              = "/opspulse/application"
  retention_in_days = 7

  tags = {
    Project = "OpsPulse"
  }
}

resource "aws_iam_role" "opspulse_ec2_role" {
  name = "opspulse-ec2-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = aws_iam_role.opspulse_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "opspulse" {
  name = "opspulse-ec2-instance-profile"
  role = aws_iam_role.opspulse_ec2_role.name
}




resource "aws_cloudwatch_dashboard" "opspulse" {
  dashboard_name = "OpsPulse-Operations-Dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          title  = "OpsPulse EC2 CPU Utilisation"
          region = var.aws_region
          view   = "timeSeries"
          period = 300
          stat   = "Average"

          metrics = [
            [
              "AWS/EC2",
              "CPUUtilization",
              "InstanceId",
              aws_instance.opspulse.id
            ]
          ]
        }
      },

      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          title  = "OpsPulse Network Traffic"
          region = var.aws_region
          view   = "timeSeries"
          period = 300
          stat   = "Sum"

          metrics = [
            [
              "AWS/EC2",
              "NetworkIn",
              "InstanceId",
              aws_instance.opspulse.id
            ],
            [
              "AWS/EC2",
              "NetworkOut",
              "InstanceId",
              aws_instance.opspulse.id
            ]
          ]
        }
      },

      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          title  = "EC2 Status Check Failures"
          region = var.aws_region
          view   = "timeSeries"
          period = 300
          stat   = "Maximum"

          metrics = [
            [
              "AWS/EC2",
              "StatusCheckFailed",
              "InstanceId",
              aws_instance.opspulse.id
            ]
          ]
        }
      },

      {
        type   = "log"
        x      = 12
        y      = 6
        width  = 12
        height = 6

        properties = {
          title  = "OpsPulse Application Logs"
          region = var.aws_region
          view   = "table"

          query = "SOURCE '/opspulse/application' | fields @timestamp, @message | sort @timestamp desc | limit 20"
        }
      }
    ]
  })
}

resource "aws_sns_topic" "opspulse_alerts" {
  name = "opspulse-alerts"

  tags = {
    Project = "OpsPulse"
  }
}

variable "alert_email" {
  description = "Email address for OpsPulse CloudWatch alerts"
  type        = string
}

resource "aws_sns_topic_subscription" "opspulse_email" {
  topic_arn = aws_sns_topic.opspulse_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}
