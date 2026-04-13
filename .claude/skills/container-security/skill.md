---
name: container-security
description: "Container and Kubernetes security assessment. Covers image scanning, K8s RBAC audit, pod security standards, network policies, runtime monitoring with Falco, and container forensics."
auto_invoke: false
tags: [security, containers, kubernetes, docker, k8s, falco, image-scanning]
---

# Container Security Skill

Systematic container and Kubernetes security assessment covering build-time, deploy-time, and runtime security controls.

## When to Invoke

- Docker image security review
- Kubernetes cluster security audit
- Container escape risk assessment
- Pod security policy/standards review
- Container forensics during incidents

## Assessment Protocol

### Phase 1: Image Security

#### Dockerfile Hardening Checklist
```dockerfile
# Use specific, minimal base image (not :latest)
FROM python:3.12-slim AS builder

# Run as non-root
RUN addgroup --system app && adduser --system --group app
USER app

# No secrets in build args or ENV
# Use multi-stage builds to exclude build tools
# Pin package versions
# Use COPY, not ADD (ADD has URL fetch + tar extraction)
# Set read-only filesystem where possible
```

#### Image Scanning
```bash
# Trivy (comprehensive)
trivy image --severity HIGH,CRITICAL myapp:latest
trivy image --format json --output scan.json myapp:latest

# Grype (anchore)
grype myapp:latest --only-fixed --fail-on high

# Docker Scout
docker scout cves myapp:latest

# Snyk
snyk container test myapp:latest
```

#### Image Analysis
```bash
# Check image layers for secrets
docker history myapp:latest --no-trunc
dive myapp:latest  # Interactive layer explorer

# Check for SUID/SGID binaries
docker run --rm --entrypoint="" myapp:latest find / -perm /6000 -type f 2>/dev/null

# Verify image signature
cosign verify --key cosign.pub myapp:latest
```

**Red flags in images**:
- Running as root (UID 0)
- SUID/SGID binaries present
- Package managers (apt, pip) in production image
- Shell (/bin/sh, /bin/bash) in minimal images
- Secrets in environment variables or layers
- Base image with known CVEs

### Phase 2: Kubernetes RBAC Audit

```bash
# List cluster-admin bindings (should be minimal)
kubectl get clusterrolebindings -o json | jq '.items[] | select(.roleRef.name=="cluster-admin") | .subjects'

# Find overly permissive roles
kubectl get roles,clusterroles -A -o json | jq '.items[] | select(.rules[].resources[] == "*" and .rules[].verbs[] == "*") | .metadata.name'

# Check service account tokens automounted
kubectl get pods -A -o json | jq '.items[] | select(.spec.automountServiceAccountToken != false) | .metadata.name'

# List privileged pods
kubectl get pods -A -o json | jq '.items[] | select(.spec.containers[].securityContext.privileged == true) | {ns: .metadata.namespace, name: .metadata.name}'

# Check who can exec into pods
kubectl auth can-i create pods/exec --as=system:serviceaccount:default:default
```

### Phase 3: Pod Security Standards

| Level | Control | Check |
|-------|---------|-------|
| Baseline | No privileged containers | `privileged: false` |
| Baseline | No hostPID/hostNetwork | `hostPID: false, hostNetwork: false` |
| Baseline | No host path volumes | No `hostPath` volumes |
| Restricted | Run as non-root | `runAsNonRoot: true` |
| Restricted | Drop all capabilities | `drop: ["ALL"]` |
| Restricted | Read-only root filesystem | `readOnlyRootFilesystem: true` |
| Restricted | No privilege escalation | `allowPrivilegeEscalation: false` |
| Restricted | Seccomp profile set | `seccompProfile.type: RuntimeDefault` |

#### Secure Pod Template
```yaml
apiVersion: v1
kind: Pod
spec:
  automountServiceAccountToken: false
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
    fsGroup: 1000
    seccompProfile:
      type: RuntimeDefault
  containers:
    - name: app
      image: myapp:1.0.0@sha256:abc123...  # Pin by digest
      securityContext:
        allowPrivilegeEscalation: false
        readOnlyRootFilesystem: true
        capabilities:
          drop: ["ALL"]
      resources:
        limits:
          memory: "256Mi"
          cpu: "500m"
        requests:
          memory: "128Mi"
          cpu: "250m"
```

### Phase 4: Network Policies

```yaml
# Default deny all ingress
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
spec:
  podSelector: {}
  policyTypes:
    - Ingress

# Allow only specific communication
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-api
spec:
  podSelector:
    matchLabels:
      app: api
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: frontend
      ports:
        - port: 8080
```

```bash
# Check if network policies exist
kubectl get networkpolicies -A

# Check for pods without network policies
kubectl get pods -A -o json | jq -r '.items[].metadata | "\(.namespace)/\(.name)"' | while read pod; do
  ns=$(echo $pod | cut -d/ -f1)
  policies=$(kubectl get networkpolicies -n $ns 2>/dev/null | wc -l)
  [ "$policies" -le 1 ] && echo "NO POLICY: $pod"
done
```

### Phase 5: Runtime Security (Falco)

```yaml
# Falco rule: detect shell in container
- rule: Terminal shell in container
  desc: Detect shell activity in a container
  condition: >
    spawned_process and container and
    proc.name in (bash, sh, zsh, dash) and
    not proc.pname in (cron, supervisord)
  output: "Shell spawned in container (user=%user.name container=%container.name command=%proc.cmdline)"
  priority: WARNING

# Falco rule: sensitive file access
- rule: Read sensitive file in container
  desc: Detect reading of sensitive files
  condition: >
    open_read and container and
    fd.name in (/etc/shadow, /etc/passwd, /proc/1/environ)
  output: "Sensitive file read (file=%fd.name container=%container.name)"
  priority: ERROR
```

### Phase 6: Container Forensics

```bash
# Capture running container state
docker export $CONTAINER_ID > container_dump.tar
docker logs $CONTAINER_ID > container_logs.txt 2>&1
docker inspect $CONTAINER_ID > container_inspect.json

# Compare against original image
docker diff $CONTAINER_ID  # Shows filesystem changes

# Memory dump (if available)
docker checkpoint create $CONTAINER_ID checkpoint1

# K8s pod forensics
kubectl logs $POD --all-containers > pod_logs.txt
kubectl describe pod $POD > pod_describe.txt
kubectl exec $POD -- cat /proc/1/environ | tr '\0' '\n'  # Environment
```

## Report Template

```markdown
## Container Security Assessment

**Cluster**: [name/context]
**Date**: [date]
**Nodes**: [count]
**Namespaces**: [count]
**Pods**: [count]

### Findings

| # | Finding | Severity | Resource | Remediation |
|---|---------|----------|----------|-------------|
| 1 | Privileged container | CRITICAL | ns/pod | Set privileged: false |
| 2 | No network policies | HIGH | namespace | Add default-deny |

### Pod Security Compliance
| Level | Compliant | Non-compliant |
|-------|-----------|---------------|
| Baseline | 45 | 3 |
| Restricted | 30 | 18 |

### Image Vulnerability Summary
| Severity | Count |
|----------|-------|
| Critical | 2 |
| High | 8 |
| Medium | 15 |
```

## Integration with Agentic Substrate

- Extends `@devops-engineer` with security-specific K8s checks
- Feeds `@secdevops-engineer` container scanning pipeline
- Works with `@security-auditor` for full-stack assessment
- `@incident-commander` uses forensics section during incidents
- `@brahma-deployer` validates pod security before deployment

## Source
Methodology adapted from mukul975/Anthropic-Cybersecurity-Skills container security domain (30 skills), CIS Kubernetes Benchmark, and NSA/CISA Kubernetes Hardening Guide.
