## aws-codepipeline-lambda
Creates a pipeline that generates a lambda zip archive and updates the existing function code

## v1.4 Note
The account that owns the guthub token must have admin access on the repo in order to generate a github webhook 

## v1.6 Note
The secrets manager environment variable `REPO_ACCESS_GITHUB_TOKEN_SECRETS_ID` is exposed via codebuild.

You can add the 1 line to the beginning of your `build` phase commands in `buildspec.yml` to assign the token's secret value to local variable `GITHUB_TOKEN`.

## v1.8 Note
Removes the github provider from main.tf and is moved to the required_providers stanza in versions.tf


```yml
  build:
    commands:
      - export GITHUB_TOKEN=${REPO_ACCESS_GITHUB_TOKEN_SECRETS_ID}
```

## v1.9 Note
If `use_repo_access_github_token` is set to `true`, the environment variable `REPO_ACCESS_GITHUB_TOKEN_SECRETS_ID` is exposed via codebuild.
Usage remains the same as v1.6.
If `s3_block_public_access` is set to `true`, the block public access setting for the artifact bucket is enabled.

## Usage

```hcl
module "lambda_pipeline" {
  source = "github.com/globeandmail/aws-codepipeline-lambda?ref=1.10"

  name               = app-name
  function_name      = lambda-function-name
  github_repo_owner  = github-account-name
  github_repo_name   = github-repo-name
  github_oauth_token = data.aws_ssm_parameter.github_token.value
  tags = {
    Environment = var.environment
  }
  use_repo_access_github_token = true
  svcs_account_github_token_aws_secret_arn = svcs-account-github-token-aws-secret-arn
  svcs_account_aws_kms_cmk_arn = svcs-account-aws-kms-cmk-arn
  s3_block_public_access = true
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_buildspec"></a> [buildspec](#input\_buildspec) | build spec file other than buildspec.yml | `string` | `"buildspec.yml"` | no |
| <a name="input_codebuild_image"></a> [codebuild\_image](#input\_codebuild\_image) | The codebuild image to use | `string` | `null` | no |
| <a name="input_create_github_webhook"></a> [create\_github\_webhook](#input\_create\_github\_webhook) | Create the github webhook that triggers codepipeline. Defaults to true | `bool` | `true` | no |
| <a name="input_deploy_function_name"></a> [deploy\_function\_name](#input\_deploy\_function\_name) | The name of the Lambda function in the account that will update the function code | `string` | `"CodepipelineDeploy"` | no |
| <a name="input_function_alias"></a> [function\_alias](#input\_function\_alias) | The name of the Lambda function alias that gets passed to the UserParameters data in the deploy stage | `string` | `"live"` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | The name of the Lambda function to update | `string` | n/a | yes |
| <a name="input_github_branch_name"></a> [github\_branch\_name](#input\_github\_branch\_name) | The git branch name to use for the codebuild project | `string` | `"master"` | no |
| <a name="input_github_oauth_token"></a> [github\_oauth\_token](#input\_github\_oauth\_token) | GitHub oauth token | `string` | n/a | yes |
| <a name="input_github_repo_name"></a> [github\_repo\_name](#input\_github\_repo\_name) | The name of the GitHub repository | `string` | n/a | yes |
| <a name="input_github_repo_owner"></a> [github\_repo\_owner](#input\_github\_repo\_owner) | The owner of the GitHub repo | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name associated with the pipeline and assoicated resources. ie: app-name | `string` | n/a | yes |
| <a name="input_privileged_mode"></a> [privileged\_mode](#input\_privileged\_mode) | Use privileged mode for containers | `string` | `false` | no |
| <a name="input_s3_block_public_access"></a> [s3\_block\_public\_access](#input\_s3\_block\_public\_access) | (Optional) Enable the S3 block public access setting for the artifact bucket. | `bool` | `false` | no |
| <a name="input_svcs_account_aws_kms_cmk_arn"></a> [svcs\_account\_aws\_kms\_cmk\_arn](#input\_svcs\_account\_aws\_kms\_cmk\_arn) | (Optional) The us-east-1 region AWS KMS customer managed key ARN for encrypting all AWS secrets.<br>                The key is created in the shared service account.<br>                Required if var.use\_repo\_access\_github\_token or var.use\_sysdig\_api\_token is true. | `string` | `null` | no |
| <a name="input_svcs_account_github_token_aws_secret_arn"></a> [svcs\_account\_github\_token\_aws\_secret\_arn](#input\_svcs\_account\_github\_token\_aws\_secret\_arn) | (Optional) The AWS secret ARN for the repo access Github token.<br>                The secret is created in the shared service account.<br>                Required if var.use\_repo\_access\_github\_token is true. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource | `map(any)` | `{}` | no |
| <a name="input_use_repo_access_github_token"></a> [use\_repo\_access\_github\_token](#input\_use\_repo\_access\_github\_token) | (Optional) Allow the AWS codebuild IAM role read access to the REPO\_ACCESS\_GITHUB\_TOKEN secrets manager secret in the shared service account.<br>                Defaults to false. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_artifact_bucket_arn"></a> [artifact\_bucket\_arn](#output\_artifact\_bucket\_arn) | n/a |
| <a name="output_artifact_bucket_id"></a> [artifact\_bucket\_id](#output\_artifact\_bucket\_id) | n/a |
| <a name="output_codebuild_project_arn"></a> [codebuild\_project\_arn](#output\_codebuild\_project\_arn) | n/a |
| <a name="output_codebuild_project_id"></a> [codebuild\_project\_id](#output\_codebuild\_project\_id) | n/a |
| <a name="output_codepipeline_arn"></a> [codepipeline\_arn](#output\_codepipeline\_arn) | n/a |
| <a name="output_codepipeline_id"></a> [codepipeline\_id](#output\_codepipeline\_id) | n/a |


## Builspec example

```yml
version: 0.2

phases:
  install:
    runtime-versions:
      python: 3.7
  build:
    commands:
      - pip install --upgrade pip
      - pip install -r requirements.txt -t .
artifacts:
  type: zip
  files:
    - '**/*'
```
