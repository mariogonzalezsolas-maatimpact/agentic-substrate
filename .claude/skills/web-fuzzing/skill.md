---
name: web-fuzzing
description: "Web application fuzzing methodology using ffuf, directory brute-forcing, parameter discovery, virtual host enumeration, and API endpoint fuzzing. Identifies hidden attack surface during security assessments."
auto_invoke: false
tags: [security, fuzzing, ffuf, pentesting, recon, web-security]
---

# Web Fuzzing Skill

Structured web fuzzing methodology for discovering hidden endpoints, parameters, virtual hosts, and attack surface during authorized security assessments.

## When to Invoke

- Authorized penetration testing engagements
- Security audit requiring attack surface discovery
- API endpoint enumeration
- Hidden parameter and directory discovery
- Virtual host enumeration

**Requirement**: Always confirm authorization before fuzzing. Never fuzz without explicit written permission.

## Fuzzing Methodology

### Step 1: Scope & Authorization

```
TARGET: [URL/domain]
AUTHORIZATION: [Written permission reference]
SCOPE: [In-scope paths/subdomains]
EXCLUSIONS: [Do not fuzz these paths]
RATE LIMIT: [Requests per second]
WORDLISTS: [Which wordlists to use]
```

### Step 2: Directory & File Discovery

```bash
# Basic directory brute-force
ffuf -u https://target.com/FUZZ -w /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt -mc 200,301,302,403

# File extension fuzzing
ffuf -u https://target.com/FUZZ -w /usr/share/seclists/Discovery/Web-Content/raft-medium-files.txt -e .php,.asp,.aspx,.jsp,.html,.js,.json,.xml,.txt,.bak,.old,.config -mc 200,301,302

# Recursive discovery (depth 2)
ffuf -u https://target.com/FUZZ -w wordlist.txt -recursion -recursion-depth 2 -mc 200,301,302

# Filter by response size (remove noise)
ffuf -u https://target.com/FUZZ -w wordlist.txt -mc all -fs 4242
# -fs: filter by size | -fw: filter by word count | -fl: filter by line count | -fc: filter by status code
```

### Step 3: Parameter Discovery

```bash
# GET parameter fuzzing
ffuf -u "https://target.com/page?FUZZ=test" -w /usr/share/seclists/Discovery/Web-Content/burp-parameter-names.txt -mc 200 -fs baseline_size

# POST parameter fuzzing
ffuf -u https://target.com/login -X POST -d "FUZZ=test" -w /usr/share/seclists/Discovery/Web-Content/burp-parameter-names.txt -H "Content-Type: application/x-www-form-urlencoded" -mc 200 -fs baseline_size

# JSON parameter fuzzing
ffuf -u https://target.com/api/endpoint -X POST -d '{"FUZZ":"test"}' -w param-wordlist.txt -H "Content-Type: application/json" -mc 200

# Header fuzzing
ffuf -u https://target.com/ -H "FUZZ: test" -w /usr/share/seclists/Discovery/Web-Content/BurpSuite-ParamMiner/uppercase-headers -mc 200 -fs baseline_size
```

### Step 4: Virtual Host Discovery

```bash
# Subdomain/vhost enumeration
ffuf -u https://target.com -H "Host: FUZZ.target.com" -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt -mc 200 -fs default_page_size

# IP-based vhost discovery
ffuf -u http://10.0.0.1 -H "Host: FUZZ.target.com" -w subdomains.txt -mc 200
```

### Step 5: API Endpoint Fuzzing

```bash
# REST API path discovery
ffuf -u https://api.target.com/v1/FUZZ -w /usr/share/seclists/Discovery/Web-Content/api/api-endpoints.txt -mc 200,201,204,401,403

# API version discovery
ffuf -u https://api.target.com/vFUZZ/users -w <(seq 1 10) -mc 200,201,401

# GraphQL introspection
ffuf -u https://target.com/FUZZ -w <(echo -e "graphql\ngraphiql\naltair\nplayground\nconsole\nquery") -mc 200

# Method fuzzing
ffuf -u https://target.com/api/resource -X FUZZ -w <(echo -e "GET\nPOST\nPUT\nDELETE\nPATCH\nOPTIONS\nHEAD\nTRACE") -mc all -fc 405
```

### Step 6: Authentication Bypass Fuzzing

```bash
# Path traversal in auth-protected areas
ffuf -u https://target.com/admin/FUZZ -w wordlist.txt -mc 200,301,302 -H "Cookie: session=guest_token"

# Auth header bypass
ffuf -u https://target.com/admin -H "X-Forwarded-For: FUZZ" -w <(echo -e "127.0.0.1\nlocalhost\n10.0.0.1\n::1") -mc 200
ffuf -u https://target.com/admin -H "X-Original-URL: FUZZ" -w admin-paths.txt -mc 200
```

### Step 7: Results Analysis

```markdown
## Fuzzing Report

**Target**: [URL]
**Date**: [Assessment date]
**Authorization**: [Reference]
**Tool**: ffuf [version]
**Wordlists**: [List used]

### Attack Surface Discovered

| # | Path/Parameter | Method | Status | Size | Significance |
|---|---------------|--------|--------|------|-------------|
| 1 | /admin/backup.sql | GET | 200 | 45MB | Database backup exposed |
| 2 | /api/v1/internal | GET | 401 | 142 | Undocumented internal API |
| 3 | debug=true param | GET | 200 | 8KB | Debug mode enabled |

### Risk Assessment

| Finding | CVSS | Severity | Remediation |
|---------|------|----------|-------------|
| Exposed backup | 9.1 | CRITICAL | Remove file, restrict access |
| Internal API | 6.5 | MEDIUM | Add authentication |

### Recommendations
1. [Immediate fixes]
2. [WAF rules to add]
3. [Monitoring to implement]
```

## Wordlist Recommendations

| Purpose | Wordlist | Source |
|---------|----------|-------|
| Directories | raft-medium-directories.txt | SecLists |
| Files | raft-medium-files.txt | SecLists |
| Parameters | burp-parameter-names.txt | SecLists |
| Subdomains | subdomains-top1million-5000.txt | SecLists |
| API paths | api-endpoints.txt | SecLists |
| Passwords | rockyou.txt | SecLists |
| Common files | quickhits.txt | SecLists |

## Integration with Agentic Substrate

- Feeds discovered endpoints to `@security-auditor` for vulnerability assessment
- IOCs feed into `threat-hunting` skill for detection rules
- Discovered API surface feeds `@api-designer` for documentation gaps
- Works with `@secdevops-engineer` to add discovered paths to DAST scans

## Source
Methodology based on ffuf best practices and adapted from jthack/ffuf_claude_skill patterns.
