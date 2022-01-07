## aws-codepipeline-lambda
Creates a pipeline that generates a lambda zip archive and updates the existing function code

## v1.4 Note
The account that owns the guthub token must have admin access on the repo in order to generate a github webhook 

## v1.6 Note
The secrets manager environment variable `REPO_ACCESS_GITHUB_TOKEN_SECRETS_ID` is exposed via codebuild

You can add the 1 line to the beginning of your `build` phase commands in `buildspec.yml` to assign the token's secret value to local variable `GITHUB_TOKEN`.

## v1.8 Note
Removes the github provider from main.tf and is moved to the required_providers stanza in versions.tf


```yml
  build:
    commands:
      - export GITHUB_TOKEN=${REPO_ACCESS_GITHUB_TOKEN_SECRETS_ID}
```

## Usage

```hcl
module "lambda_pipeline" {
  source = "github.com/globeandmail/aws-codepipeline-lambda?ref=1.7"

  name               = app-name
  function_name      = lambda-function-name
  github_repo_owner  = github-account-name
  github_repo_name   = github-repo-name
  github_oauth_token = data.aws_ssm_parameter.github_token.value
  tags = {
    Environment = var.environment
  }
  central_account_github_token_aws_secret_arn = central-account-github-token-aws-secret-arn
  central_account_github_token_aws_kms_cmk_arn = central-account-github-token-aws-kms-cmk-arn
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | The name associated with the pipeline and assoicated resources. ie: app-name | string | n/a | yes |
| function\_name | The name of the Lambda function to update | string | n/a | yes |
| github\_repo\_owner | The owner of the GitHub repo | string | n/a | yes |
| github\_repo\_name | The name of the GitHub repository | string | n/a | yes |
| github\_oauth\_token | GitHub oauth token | string | n/a | yes |
| github\_branch\_name | The git branch name to use for the codebuild project | string | `"master"` | no |
| codebuild\_image | The codebuild image to use | string | `"null"` | no |
| buildspec | build spec file other than buildspec.yml | string | `"buildspec.yml"` | no |
| function\_alias | The name of the Lambda function alias that gets passed to the UserParameters data in the deploy stage | string | `"live"` | no |
| deploy\_function\_name | The name of the Lambda function in the account that will update the function code | string | `"CodepipelineDeploy"` | no |
| tags | A mapping of tags to assign to the resource | map | `{}` | no |
| central\_account\_github\_token\_aws\_secret\_arn | \(Required\) The repo access Github token AWS secret ARN in the central AWS account | string | n/a | yes |
| central\_account\_github\_token\_aws\_kms\_cmk\_arn | \(Required\) The repo access Github token AWS KMS customer managed key ARN in the central AWS account | string | n/a | yes |
| create\_github\_webhook | Create the github webhook that triggers codepipeline | bool | `"true"` | no |

## Outputs

| Name | Description |
|------|-------------|
| artifact\_bucket\_arn |  |
| artifact\_bucket\_id |  |
| codebuild\_project\_arn |  |
| codebuild\_project\_id |  |
| codepipeline\_arn |  |
| codepipeline\_id |  |

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
