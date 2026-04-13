---
name: semgrep-rules
description: "Create, test, and refine custom Semgrep rules for vulnerability detection. Covers pattern writing, metavariables, taint tracking, autofix generation, and rule testing with semgrep --test."
auto_invoke: false
tags: [security, semgrep, sast, static-analysis, vulnerability-detection, rules]
---

# Semgrep Rule Creator Skill

Create custom Semgrep rules for detecting security vulnerabilities, code anti-patterns, and enforcing coding standards.

## When to Invoke

- Creating custom SAST rules for project-specific patterns
- Detecting recurring vulnerability patterns
- Enforcing security coding standards
- Building detection rules from incident post-mortems
- Extending `@secdevops-engineer` SAST pipeline

## Rule Writing Protocol

### Step 1: Define the Vulnerability Pattern

```
VULN: [What vulnerability are we detecting?]
CWE: [CWE-XXX]
SEVERITY: [ERROR | WARNING | INFO]
LANGUAGES: [python, javascript, go, java, etc.]
EXAMPLE BAD: [Code that should trigger]
EXAMPLE GOOD: [Code that should NOT trigger]
```

### Step 2: Write the Rule

```yaml
rules:
  - id: hardcoded-jwt-secret
    patterns:
      - pattern: jwt.sign($PAYLOAD, "...", ...)
    message: >
      JWT signed with hardcoded secret string. Use environment
      variables or a secret manager for signing keys.
    severity: ERROR
    languages: [javascript, typescript]
    metadata:
      cwe:
        - "CWE-798: Use of Hard-coded Credentials"
      owasp:
        - "A07:2021 - Identification and Authentication Failures"
      confidence: HIGH
```

### Step 3: Pattern Syntax Reference

#### Basic Patterns
```yaml
# Exact match
pattern: eval($X)

# Ellipsis (match anything between)
pattern: app.get("...", ..., $HANDLER)

# Metavariable
pattern: $FUNC($INPUT)

# Deep expression match
pattern: <... $EXPR ...>
```

#### Pattern Combinators
```yaml
# All must match
patterns:
  - pattern: $X.query($SQL)
  - pattern-not: $X.query($SQL, $PARAMS)
  - metavariable-regex:
      metavariable: $SQL
      regex: .*\+.*

# Any can match
pattern-either:
  - pattern: eval($X)
  - pattern: Function($X)
  - pattern: setTimeout($X, ...)

# Inside a context
patterns:
  - pattern: $PASS = "..."
  - pattern-inside: |
      def $FUNC(...):
        ...
```

#### Taint Tracking
```yaml
rules:
  - id: sql-injection
    mode: taint
    pattern-sources:
      - patterns:
          - pattern: request.$METHOD.$PARAM
    pattern-sinks:
      - patterns:
          - pattern: cursor.execute($QUERY, ...)
          - focus-metavariable: $QUERY
    pattern-sanitizers:
      - patterns:
          - pattern: sanitize($X)
    message: User input flows to SQL query without sanitization
    severity: ERROR
    languages: [python]
```

### Common Security Rules

#### SQL Injection (Python)
```yaml
- id: sql-injection-format-string
  patterns:
    - pattern-either:
        - pattern: cursor.execute(f"...{$VAR}...")
        - pattern: cursor.execute("..." + $VAR + "...")
        - pattern: cursor.execute("...%s..." % $VAR)
    - pattern-not-inside: |
        $VAR = "..."
  message: Possible SQL injection via string formatting
  severity: ERROR
  languages: [python]
```

#### XSS (JavaScript)
```yaml
- id: dangerous-innerhtml
  patterns:
    - pattern: $EL.innerHTML = $VALUE
    - pattern-not: $EL.innerHTML = "..."
  message: Setting innerHTML with dynamic value may cause XSS
  severity: WARNING
  languages: [javascript, typescript]
```

#### Command Injection
```yaml
- id: command-injection-subprocess
  patterns:
    - pattern: subprocess.call($CMD, shell=True, ...)
    - pattern-not: subprocess.call("...", shell=True, ...)
  message: subprocess with shell=True and dynamic input allows command injection
  severity: ERROR
  languages: [python]
```

#### Insecure Crypto
```yaml
- id: weak-hash-algorithm
  pattern-either:
    - pattern: hashlib.md5(...)
    - pattern: hashlib.sha1(...)
  message: MD5/SHA1 are cryptographically weak. Use SHA-256+ for security.
  severity: WARNING
  languages: [python]
```

#### Hardcoded Secrets
```yaml
- id: hardcoded-api-key
  patterns:
    - pattern: $KEY = "..."
    - metavariable-regex:
        metavariable: $KEY
        regex: (?i)(api_key|apikey|secret|password|token|auth)
    - metavariable-regex:
        metavariable: $...VALUE
        regex: .{8,}
  message: Potential hardcoded secret in variable $KEY
  severity: ERROR
  languages: [python, javascript, typescript, go, java]
```

### Step 4: Test the Rule

Create test file alongside rule:

```python
# test_hardcoded_secret.py

# ruleid: hardcoded-api-key
API_KEY = "sk-1234567890abcdef"

# ok: hardcoded-api-key
API_KEY = os.environ["API_KEY"]

# ok: hardcoded-api-key
DEBUG = "true"
```

Run tests:
```bash
semgrep --test --config rules/ tests/
```

### Step 5: Autofix (Optional)

```yaml
- id: use-parameterized-query
  patterns:
    - pattern: cursor.execute(f"SELECT * FROM users WHERE id = {$ID}")
  fix: cursor.execute("SELECT * FROM users WHERE id = %s", ($ID,))
  message: Use parameterized queries to prevent SQL injection
  severity: ERROR
  languages: [python]
```

## Integration with Agentic Substrate

- `@secdevops-engineer` integrates rules into CI/CD SAST pipeline
- `@security-auditor` uses custom rules during code review
- `@review-coordinator` can run Semgrep as part of review
- Findings feed `jira-automation` for issue tracking
- Post-incident rules prevent vulnerability recurrence

## Source
Methodology adapted from trailofbits/skills semgrep-rule-creator and Semgrep documentation.
