---
name: playwright-testing
description: "Browser automation testing with Playwright. Covers page navigation, element interaction, screenshot capture, network interception, visual regression, and end-to-end test flows for web applications."
auto_invoke: false
tags: [testing, playwright, e2e, browser, automation, visual-regression]
---

# Playwright Testing Skill

Browser automation and end-to-end testing methodology using Playwright. Strengthens the review-coordinator's browser testing capabilities.

## When to Invoke

- End-to-end testing of web application features
- Visual regression testing
- Browser-based debugging and diagnostics
- Automated UI verification after code changes
- Screenshot capture for documentation

## Core Patterns

### Page Navigation & Waiting

```python
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page()
    
    # Navigate and wait for network idle
    page.goto("http://localhost:3000")
    page.wait_for_load_state("networkidle")
    
    # Wait for specific element
    page.wait_for_selector("[data-testid='dashboard']")
    
    # Wait for API response
    with page.expect_response("**/api/users") as response_info:
        page.click("[data-testid='refresh']")
    response = response_info.value
    assert response.status == 200
```

**Critical**: Always wait for `networkidle` on dynamic apps before inspecting DOM.

### Element Interaction

```python
# Click
page.click("button:has-text('Submit')")
page.click("[data-testid='login-btn']")

# Fill forms
page.fill("#email", "user@example.com")
page.fill("#password", "secure123")

# Select dropdown
page.select_option("select#country", "US")

# Checkbox
page.check("#terms")

# File upload
page.set_input_files("input[type='file']", "test.pdf")

# Keyboard
page.press("#search", "Enter")
```

### Assertions

```python
from playwright.sync_api import expect

# Visibility
expect(page.locator(".success-message")).to_be_visible()
expect(page.locator(".error")).not_to_be_visible()

# Text content
expect(page.locator("h1")).to_have_text("Dashboard")
expect(page.locator(".count")).to_contain_text("42")

# Attributes
expect(page.locator("input")).to_have_value("user@example.com")
expect(page.locator("button")).to_be_enabled()

# URL
expect(page).to_have_url("**/dashboard")

# Count
expect(page.locator("table tbody tr")).to_have_count(10)
```

### Screenshots & Visual Regression

```python
# Full page screenshot
page.screenshot(path="screenshots/dashboard.png", full_page=True)

# Element screenshot
page.locator(".chart").screenshot(path="screenshots/chart.png")

# Visual comparison
expect(page).to_have_screenshot("dashboard.png", max_diff_pixels=100)
```

### Network Interception

```python
# Mock API response
page.route("**/api/users", lambda route: route.fulfill(
    status=200,
    content_type="application/json",
    body='[{"id": 1, "name": "Test User"}]'
))

# Block requests (ads, analytics)
page.route("**/*.{png,jpg,jpeg}", lambda route: route.abort())

# Capture requests
requests = []
page.on("request", lambda req: requests.append(req))
```

### Common Test Flows

#### Login Flow
```python
def test_login(page):
    page.goto("/login")
    page.fill("[data-testid='email']", "user@test.com")
    page.fill("[data-testid='password']", "password123")
    page.click("[data-testid='submit']")
    page.wait_for_url("**/dashboard")
    expect(page.locator("[data-testid='user-name']")).to_have_text("Test User")
```

#### CRUD Flow
```python
def test_create_item(page):
    page.goto("/items")
    page.click("[data-testid='add-item']")
    page.fill("[data-testid='name']", "New Item")
    page.click("[data-testid='save']")
    page.wait_for_selector("[data-testid='success-toast']")
    expect(page.locator("table")).to_contain_text("New Item")
```

#### Error Handling
```python
def test_form_validation(page):
    page.goto("/register")
    page.click("[data-testid='submit']")  # Submit empty
    expect(page.locator("[data-testid='email-error']")).to_be_visible()
    expect(page.locator("[data-testid='email-error']")).to_have_text("Email is required")
```

### Multi-Browser Testing

```python
# Test across browsers
for browser_type in [p.chromium, p.firefox, p.webkit]:
    browser = browser_type.launch()
    page = browser.new_page()
    # ... test logic
    browser.close()

# Mobile viewport
page = browser.new_page(viewport={"width": 375, "height": 812})  # iPhone
page = browser.new_page(viewport={"width": 768, "height": 1024})  # iPad
```

### Console & Error Monitoring

```python
# Capture console errors
errors = []
page.on("console", lambda msg: errors.append(msg.text) if msg.type == "error" else None)

# After test
assert len(errors) == 0, f"Console errors: {errors}"
```

## Integration with Agentic Substrate

- `@review-coordinator` uses this for browser testing during code review
- `@testing-engineer` includes Playwright in e2e test strategy
- `@responsive-reviewer` uses viewport testing for breakpoint verification
- `@ux-accessibility-reviewer` uses for automated accessibility checks

## Source
Adapted from ComposioHQ/awesome-claude-skills webapp-testing and Playwright official documentation.
