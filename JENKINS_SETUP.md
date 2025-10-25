# Jenkins CI/CD Setup for Terraform EKS Deployment

## Prerequisites

1. **Jenkins Server** with the following installed:
   - Terraform (v1.5.0 or higher)
   - AWS CLI
   - Git

2. **AWS Credentials** configured in Jenkins:
   - Go to Jenkins → Manage Jenkins → Manage Credentials
   - Add AWS credentials (Access Key ID and Secret Access Key)

3. **Jenkins Plugins**:
   - Pipeline
   - Git plugin
   - AWS Credentials plugin

## Jenkins Configuration

### 1. Configure AWS Credentials

In Jenkins:
1. Navigate to **Manage Jenkins** → **Manage Credentials**
2. Add credentials:
   - Kind: **AWS Credentials**
   - ID: `aws-credentials`
   - Access Key ID: Your AWS Access Key
   - Secret Access Key: Your AWS Secret Key

### 2. Create Jenkins Pipeline Job

1. Click **New Item**
2. Enter job name: `terraform-eks-deployment`
3. Select **Pipeline**
4. Click **OK**

### 3. Configure Pipeline

In the job configuration:

**General:**
- Check "GitHub project" (optional)
- Project URL: `https://github.com/mohamed55979/HelloApp`

**Build Triggers:**
- Check "GitHub hook trigger for GITScm polling" (for automatic builds)
- Or "Poll SCM" with schedule: `H/5 * * * *` (checks every 5 minutes)

**Pipeline:**
- Definition: **Pipeline script from SCM**
- SCM: **Git**
- Repository URL: `https://github.com/mohamed55979/HelloApp.git`
- Branch Specifier: `*/main`
- Script Path: `Jenkinsfile`

### 4. Environment Variables (Optional)

Add these in Jenkins job configuration → Pipeline → Environment:
```
AWS_REGION=us-east-1
TF_VAR_project_name=your-project
TF_VAR_environment=dev
```

## Pipeline Stages

The Jenkinsfile includes these stages:

1. **Checkout** - Gets code from repository
2. **Terraform Init** - Initializes Terraform
3. **Terraform Validate** - Validates Terraform configuration
4. **Terraform Plan** - Creates execution plan
5. **Approval** - Manual approval for deployment (main branch only)
6. **Terraform Apply** - Applies changes to infrastructure

## Running the Pipeline

### Manual Trigger:
1. Go to your Jenkins job
2. Click **Build Now**

### Automatic Trigger:
- Push changes to the `main` branch
- Jenkins will automatically detect and start the build

## Terraform Backend Configuration

Make sure your `backend.tf` is configured for remote state:

```hcl
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
```

## Security Notes

- Never commit `terraform.tfvars` with sensitive data
- Use Jenkins credentials for AWS access
- Enable encryption for Terraform state
- Use separate environments (dev/staging/prod)

## Troubleshooting

**Issue: AWS credentials not found**
- Solution: Ensure AWS credentials are configured in Jenkins

**Issue: Terraform not found**
- Solution: Install Terraform on Jenkins agent

**Issue: Permission denied**
- Solution: Ensure IAM user has necessary permissions for EKS, VPC, IAM

## Next Steps

1. Configure S3 backend for Terraform state
2. Set up GitHub webhooks for automatic builds
3. Add automated tests
4. Configure notifications (email/Slack)
