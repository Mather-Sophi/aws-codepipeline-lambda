variable "name" {
  type        = string
  description = "The name associated with the pipeline and assoicated resources. ie: app-name"
}

variable "github_repo_owner" {
  type        = string
  description = "The owner of the GitHub repo"
}

variable "github_repo_name" {
  type        = string
  description = "The name of the GitHub repository"
}

variable "github_branch_name" {
  type        = string
  description = "The git branch name to use for the codebuild project"
  default     = "master"
}

variable "github_oauth_token" {
  type        = string
  description = "GitHub oauth token"
}

variable "codebuild_image" {
  type        = string
  description = "The codebuild image to use"
  default     = null
}

variable "buildspec" {
  type        = string
  description = "build spec file other than buildspec.yml"
  default     = "buildspec.yml"
}

variable "function_name" {
  type        = string
  description = "The name of the Lambda function to update"
}

variable "function_alias" {
  type        = string
  default     = "live"
  description = "The name of the Lambda function alias that gets passed to the UserParameters data in the deploy stage"
}

variable "deploy_function_name" {
  type        = string
  description = "The name of the Lambda function in the account that will update the function code"
  default     = "CodepipelineDeploy"
}

variable "privileged_mode" {
  type        = string
  description = "Use privileged mode for containers"
  default     = false
}


variable "tags" {
  type        = map
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

variable "central_account_github_token_aws_secret_arn" {
  type = string
  description = "(Required) The repo access Github token AWS secret ARN in the ds-ml-shared-svcs-prod AWS account"
}

variable "central_account_github_token_aws_kms_cmk_arn" {
  type = string
  description = "(Required) The repo access Github token AWS KMS customer managed key ARN in the ds-ml-shared-svcs-prod AWS account"
}