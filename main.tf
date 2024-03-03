provider "aws" {
  region = "ap-south-1"
}

locals {
  userdata = templatefile("/cw-agent/userdata.sh", {
    ssm_cloudwatch_config = aws_ssm_parameter.cw_agent.name
  })
}

resource "aws_instance" "this" {
  ami                  = "ami-0cbc6aae997c6538a"
  instance_type        = "t2.large"
  iam_instance_profile = aws_iam_instance_profile.this.name
  user_data            = local.userdata
  tags                 = { Name = "EC2-with-cw-agent" }
}

resource "aws_ssm_parameter" "cw_agent" {
  description = "Cloudwatch agent config to configure custom log"
  name        = "/cloudwatch-agent/config"
  type        = "String"
  value       = file("/cw-agent/cw_agent_config.json")
}
