# EKS on Terraform (2-week project)

Rebuilding a manually created EKS cluster as code: VPC, EKS, IRSA, ALB controller,
then a real app, autoscaling, security, and observability.

## Layout
```
bootstrap/   one-time: creates the S3 bucket for remote state (local state)
infra/       main project: uses the remote backend created above
NOTES.md     running log of errors and fixes
```

## Day 1: Foundation (PowerShell on Windows)

### 1. Verify tools
```powershell
terraform -version          # need >= 1.10
aws --version
aws sts get-caller-identity
kubectl version --client
```

### 2. Create the remote state bucket
```powershell
cd bootstrap
terraform init
terraform plan
terraform apply
terraform output -raw backend_hcl
```
Note: bootstrap uses *local* state (a chicken-and-egg problem: the bucket
can't store its own state before it exists). Keep `bootstrap/terraform.tfstate`
safe, or later migrate it into the bucket.

### 3. Point infra at the remote backend
```powershell
cd ..\infra
copy backend.hcl.example backend.hcl     # then paste the values from step 2
copy terraform.tfvars.example terraform.tfvars
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```
Success looks like: outputs show your account ID, region, and AZs, and
`eks/terraform.tfstate` appears in the S3 bucket.

### 4. Commit
```powershell
cd ..
git init
git add .
git commit -m "Day 1: remote state backend and project skeleton"
```

## Cost
Day 1 costs effectively nothing (one S3 bucket). Do NOT destroy the bootstrap
bucket between sessions; it is protected with `prevent_destroy`.
