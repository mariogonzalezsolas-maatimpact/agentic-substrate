---
name: supply-chain-audit
description: "Audit dependency supply chain for security risks. Analyzes package provenance, typosquatting, dependency confusion, maintainer trust, known vulnerabilities, and license compliance. Generates SBOM-aware risk reports."
auto_invoke: false
tags: [security, supply-chain, dependencies, sbom, vulnerabilities, audit]
---

# Supply Chain Risk Audit Skill

Systematic audit of project dependency supply chain for security risks including typosquatting, dependency confusion, maintainer abandonment, and known vulnerabilities.

## When to Invoke

- Adding new dependencies to a project
- Security audit of existing dependency tree
- Incident response involving compromised packages
- Compliance review requiring SBOM generation
- `/security-audit` findings flag dependency risks

## Audit Protocol

### Step 1: Dependency Inventory

```bash
# Node.js
npm ls --all --json > deps.json
npm audit --json > audit.json

# Python
pip freeze > requirements.txt
pip-audit --format json > audit.json
safety check --json > safety.json

# Go
go list -m all > deps.txt
govulncheck ./... > vulns.txt

# Rust
cargo tree > deps.txt
cargo audit --json > audit.json
```

### Step 2: Risk Assessment Matrix

For each dependency, evaluate:

| Risk Factor | Score 0-3 | How to Check |
|-------------|-----------|-------------|
| **Known CVEs** | 0=none, 3=critical | `npm audit`, `pip-audit`, `cargo audit` |
| **Maintainer trust** | 0=org-backed, 3=abandoned | GitHub activity, bus factor |
| **Popularity** | 0=10K+ weekly, 3=<100 weekly | npm/PyPI download stats |
| **Age** | 0=>3yr, 3=<3mo | Package registry publish date |
| **Dependency depth** | 0=0 transitive, 3=50+ | `npm ls --all`, `pip-tree` |
| **Typosquat risk** | 0=unique name, 3=similar to popular | Name similarity analysis |
| **Scope** | 0=devDep only, 3=runtime+network | Package.json section, actual usage |
| **Permissions** | 0=pure compute, 3=fs+net+exec | Install scripts, native addons |

**Risk score**: Sum all factors. 0-6 LOW, 7-12 MEDIUM, 13-18 HIGH, 19-24 CRITICAL.

### Step 3: Typosquatting Detection

Check for name confusion attacks:

```
Target package: "lodash"
Potential typosquats: "1odash", "lodash-", "lodassh", "lodahs"

Target: "express"
Potential: "expres", "expresss", "ex-press"
```

**Detection rules**:
- Character substitution (l/1, o/0, rn/m)
- Character omission/addition
- Hyphen insertion/removal
- Scope confusion (@scope/pkg vs @sccope/pkg)

### Step 4: Dependency Confusion Check

Verify no internal package names clash with public registries:

```bash
# Check if internal package exists on npm public registry
npm view @company/internal-pkg 2>&1

# If it DOES exist publicly: CRITICAL risk
# Attacker could publish higher version to hijack
```

**Mitigations**:
- Use scoped packages (@company/pkg)
- Configure registry allowlists in .npmrc
- Pin exact versions (no ^/~)
- Use lockfiles and verify integrity hashes

### Step 5: Install Script Analysis

```bash
# List packages with install scripts
npm ls --json | jq '.dependencies | to_entries[] | select(.value.scripts.preinstall or .value.scripts.postinstall)'

# Inspect suspicious scripts
cat node_modules/suspicious-pkg/package.json | jq '.scripts'
```

**Red flags**:
- `preinstall`/`postinstall` scripts that download binaries
- Scripts that access `~/.ssh`, `~/.aws`, `~/.npmrc`
- Obfuscated JavaScript in install scripts
- Network calls during installation

### Step 6: License Compliance

| License | Commercial OK | Copyleft Risk | Notes |
|---------|--------------|---------------|-------|
| MIT | Yes | None | Most permissive |
| Apache-2.0 | Yes | None | Patent grant |
| BSD-2/3 | Yes | None | Permissive |
| ISC | Yes | None | Simplified MIT |
| GPL-2.0/3.0 | Caution | HIGH | Viral copyleft |
| LGPL-2.1/3.0 | Yes (if linked) | Medium | Library exception |
| AGPL-3.0 | Caution | CRITICAL | Network use triggers |
| SSPL | No (usually) | CRITICAL | MongoDB-style |
| Unlicense/WTFPL | Yes | None | But unpredictable |

```bash
# Scan licenses
npx license-checker --json > licenses.json
pip-licenses --format json > licenses.json
```

### Step 7: Report

```markdown
## Supply Chain Risk Report

**Project**: [name]
**Date**: [date]
**Dependencies**: [direct] direct, [transitive] transitive
**Tool**: [npm audit / pip-audit / cargo audit]

### Critical Findings

| # | Package | Risk | Score | Issue | Remediation |
|---|---------|------|-------|-------|-------------|
| 1 | pkg@1.0 | CVE-2024-XXXX | CRITICAL | RCE in parser | Update to 1.0.1 |
| 2 | old-pkg@0.1 | Abandoned | HIGH | No commits in 2yr | Replace with alt-pkg |

### SBOM Summary

| Category | Count |
|----------|-------|
| Direct dependencies | N |
| Transitive dependencies | N |
| Known vulnerabilities | N (C critical, H high, M medium, L low) |
| Outdated packages | N |
| Deprecated packages | N |
| Copyleft licenses | N |

### Recommendations
1. [Immediate: patch critical CVEs]
2. [Short-term: replace abandoned packages]
3. [Long-term: implement dependency policy]
```

## Integration with Agentic Substrate

- Extends `@secdevops-engineer` SBOM capabilities
- Feeds findings to `@security-auditor` for code-level review
- Works with `@devops-engineer` for CI/CD dependency scanning
- Risk scores feed `jira-automation` for issue creation

## Source
Methodology adapted from trailofbits/skills supply-chain-risk-auditor and OWASP Dependency-Check guidelines.
