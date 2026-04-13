# Cybersecurity Mindset
# @linked .claude/rules/security-checklist.md
# @linked .claude/rules/senior-engineering.md

Every agent thinks like an attacker before coding like a defender. Security is not a phase — it is embedded in every line of code.

## Threat-First Development

Before implementing ANY feature:
1. **Identify assets**: What data or functionality is being protected?
2. **Map attack surface**: What inputs, endpoints, or interfaces does this expose?
3. **Apply STRIDE**: Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege
4. **Define mitigations**: For each threat, what control prevents or detects it?

## Offensive Security Awareness

Understand how attackers think to write better defenses:

### Injection Vectors
- SQL/NoSQL injection: never concatenate user input into queries
- Command injection: never pass user input to shell commands without sanitization
- Template injection: never render user input as template code (SSTI)
- LDAP/XPath injection: parameterize all directory and XML queries
- Header injection: validate and sanitize HTTP header values

### Authentication & Session Attacks
- Credential stuffing: rate limit + account lockout + MFA
- Session fixation: regenerate session ID after authentication
- Token theft: HttpOnly + Secure + SameSite cookies, short-lived JWTs
- Password spraying: detect patterns across multiple accounts
- OAuth misconfigurations: validate redirect URIs, use PKCE for public clients

### Web Application Attacks
- XSS (Reflected, Stored, DOM-based): context-aware output encoding
- CSRF: SameSite cookies + anti-CSRF tokens on state-changing operations
- SSRF: allowlist outbound URLs, block internal network ranges
- Open redirects: validate redirect targets against allowlist
- Clickjacking: X-Frame-Options + CSP frame-ancestors

### Infrastructure & Supply Chain
- Dependency confusion: use scoped packages, pin versions, verify checksums
- Typosquatting: verify package names character by character
- CI/CD poisoning: pin actions by SHA, use OIDC, least-privilege runners
- Container escape: non-root containers, read-only filesystems, drop capabilities

## Defensive Coding Standards

### Input Handling (Trust Nothing)
- Validate type, length, format, and range on ALL external input
- Use allowlists over denylists (define what IS valid, not what ISN'T)
- Validate on the server even if client-side validation exists
- Decode input exactly once before validation (avoid double-encoding bypasses)

### Output Encoding
- HTML context: HTML-entity encode (`&lt;`, `&gt;`, `&amp;`, `&quot;`)
- JavaScript context: JavaScript-escape or use JSON.stringify
- URL context: percent-encode
- SQL context: parameterized queries only (never string interpolation)
- CSS context: CSS-escape user values

### Cryptography (Do Not Roll Your Own)
- Passwords: Argon2id (preferred) or bcrypt with cost >= 12
- Symmetric encryption: AES-256-GCM (authenticated encryption)
- Asymmetric: RSA-2048+ or Ed25519
- Hashing: SHA-256+ for integrity, never MD5 or SHA-1
- Random: use cryptographic RNG (crypto.randomBytes, secrets module)
- Key management: never hardcode keys, use KMS or vault

### Access Control
- Default deny: no access unless explicitly granted
- Check authorization on every request, not just the UI
- Use RBAC or ABAC consistently — no ad-hoc permission checks
- Validate object ownership: just because a user is authenticated doesn't mean they own the resource (IDOR prevention)

### Secure Defaults
- HTTPS everywhere, HSTS enabled
- Security headers: CSP, X-Content-Type-Options, X-Frame-Options, Referrer-Policy
- Cookies: HttpOnly, Secure, SameSite=Lax (or Strict)
- CORS: explicit origin allowlist, never wildcard with credentials
- Error messages: generic to users, detailed to logs (never leak stack traces)

## Security Review Mandatory Triggers

These scenarios MUST trigger a security-focused review, regardless of route:
- Any code handling authentication or authorization
- Any code processing user file uploads
- Any code making outbound HTTP requests
- Any code executing shell commands or system calls
- Any code handling payment or PII data
- Any code modifying database schemas or queries
- Any code changing CORS, CSP, or security headers
- Any dependency addition or version change
