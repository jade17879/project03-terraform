# Project-03: AWS Infrastructure Automation Using Terraform & GitHub Actions

## 1. Project Overview

This project demonstrates Infrastructure as Code (IaC) by provisioning AWS infrastructure using Terraform and automating Terraform validation through GitHub Actions.

The goal is to create a repeatable, maintainable, and version-controlled infrastructure deployment workflow.

## 2. Objectives

- Provision AWS infrastructure using Terraform.
- Create a custom Amazon VPC.
- Configure two public subnets across two Availability Zones.
- Attach an Internet Gateway to the VPC.
- Configure a public route table and subnet associations.
- Store Terraform state remotely in Amazon S3.
- Automate Terraform formatting, initialization, and validation using GitHub Actions.
- Prepare the workflow for a controlled plan, approval, and apply process.

## 3. Architecture

The infrastructure includes:

- **Amazon VPC:** `10.0.0.0/16`
- **Public Subnet A:** `10.0.1.0/24`
- **Public Subnet B:** `10.0.2.0/24`
- **Internet Gateway:** Provides an internet gateway for the VPC.
- **Public Route Table:** Routes internet-bound traffic through the Internet Gateway.
- **Amazon S3:** Stores Terraform state remotely.
- **GitHub Actions:** Automates Terraform checks.

### Architecture Diagram

```text
Developer
    |
    v
GitHub Repository
    |
    v
GitHub Actions
    |
    v
Terraform Format / Init / Validate
    |
    v
Terraform Plan and Approval
    |
    v
Terraform Apply
    |
    v
AWS Infrastructure
    |
    +-- Amazon VPC
    |
    +-- Public Subnet A
    |
    +-- Public Subnet B
    |
    +-- Internet Gateway
    |
    +-- Public Route Table
    |
    +-- Subnet Associations

Terraform State --> Amazon S3
```

**Note:** The current GitHub Actions workflow performs formatting checks, initialization without the remote backend, and validation. The plan, approval, and apply stages will be enabled after AWS authentication and deployment controls are configured.

## 4. Technologies Used

- Amazon Web Services (AWS)
- Terraform
- Amazon VPC
- Amazon EC2 networking components
- Amazon S3
- Git and GitHub
- GitHub Actions
- YAML
- HashiCorp Configuration Language (HCL)

## 5. Repository Structure

```text
project03-terraform/
├── .github/
│   └── workflows/
│       └── terraform.yml
├── backend.tf
├── main.tf
├── providers.tf
├── variables.tf
├── outputs.tf
└── README.md
```

## 6. Prerequisites

- An AWS account.
- Terraform CLI version 1.10.0 or newer.
- Git installed on the local machine.
- A GitHub repository.
- AWS credentials configured securely.
- An S3 bucket for Terraform state in the `ap-south-1` region.

## 7. Terraform Backend Configuration

Terraform state is configured to use Amazon S3.

- **Bucket:** `project03-tfstate-a1`
- **State key:** `project03/terraform.tfstate`
- **AWS Region:** `ap-south-1`
- **Encryption:** Enabled
- **State locking:** S3 lockfile enabled

The S3 bucket must exist before initializing Terraform with this backend. Appropriate AWS permissions are also required.

## 8. Local Setup and Validation

Clone the repository:

```bash
git clone https://github.com/jade17879/project03-terraform.git
cd project03-terraform
```

Format Terraform files:

```bash
terraform fmt -recursive
```

Initialize Terraform using the configured backend:

```bash
terraform init
```

Validate the configuration:

```bash
terraform validate
```

Review the proposed infrastructure changes:

```bash
terraform plan
```

Apply changes only after reviewing the plan and confirming that the AWS account, region, and intended resources are correct:

```bash
terraform apply
```

## 9. GitHub Actions Workflow

The GitHub Actions workflow is located at:

`.github/workflows/terraform.yml`

The current workflow automates:

1. Checking out the repository.
2. Installing Terraform.
3. Checking Terraform formatting.
4. Initializing Terraform without accessing the remote backend.
5. Validating the Terraform configuration.

The next stage is to configure secure AWS authentication, generate a Terraform plan, introduce an approval gate, and apply the reviewed plan.

## 10. Security Best Practices

- Never commit AWS access keys, secret keys, passwords, or Personal Access Tokens.
- Use GitHub OIDC with an appropriately restricted AWS IAM role for GitHub Actions.
- Apply least-privilege IAM permissions.
- Keep the S3 state bucket private.
- Enable S3 encryption and appropriate bucket security controls.
- Restrict who can approve and apply infrastructure changes.
- Review Terraform plans before applying changes.
- Protect the main branch and use pull requests for infrastructure changes.

## 11. Validation Checklist

- [ ] Terraform configuration is formatted.
- [ ] Terraform initialization completes successfully.
- [ ] Terraform validation passes.
- [ ] GitHub Actions workflow completes successfully.
- [ ] S3 backend and state locking are verified.
- [ ] AWS resources are provisioned successfully.
- [ ] VPC and subnet IDs are captured as outputs.
- [ ] Public route table and subnet associations are verified.
- [ ] Evidence screenshots are saved for project submission.

## 12. Expected Outcome

The project establishes a version-controlled Terraform infrastructure repository and a GitHub Actions validation pipeline. After secure AWS authentication and deployment approval are implemented, the workflow can be extended to provision and validate the AWS infrastructure automatically.

## 13. Author and Repository

**Project:** Project-03 — AWS Infrastructure Automation Using Terraform & GitHub Actions

**GitHub Repository:** https://github.com/jade17879/project03-terraform

**AWS Region:** Asia Pacific (Mumbai) — `ap-south-1`
