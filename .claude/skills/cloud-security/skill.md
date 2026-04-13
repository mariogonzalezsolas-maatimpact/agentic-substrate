---
name: cloud-security
description: "Cloud security assessment for AWS, Azure, and GCP. Covers IAM audit, S3/storage exposure, network security groups, secrets management, logging/monitoring, serverless security, and CIS benchmark compliance."
auto_invoke: false
tags: [security, cloud, aws, azure, gcp, iam, cspm, cis-benchmarks]
---

# Cloud Security Skill

Systematic cloud security assessment covering the three major providers. Maps to CIS Benchmarks, NIST CSF 2.0, and MITRE ATT&CK Cloud Matrix.

## When to Invoke

- Security audit of cloud infrastructure
- IAM policy review
- Storage bucket/blob exposure assessment
- Cloud deployment security review
- Compliance check (CIS, SOC 2, HIPAA)
- New cloud resource provisioning

## Cloud Security Assessment Protocol

### Phase 1: IAM & Access Control

#### AWS IAM Audit
```bash
# List users without MFA
aws iam generate-credential-report
aws iam get-credential-report --output text --query 'Content' | base64 -d | grep -E "false.*password_enabled"

# Find overly permissive policies
aws iam list-policies --only-attached --query 'Policies[?PolicyName!=`AdministratorAccess`]'

# Check for wildcard permissions
aws iam get-policy-version --policy-arn $ARN --version-id $VER | grep '"*"'

# Find access keys older than 90 days
aws iam list-access-keys --user-name $USER | jq '.AccessKeyMetadata[] | select(.CreateDate < "'$(date -d '-90 days' +%Y-%m-%d)'")'

# Check root account usage
aws iam generate-credential-report | jq '.Content' | base64 -d | grep '<root_account>'
```

#### Azure AD Audit
```bash
# List users with Global Admin role
az ad user list --query "[?assignedPlans[?contains(servicePlanId, 'admin')]]"

# Check conditional access policies
az rest --method get --url "https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies"

# Review service principals
az ad sp list --all --query "[?servicePrincipalType=='Application']"
```

#### GCP IAM Audit
```bash
# List IAM bindings with overly permissive roles
gcloud projects get-iam-policy $PROJECT --format=json | jq '.bindings[] | select(.role | contains("admin") or contains("owner") or contains("editor"))'

# Check service account keys
gcloud iam service-accounts keys list --iam-account=$SA_EMAIL --managed-by=user
```

**Critical findings**:
- Root/owner account used for daily operations
- No MFA on privileged accounts
- Access keys > 90 days old
- Wildcard (*) resource permissions
- Cross-account trust without conditions

### Phase 2: Storage & Data Exposure

#### AWS S3
```bash
# Find public buckets
aws s3api list-buckets | jq -r '.Buckets[].Name' | while read b; do
  acl=$(aws s3api get-bucket-acl --bucket "$b" 2>/dev/null)
  policy=$(aws s3api get-bucket-policy --bucket "$b" 2>/dev/null)
  echo "$b: ACL=$acl POLICY=$policy"
done

# Check for unencrypted buckets
aws s3api get-bucket-encryption --bucket $BUCKET 2>&1 | grep -q "ServerSideEncryptionConfigurationNotFoundError" && echo "UNENCRYPTED"

# Check versioning (ransomware recovery)
aws s3api get-bucket-versioning --bucket $BUCKET
```

#### Azure Blob Storage
```bash
# Check for public containers
az storage container list --account-name $ACCOUNT --query "[?properties.publicAccess!=null]"
```

#### GCP Cloud Storage
```bash
# Check for publicly accessible buckets
gsutil iam get gs://$BUCKET | grep -i "allUsers\|allAuthenticatedUsers"
```

### Phase 3: Network Security

```bash
# AWS: Find security groups with 0.0.0.0/0 ingress
aws ec2 describe-security-groups --query 'SecurityGroups[?IpPermissions[?IpRanges[?CidrIp==`0.0.0.0/0`]]]' --output json

# AWS: Check for public RDS instances
aws rds describe-db-instances --query 'DBInstances[?PubliclyAccessible==`true`]'

# AWS: Find unencrypted EBS volumes
aws ec2 describe-volumes --query 'Volumes[?!Encrypted]'

# Azure: Find NSG rules allowing all inbound
az network nsg list --query "[].securityRules[?access=='Allow' && direction=='Inbound' && sourceAddressPrefix=='*']"

# GCP: Find firewall rules allowing 0.0.0.0/0
gcloud compute firewall-rules list --filter="sourceRanges:0.0.0.0/0 AND allowed[].ports:*" --format=json
```

### Phase 4: Logging & Monitoring

| Check | AWS | Azure | GCP |
|-------|-----|-------|-----|
| Cloud trail/audit log enabled | CloudTrail | Activity Log | Cloud Audit Logs |
| Log storage encrypted | S3 encryption | Storage encryption | GCS encryption |
| Log retention >= 1 year | S3 lifecycle | Retention policy | Retention config |
| Alerting on root/admin actions | CloudWatch | Azure Monitor | Cloud Monitoring |
| VPC/network flow logs | VPC Flow Logs | NSG Flow Logs | VPC Flow Logs |
| DNS query logging | Route53 Query Logs | DNS Analytics | Cloud DNS Logging |

```bash
# AWS: Check CloudTrail status
aws cloudtrail describe-trails --query 'trailList[].{Name:Name,IsMultiRegion:IsMultiRegionTrail,LogValidation:LogFileValidationEnabled}'

# AWS: Check GuardDuty enabled
aws guardduty list-detectors
```

### Phase 5: Secrets Management

```bash
# Find hardcoded secrets in environment variables
aws lambda list-functions | jq -r '.Functions[].FunctionName' | while read f; do
  aws lambda get-function-configuration --function-name "$f" | jq '.Environment.Variables' | grep -iE "key|secret|password|token"
done

# Check if Secrets Manager/Parameter Store is used
aws secretsmanager list-secrets
aws ssm describe-parameters --filters "Key=Type,Values=SecureString"
```

**Secrets anti-patterns**:
- Hardcoded in Lambda environment variables
- Stored in plaintext SSM parameters
- Committed in CloudFormation/Terraform templates
- Shared via S3 buckets without encryption

### Phase 6: Serverless Security

```bash
# Lambda: Check runtime versions (outdated = vulnerable)
aws lambda list-functions --query 'Functions[].{Name:FunctionName,Runtime:Runtime}' | jq '.[] | select(.Runtime | contains("python3.8") or contains("nodejs14") or contains("nodejs16"))'

# Lambda: Check for overly permissive execution roles
aws lambda get-function --function-name $FUNC | jq '.Configuration.Role'
# Then check that role's policies for wildcard permissions
```

## CIS Benchmark Quick Check

| # | Control | Check |
|---|---------|-------|
| 1.1 | Root account MFA | `aws iam get-account-summary` |
| 1.4 | No root access keys | Credential report |
| 1.10 | MFA on all IAM users | Credential report |
| 2.1 | CloudTrail enabled all regions | `describe-trails` |
| 2.6 | S3 bucket logging | `get-bucket-logging` |
| 3.1 | CloudWatch log metric filters | `describe-metric-filters` |
| 4.1 | No security groups with 0.0.0.0/0 to port 22 | `describe-security-groups` |
| 4.2 | No security groups with 0.0.0.0/0 to port 3389 | Same |
| 5.1 | VPC flow logs enabled | `describe-flow-logs` |

## Report Template

```markdown
## Cloud Security Assessment Report

**Cloud Provider**: [AWS/Azure/GCP/Multi]
**Account/Project**: [ID]
**Date**: [date]
**Scope**: [What was assessed]

### Executive Summary
[2-3 sentences: posture assessment, critical findings count]

### Findings by Severity

| # | Finding | Severity | Resource | Remediation |
|---|---------|----------|----------|-------------|
| 1 | Public S3 bucket | CRITICAL | s3://data-bucket | Set ACL to private |
| 2 | Root account no MFA | CRITICAL | Root | Enable MFA |

### CIS Benchmark Compliance
| Section | Pass | Fail | N/A |
|---------|------|------|-----|
| IAM | 12 | 3 | 0 |
| Logging | 5 | 1 | 0 |
| Network | 8 | 2 | 1 |

### Recommendations
1. [Immediate: fix critical findings]
2. [Short-term: implement monitoring]
3. [Long-term: adopt Infrastructure as Code with security guardrails]
```

## Integration with Agentic Substrate

- Extends `@security-auditor` with cloud-specific checks
- Works with `@devops-engineer` for IaC security review
- Findings feed `@secdevops-engineer` CI/CD pipeline
- `@incident-commander` uses for cloud incident containment
- Risk scores feed `jira-automation` for issue tracking

## Source
Methodology adapted from mukul975/Anthropic-Cybersecurity-Skills cloud security domain (60 skills), CIS Benchmarks, and AWS/Azure/GCP security best practices.
