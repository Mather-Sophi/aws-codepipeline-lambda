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
  type        = map(any)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

variable "use_repo_access_github_token" {
  type        = bool
  description = <<EOT
                (Optional) Allow the AWS codebuild IAM role read access to the REPO_ACCESS_GITHUB_TOKEN secrets manager secret in the shared service account.
                Defaults to false.
                EOT
  default     = false
}

variable "svcs_account_github_token_aws_secret_arn" {
  type        = string
  description = <<EOT
                (Optional) The AWS secret ARN for the repo access Github token.
                The secret is created in the shared service account.
                Required if var.use_repo_access_github_token is true.
                EOT
  default     = null
}

variable "svcs_account_aws_kms_cmk_arn" {
  type        = string
  description = <<EOT
                (Optional) The us-east-1 region AWS KMS customer managed key ARN for encrypting all AWS secrets.
                The key is created in the shared service account.
                Required if var.use_repo_access_github_token or var.use_sysdig_api_token is true.
                EOT
  default     = null
}

variable "create_github_webhook" {
  type        = bool
  description = "Create the github webhook that triggers codepipeline. Defaults to true"
  default     = true
}

variable "s3_block_public_access" {
  type = bool
  description = "(Optional) Enable the S3 block public access setting for the artifact bucket."
  default = false
}