---
name: threat-hunting
description: "Proactive threat hunting using Sigma detection rules, MITRE ATT&CK mapping, and log analysis. Identifies IOCs, suspicious patterns, and lateral movement in system logs, network traffic, and application telemetry."
auto_invoke: false
tags: [security, threat-hunting, sigma, mitre-attack, soc, dfir]
---

# Threat Hunting Skill

Proactive threat hunting methodology using Sigma detection rules and MITRE ATT&CK framework. Extends the security-auditor agent with offensive detection capabilities.

## When to Invoke

- User requests threat hunting or IOC analysis
- Security audit reveals suspicious patterns needing deeper investigation
- Incident response requires log correlation and attack chain reconstruction
- `/security-audit` findings need MITRE ATT&CK mapping

## Sigma Rules Methodology

### Step 1: Define the Hunt Hypothesis

Before searching logs, define what you're looking for:

```
HYPOTHESIS: [What attacker behavior are we looking for?]
ATT&CK TACTIC: [TA0001-TA0043]
ATT&CK TECHNIQUE: [T1XXX.XXX]
DATA SOURCES: [Which logs/telemetry to analyze]
EXPECTED IOCs: [What would confirm the hypothesis]
```

### Step 2: Write Sigma Detection Rules

Sigma is a generic signature format for SIEM systems. Write rules in YAML:

```yaml
title: Suspicious PowerShell Download Cradle
id: 6e897651-f157-4d91-af3d-bf5f0a5e4bae
status: experimental
description: Detects PowerShell download cradles commonly used by attackers
references:
  - https://attack.mitre.org/techniques/T1059/001/
author: Security Team
date: 2026/04/13
tags:
  - attack.execution
  - attack.t1059.001
logsource:
  category: process_creation
  product: windows
detection:
  selection_powershell:
    CommandLine|contains:
      - 'Invoke-WebRequest'
      - 'Invoke-Expression'
      - 'IEX'
      - 'Net.WebClient'
      - 'DownloadString'
      - 'DownloadFile'
      - 'Start-BitsTransfer'
  selection_encoded:
    CommandLine|contains:
      - '-enc'
      - '-EncodedCommand'
      - 'FromBase64String'
  condition: selection_powershell or selection_encoded
  falsepositives:
    - Legitimate admin scripts
    - Software deployment tools
  level: high
```

### Step 3: Common Hunt Patterns

#### Credential Access (T1003)
```yaml
# Hunt for credential dumping
detection:
  selection:
    - CommandLine|contains:
      - 'mimikatz'
      - 'sekurlsa'
      - 'lsadump'
      - 'procdump'
      - 'comsvcs.dll'
    - TargetFilename|endswith:
      - '\lsass.dmp'
      - '\lsass.zip'
```

#### Lateral Movement (T1021)
```yaml
# Hunt for lateral movement via RDP/SMB/WinRM
detection:
  selection_rdp:
    EventID: 4624
    LogonType: 10
  selection_smb:
    EventID: 5140
    ShareName|contains: '$'
  selection_winrm:
    EventID: 4624
    LogonType: 3
    AuthenticationPackageName: 'Negotiate'
  condition: selection_rdp or selection_smb or selection_winrm
```

#### Persistence (T1053, T1547)
```yaml
# Hunt for persistence mechanisms
detection:
  selection_scheduled_task:
    CommandLine|contains:
      - 'schtasks'
      - 'at.exe'
  selection_registry:
    TargetObject|contains:
      - 'CurrentVersion\Run'
      - 'CurrentVersion\RunOnce'
  selection_service:
    CommandLine|contains:
      - 'sc create'
      - 'New-Service'
  condition: selection_scheduled_task or selection_registry or selection_service
```

#### Data Exfiltration (T1048)
```yaml
# Hunt for data exfiltration indicators
detection:
  selection_dns:
    QueryName|endswith:
      - '.duckdns.org'
      - '.ngrok.io'
      - '.serveo.net'
  selection_large_upload:
    dst_port:
      - 443
      - 80
    bytes_out|gt: 10485760  # 10MB+
  selection_encoding:
    CommandLine|contains:
      - 'certutil -encode'
      - 'base64'
      - 'tar czf'
```

### Step 4: MITRE ATT&CK Mapping

Map all findings to the ATT&CK matrix:

| Phase | Tactic | ID | What to Hunt |
|-------|--------|----|-------------|
| Initial Access | Phishing | T1566 | Email attachments, links, macro-enabled docs |
| Execution | PowerShell | T1059.001 | Encoded commands, download cradles |
| Persistence | Registry Run Keys | T1547.001 | New autorun entries |
| Privilege Escalation | Token Manipulation | T1134 | Token theft, impersonation |
| Defense Evasion | Indicator Removal | T1070 | Log clearing, timestomping |
| Credential Access | OS Credential Dumping | T1003 | LSASS access, SAM extraction |
| Discovery | Network Service Scan | T1046 | Port scanning, service enumeration |
| Lateral Movement | Remote Services | T1021 | RDP, SMB, WinRM, SSH |
| Collection | Data Staged | T1074 | Files copied to staging directories |
| Exfiltration | Exfil Over C2 | T1041 | Large outbound transfers, DNS tunneling |

### Step 5: Hunt Report Format

```markdown
## Threat Hunt Report

**Hunt ID**: TH-YYYY-MM-DD-NNN
**Hypothesis**: [What we looked for]
**ATT&CK Mapping**: [Tactic] / [Technique]
**Time Range**: [Start] - [End]
**Data Sources**: [Logs analyzed]

### Findings

| # | IOC | Type | Severity | ATT&CK | Evidence |
|---|-----|------|----------|--------|----------|
| 1 | [indicator] | [IP/Hash/Domain/Behavior] | [CRITICAL/HIGH/MEDIUM/LOW] | [T1XXX] | [Log source:line] |

### Sigma Rules Used
- [Rule title] (rule ID)

### Recommendations
1. [Immediate action]
2. [Detection improvement]
3. [Prevention measure]

### False Positives Investigated
- [What looked suspicious but was benign, and why]
```

## Integration with Agentic Substrate

- Works alongside `@security-auditor` for code-level findings
- Complements `@brahma-investigator` for root cause analysis during incidents
- Use with `@incident-commander` during active incident response
- Sigma rules can inform `@secdevops-engineer` SAST/DAST pipeline rules

## Source
Methodology adapted from jthack/threat-hunting-with-sigma-rules-skill and MITRE ATT&CK framework v15.
