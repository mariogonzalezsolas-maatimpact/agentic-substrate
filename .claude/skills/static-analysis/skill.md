---
name: static-analysis
description: "Static analysis toolkit covering Semgrep, CodeQL, Bandit, ESLint security plugins, and SARIF result parsing. Configures analyzers, interprets findings, triages false positives, and integrates with CI/CD."
auto_invoke: false
tags: [security, sast, codeql, semgrep, bandit, eslint, static-analysis]
---

# Static Analysis Toolkit

Comprehensive static analysis methodology covering tool selection, configuration, result interpretation, and CI/CD integration.

## When to Invoke

- Setting up SAST in a new project
- Interpreting static analysis results
- Triaging and fixing findings
- Configuring security linters in CI/CD
- False positive analysis and rule tuning

## Tool Selection by Language

| Language | Primary | Secondary | Linter |
|----------|---------|-----------|--------|
| Python | Semgrep | Bandit | Ruff, Pylint |
| JavaScript/TS | Semgrep | ESLint security | ESLint |
| Go | Semgrep | gosec | staticcheck |
| Java | Semgrep | CodeQL | SpotBugs, PMD |
| C/C++ | CodeQL | cppcheck | clang-tidy |
| Rust | Semgrep | cargo-audit | Clippy |
| Ruby | Semgrep | Brakeman | RuboCop |
| PHP | Semgrep | Psalm | PHPStan |

## Quick Start by Tool

### Semgrep
```bash
# Install
pip install semgrep

# Run with recommended rulesets
semgrep --config auto .
semgrep --config p/owasp-top-ten .
semgrep --config p/security-audit .

# Run specific rules
semgrep --config p/python-security .
semgrep --config p/javascript-security .

# Output SARIF for CI
semgrep --config auto --sarif -o results.sarif .
```

### CodeQL
```bash
# Create database
codeql database create codeql-db --language=javascript --source-root=.

# Run security queries
codeql database analyze codeql-db codeql/javascript-queries:Security --format=sarif-latest --output=results.sarif

# Available query packs
# codeql/python-queries, codeql/java-queries, codeql/cpp-queries
```

### Bandit (Python)
```bash
# Install
pip install bandit

# Run
bandit -r ./src -f json -o bandit.json
bandit -r ./src --severity-level high --confidence-level high
```

### ESLint Security (JavaScript)
```bash
# Install plugins
npm install --save-dev eslint-plugin-security eslint-plugin-no-unsanitized

# .eslintrc.json
{
  "plugins": ["security", "no-unsanitized"],
  "extends": ["plugin:security/recommended-legacy"],
  "rules": {
    "security/detect-object-injection": "warn",
    "security/detect-non-literal-regexp": "warn",
    "security/detect-eval-with-expression": "error",
    "no-unsanitized/method": "error",
    "no-unsanitized/property": "error"
  }
}
```

### gosec (Go)
```bash
# Install
go install github.com/securego/gosec/v2/cmd/gosec@latest

# Run
gosec -fmt json -out results.json ./...
```

## SARIF Result Processing

SARIF (Static Analysis Results Interchange Format) is the standard output:

```bash
# View SARIF summary
cat results.sarif | jq '.runs[0].results | length'  # Total findings
cat results.sarif | jq '.runs[0].results | group_by(.level) | map({level: .[0].level, count: length})'
```

### Triage Workflow

```
Finding received
    |
    v
Is it in new/modified code? --NO--> Backlog (lower priority)
    |YES
    v
Is it a true positive? --NO--> Mark as false positive + document reason
    |YES
    v
Severity CRITICAL/HIGH? --YES--> Fix immediately, block merge
    |NO
    v
Add to sprint backlog with priority tag
```

### False Positive Indicators

| Signal | Likely FP? | Action |
|--------|-----------|--------|
| Constant/literal value flagged as "user input" | Yes | Suppress with comment |
| Test file flagged for hardcoded credentials | Yes | Exclude test dirs |
| Sanitized input still flagged | Maybe | Verify sanitization is correct |
| Framework provides built-in protection | Yes | Configure tool to recognize framework |
| Dead code path | Yes | Remove dead code instead |

### Suppression (when justified)

```python
# nosemgrep: hardcoded-api-key  -- Test fixture, not a real key
TEST_KEY = "test-key-not-real"

# nosec B101  -- Assert used for test assertions, not production logic
assert result is not None
```

**Rule**: Every suppression MUST have a comment explaining why.

## CI/CD Integration

### GitHub Actions
```yaml
- name: Semgrep
  uses: semgrep/semgrep-action@v1
  with:
    config: >-
      p/security-audit
      p/owasp-top-ten
  env:
    SEMGREP_APP_TOKEN: ${{ secrets.SEMGREP_APP_TOKEN }}
```

### Quality Gate
```
PASS: 0 critical, 0 high findings in new code
WARN: Medium findings in new code (non-blocking)
FAIL: Any critical or high finding in new code -> block merge
```

## Integration with Agentic Substrate

- `@secdevops-engineer` configures SAST in CI/CD pipelines
- `@security-auditor` interprets findings during code review
- `semgrep-rules` skill creates custom detection rules
- `@review-coordinator` runs quick scans during code review
- Findings feed `jira-automation` for issue tracking
- `threat-hunting` skill uses findings for pattern analysis

## Source
Methodology adapted from trailofbits/skills static-analysis toolkit and OWASP SAST guidelines.
