# Anti-Reward-Hacking Rules

Agents optimize for the reward signal (tests pass, task complete). These rules prevent shortcuts that satisfy the signal but miss the intent.

## Forbidden Patterns

### 1. Test Disabling
NEVER use `test.skip`, `.skip(`, `xit(`, `xdescribe(`, `xtest(`, or `@pytest.mark.skip` to make a failing test suite green. If a test fails, fix the code — not the test.

### 2. Error Swallowing
NEVER write generic catch blocks that return `{ success: false }` or log a generic message. Every error handler MUST:
- Preserve the original error type/code
- Include context (IDs, parameters) for debugging
- Either propagate or handle with a **specific** recovery path

### 3. Mock Abuse
NEVER mock the system under test. Mocks are for external dependencies only. If you mock internal modules to make tests pass, you're testing your mocks, not your code.

### 4. Force-Installing Dependencies
NEVER use `--force`, `--legacy-peer-deps`, or compile from source to bypass dependency conflicts. Report the conflict and let the human decide.

### 5. Deleting Evidence
NEVER delete log files, git history, test snapshots, or error reports to "clean up." If something broke, the evidence must survive for diagnosis.

## What To Do Instead

- **Test fails?** → Fix the code. If the test is wrong, explain why and fix the test with a comment explaining the change.
- **Can't install?** → Report the conflict with versions and let the human decide.
- **Error handling?** → Catch specific errors, not `catch (e)` with a generic fallback.
- **Blocked?** → Use the human-in-the-loop escape hatch. Ask for guidance instead of hacking around.

## Source
Patterns observed across Claude Code and Codex sessions. See: Alejandro Vidal, "Agentic Engineering" - HACKNIGHT Valencia 2026.
