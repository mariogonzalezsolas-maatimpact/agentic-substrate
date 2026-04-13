---
name: api-security
description: "API security assessment covering OWASP API Top 10 (2023), authentication/authorization testing, rate limiting validation, GraphQL security, input validation, and API abuse prevention."
auto_invoke: false
tags: [security, api, owasp, authentication, authorization, graphql, rest]
---

# API Security Skill

Systematic API security assessment based on OWASP API Security Top 10 (2023). Covers REST, GraphQL, gRPC, and WebSocket APIs.

## When to Invoke

- Security review of API endpoints
- API penetration testing (authorized)
- New API design security review
- GraphQL security assessment
- API authentication/authorization audit

## OWASP API Security Top 10 (2023)

### API1: Broken Object Level Authorization (BOLA/IDOR)

**Test**: Access resources belonging to other users by manipulating IDs.

```bash
# Get resource as User A
curl -H "Authorization: Bearer $TOKEN_A" https://api.example.com/users/123/orders

# Try accessing User B's resource with User A's token
curl -H "Authorization: Bearer $TOKEN_A" https://api.example.com/users/456/orders

# Test with sequential IDs
for id in $(seq 100 110); do
  curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer $TOKEN_A" "https://api.example.com/orders/$id"
done

# Test with UUIDs (enumerate from other endpoints)
curl -H "Authorization: Bearer $TOKEN_A" https://api.example.com/orders/$OTHER_USER_UUID
```

**Remediation**: Check object ownership on EVERY request, not just authentication.

### API2: Broken Authentication

```bash
# Test credential stuffing (should be rate-limited)
for i in $(seq 1 20); do
  curl -s -o /dev/null -w "%{http_code}" -X POST https://api.example.com/auth/login \
    -d '{"email":"test@example.com","password":"wrong'$i'"}'
done

# Test JWT weaknesses
# Decode JWT
echo $TOKEN | cut -d. -f2 | base64 -d 2>/dev/null

# Check for "alg: none" bypass
# Check for weak signing key
# Check token expiration (should be < 15min for access tokens)
# Check refresh token rotation
```

**Checklist**:
- [ ] Brute force protection (account lockout or rate limiting)
- [ ] JWT algorithm fixed server-side (no `alg: none`)
- [ ] Short-lived access tokens (< 15 min)
- [ ] Refresh token rotation
- [ ] Password complexity requirements
- [ ] MFA available

### API3: Broken Object Property Level Authorization

```bash
# Mass assignment: send extra fields
curl -X PATCH https://api.example.com/users/me \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"name":"Normal","role":"admin","isVerified":true}'

# Check response for sensitive fields exposure
curl https://api.example.com/users/me -H "Authorization: Bearer $TOKEN" | jq .
# Look for: password hashes, internal IDs, role fields, PII
```

**Remediation**: Explicit allowlist of writeable fields. Never bind request body directly to model.

### API4: Unrestricted Resource Consumption

```bash
# Test pagination abuse
curl "https://api.example.com/items?limit=999999"

# Test file upload size
dd if=/dev/zero bs=1M count=100 | curl -X POST -F "file=@-" https://api.example.com/upload

# Test GraphQL depth/complexity
curl -X POST https://api.example.com/graphql -d '{"query":"{ users { friends { friends { friends { name }}}}}"}'

# Test rate limiting
for i in $(seq 1 100); do
  curl -s -o /dev/null -w "%{http_code} " https://api.example.com/expensive-endpoint
done
```

### API5: Broken Function Level Authorization

```bash
# Test admin endpoints as regular user
curl -H "Authorization: Bearer $REGULAR_TOKEN" https://api.example.com/admin/users
curl -H "Authorization: Bearer $REGULAR_TOKEN" -X DELETE https://api.example.com/admin/users/123

# Test HTTP method switching
curl -X PUT https://api.example.com/users/123  # If GET is allowed, try PUT/DELETE
curl -X OPTIONS https://api.example.com/admin/  # Check allowed methods
```

### API6: Unrestricted Access to Sensitive Business Flows

```bash
# Test automated abuse of business logic
# Example: purchase flow without payment validation
# Example: referral system abuse
# Example: coupon code brute force

# Check for CAPTCHA/bot protection on sensitive flows
curl -X POST https://api.example.com/checkout -d '{"coupon":"FUZZ"}' -H "Authorization: Bearer $TOKEN"
```

### API7: Server-Side Request Forgery (SSRF)

```bash
# Test URL parameters for SSRF
curl "https://api.example.com/proxy?url=http://169.254.169.254/latest/meta-data/"
curl "https://api.example.com/webhook" -d '{"callback_url":"http://internal-service:8080/admin"}'

# Test with various protocols
# file:///etc/passwd
# gopher://internal:6379/_INFO
# dict://internal:11211/stats
```

### API8: Security Misconfiguration

```bash
# Check CORS
curl -v -H "Origin: https://evil.com" https://api.example.com/ 2>&1 | grep -i "access-control"

# Check security headers
curl -v https://api.example.com/ 2>&1 | grep -iE "x-content-type|x-frame|strict-transport|content-security"

# Check error verbosity
curl https://api.example.com/nonexistent 2>&1
# Should NOT reveal: stack traces, framework versions, internal paths

# Check debug endpoints
curl https://api.example.com/debug
curl https://api.example.com/metrics
curl https://api.example.com/health
curl https://api.example.com/swagger.json
curl https://api.example.com/.env
```

### API9: Improper Inventory Management

```bash
# Discover undocumented endpoints
# Check for old API versions still accessible
curl https://api.example.com/v1/users  # Deprecated but still active?
curl https://api.example.com/api/v1/users
curl https://api.example.com/internal/users

# Check for documentation exposure
curl https://api.example.com/swagger.json
curl https://api.example.com/openapi.yaml
curl https://api.example.com/graphql?query={__schema{types{name}}}
```

### API10: Unsafe Consumption of APIs

Check how the application consumes third-party APIs:
- Are responses validated before processing?
- Are redirects followed blindly?
- Is there a timeout on external API calls?
- Are external API errors handled gracefully?

## GraphQL-Specific Security

```bash
# Introspection (should be disabled in production)
curl -X POST https://api.example.com/graphql -d '{"query":"{ __schema { types { name fields { name }}}}"}'

# Depth attack
curl -X POST https://api.example.com/graphql -d '{"query":"{ users { friends { friends { friends { friends { name }}}}}}"}'

# Batch query attack
curl -X POST https://api.example.com/graphql -d '[{"query":"{ user(id:1) { name }}"}, {"query":"{ user(id:2) { name }}"}]'

# Field suggestion exploitation
curl -X POST https://api.example.com/graphql -d '{"query":"{ usr { name }}"}'
# Error might suggest: "Did you mean 'user'?"
```

**GraphQL hardening**:
- Disable introspection in production
- Set query depth limit (max 5-7)
- Set query complexity limit
- Disable batch queries or limit batch size
- Implement field-level authorization
- Use persisted queries

## Report Template

```markdown
## API Security Assessment

**API**: [name/URL]
**Version**: [v1/v2]
**Type**: [REST/GraphQL/gRPC]
**Auth**: [JWT/OAuth/API Key]
**Date**: [date]

### OWASP API Top 10 Results

| # | Vulnerability | Status | Severity | Evidence |
|---|--------------|--------|----------|----------|
| API1 | BOLA/IDOR | FAIL | CRITICAL | User A accessed User B's orders |
| API2 | Broken Auth | PASS | - | Rate limiting + JWT rotation working |
| ... | ... | ... | ... | ... |

### Recommendations
1. [Critical: fix BOLA on /orders endpoint]
2. [High: disable GraphQL introspection]
3. [Medium: add rate limiting on /auth endpoints]
```

## Integration with Agentic Substrate

- Extends `@api-designer` with security-specific review
- Complements `@security-auditor` for API-specific checks
- `web-fuzzing` skill provides endpoint discovery
- Findings feed `semgrep-rules` for custom API detection rules
- `@review-coordinator` uses during API code review

## Source
Methodology adapted from mukul975/Anthropic-Cybersecurity-Skills API security domain (28 skills) and OWASP API Security Top 10 (2023).
