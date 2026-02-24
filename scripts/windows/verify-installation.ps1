#Requires -Version 5.1
<#
.SYNOPSIS
    Verify Agentic Substrate installation on Windows

.DESCRIPTION
    Checks that all components are correctly installed and functioning.

.EXAMPLE
    .\verify-installation.ps1
#>

$ErrorActionPreference = "Continue"
$CLAUDE_TARGET = Join-Path $env:USERPROFILE ".claude"

# Colors
function Write-Pass { param([string]$Message) Write-Host "[PASS] $Message" -ForegroundColor Green }
function Write-Fail { param([string]$Message) Write-Host "[FAIL] $Message" -ForegroundColor Red }
function Write-Check { param([string]$Message) Write-Host "[CHECK] $Message" -ForegroundColor Cyan }
function Write-Info { param([string]$Message) Write-Host "[INFO] $Message" -ForegroundColor Gray }

Write-Host ""
Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host "Agentic Substrate Installation Verification" -ForegroundColor Cyan
Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host ""

$errors = 0
$warnings = 0

# ============================================================================
# 1. Check installation directory
# ============================================================================

Write-Check "Checking installation directory..."

if (Test-Path $CLAUDE_TARGET) {
    Write-Pass "Installation directory exists: $CLAUDE_TARGET"
}
else {
    Write-Fail "Installation directory not found: $CLAUDE_TARGET"
    Write-Host "Run install.ps1 or install.sh first" -ForegroundColor Yellow
    exit 1
}

# ============================================================================
# 2. Check version file
# ============================================================================

Write-Check "Checking version file..."

$versionFile = Join-Path $CLAUDE_TARGET ".agentic-substrate-version"
if (Test-Path $versionFile) {
    $version = (Get-Content $versionFile -Raw).Trim()
    Write-Pass "Version: $version"
}
else {
    Write-Fail "Version file not found"
    $errors++
}

# ============================================================================
# 3. Check manifest
# ============================================================================

Write-Check "Checking installation manifest..."

$manifestFile = Join-Path $CLAUDE_TARGET ".agentic-substrate-manifest.json"
if (Test-Path $manifestFile) {
    try {
        $manifest = Get-Content $manifestFile -Raw | ConvertFrom-Json
        $totalFiles = $manifest.managed_files.Count
        Write-Pass "Manifest found ($totalFiles managed files)"
    }
    catch {
        Write-Fail "Manifest is invalid JSON"
        $errors++
    }
}
else {
    Write-Fail "Manifest file not found"
    $errors++
}

# ============================================================================
# 4. Check agents
# ============================================================================

Write-Check "Checking agents..."

$expectedAgents = @(
    "brahma-analyzer",
    "brahma-deployer",
    "brahma-investigator",
    "brahma-monitor",
    "brahma-optimizer",
    "business-analyst",
    "chief-architect",
    "code-implementer",
    "content-strategist",
    "docs-researcher",
    "implementation-planner",
    "product-strategist",
    "security-auditor",
    "seo-strategist",
    "ux-accessibility-reviewer"
)

$agentsDir = Join-Path $CLAUDE_TARGET "agents"
$foundAgents = 0
$missingAgents = @()

foreach ($agent in $expectedAgents) {
    $agentFile = Join-Path $agentsDir "$agent.md"
    if (Test-Path $agentFile) {
        $foundAgents++
    }
    else {
        $missingAgents += $agent
    }
}

if ($foundAgents -eq $expectedAgents.Count) {
    Write-Pass "All $foundAgents agents installed"
}
else {
    Write-Fail "Missing agents: $($missingAgents -join ', ')"
    $errors++
}

# ============================================================================
# 5. Check skills
# ============================================================================

Write-Check "Checking skills..."

$expectedSkills = @(
    "context-engineering",
    "pattern-recognition",
    "planning-methodology",
    "quality-validation",
    "research-methodology"
)

$skillsDir = Join-Path $CLAUDE_TARGET "skills"
$foundSkills = 0
$missingSkills = @()

foreach ($skill in $expectedSkills) {
    $skillFile = Join-Path $skillsDir "$skill\skill.md"
    if (Test-Path $skillFile) {
        $foundSkills++
    }
    else {
        $missingSkills += $skill
    }
}

if ($foundSkills -eq $expectedSkills.Count) {
    Write-Pass "All $foundSkills skills installed"
}
else {
    Write-Fail "Missing skills: $($missingSkills -join ', ')"
    $errors++
}

# ============================================================================
# 6. Check commands
# ============================================================================

Write-Check "Checking commands..."

$expectedCommands = @(
    "circuit-breaker",
    "context",
    "do",
    "implement",
    "mode",
    "plan",
    "research",
    "review",
    "security-audit",
    "seo-audit",
    "ux-review",
    "workflow"
)

$commandsDir = Join-Path $CLAUDE_TARGET "commands"
$foundCommands = 0
$missingCommands = @()

foreach ($cmd in $expectedCommands) {
    $cmdFile = Join-Path $commandsDir "$cmd.md"
    if (Test-Path $cmdFile) {
        $foundCommands++
    }
    else {
        $missingCommands += $cmd
    }
}

if ($foundCommands -eq $expectedCommands.Count) {
    Write-Pass "All $foundCommands commands installed"
}
else {
    Write-Fail "Missing commands: $($missingCommands -join ', ')"
    $errors++
}

# ============================================================================
# 7. Check CLAUDE.md
# ============================================================================

Write-Check "Checking CLAUDE.md..."

$claudeMdFile = Join-Path $CLAUDE_TARGET "CLAUDE.md"
if (Test-Path $claudeMdFile) {
    $content = Get-Content $claudeMdFile -Raw
    if ($content -match "Agentic Substrate") {
        Write-Pass "CLAUDE.md configured with Agentic Substrate"
    }
    else {
        Write-Info "CLAUDE.md exists but may not contain Agentic Substrate config"
        $warnings++
    }
}
else {
    Write-Fail "CLAUDE.md not found"
    $errors++
}

# ============================================================================
# 8. Check hooks
# ============================================================================

Write-Check "Checking hooks..."

$hooksDir = Join-Path $CLAUDE_TARGET "hooks"
if (Test-Path $hooksDir) {
    $hookCount = (Get-ChildItem $hooksDir -Filter "*.sh" | Measure-Object).Count
    if ($hookCount -gt 0) {
        Write-Pass "$hookCount hooks found"
    }
    else {
        Write-Info "No hooks found (optional)"
    }
}
else {
    Write-Info "Hooks directory not found (optional)"
}

# ============================================================================
# 9. Check validators
# ============================================================================

Write-Check "Checking validators..."

$validatorsDir = Join-Path $CLAUDE_TARGET "validators"
if (Test-Path $validatorsDir) {
    $validatorCount = (Get-ChildItem $validatorsDir -Filter "*.sh" | Measure-Object).Count
    if ($validatorCount -gt 0) {
        Write-Pass "$validatorCount validators found"
    }
    else {
        Write-Info "No validators found (optional)"
    }
}
else {
    Write-Info "Validators directory not found (optional)"
}

# ============================================================================
# 10. Check Claude CLI
# ============================================================================

Write-Check "Checking Claude CLI..."

$claudeCmd = Get-Command "claude" -ErrorAction SilentlyContinue
if ($claudeCmd) {
    Write-Pass "Claude CLI found: $($claudeCmd.Source)"
}
else {
    Write-Info "Claude CLI not found in PATH (required to use the system)"
    $warnings++
}

# ============================================================================
# 11. Check circuit breaker
# ============================================================================

Write-Check "Checking circuit breaker state..."

$circuitBreakerFile = Join-Path $CLAUDE_TARGET ".circuit-breaker-state"
if (Test-Path $circuitBreakerFile) {
    $state = (Get-Content $circuitBreakerFile -Raw).Trim()
    if ($state -eq "closed") {
        Write-Pass "Circuit breaker: CLOSED (ready)"
    }
    elseif ($state -eq "open") {
        Write-Info "Circuit breaker: OPEN (blocked - manual reset needed)"
        $warnings++
    }
    else {
        Write-Info "Circuit breaker state: $state"
    }
}
else {
    Write-Info "Circuit breaker not initialized (normal for fresh install)"
}

# ============================================================================
# Summary
# ============================================================================

Write-Host ""
Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host "Verification Summary" -ForegroundColor Cyan
Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host ""

if ($errors -eq 0 -and $warnings -eq 0) {
    Write-Host "STATUS: ALL CHECKS PASSED" -ForegroundColor Green
    Write-Host ""
    Write-Host "Your Agentic Substrate installation is complete and ready to use!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Quick Start:" -ForegroundColor Cyan
    Write-Host "  1. Open Claude Code CLI"
    Write-Host "  2. Try: /workflow Add feature X"
    Write-Host ""
}
elseif ($errors -eq 0) {
    Write-Host "STATUS: PASSED WITH WARNINGS" -ForegroundColor Yellow
    Write-Host "  Warnings: $warnings" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Installation is functional but review warnings above." -ForegroundColor Yellow
    Write-Host ""
}
else {
    Write-Host "STATUS: FAILED" -ForegroundColor Red
    Write-Host "  Errors: $errors" -ForegroundColor Red
    Write-Host "  Warnings: $warnings" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please fix the errors above and run this script again." -ForegroundColor Red
    Write-Host "You may need to reinstall: .\install.ps1 -Force" -ForegroundColor Yellow
    Write-Host ""
}

exit $errors
