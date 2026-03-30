---
paths: ["**/*.rs", "Cargo.toml", "Cargo.lock"]
---
# Rust Rules

## Style
- **rustfmt**: Always `cargo fmt` before committing
- **clippy**: `cargo clippy -- -D warnings` (warnings as errors)
- Organize by domain, not by type

## Ownership & Borrowing
- Borrow (`&T`) by default; own only when storing or consuming
- Accept `&str` over `String`, `&[T]` over `Vec<T>` in function params
- Use `impl Into<String>` for constructors needing ownership
- Use `Cow<'_, T>` when may or may not need to allocate
- NEVER clone just to satisfy borrow checker without understanding why

## Error Handling
- `Result<T, E>` with `?` for propagation -- never `unwrap()` in production
- Libraries: `thiserror` for typed errors
- Applications: `anyhow` for flexible error context
- Add context: `.with_context(|| format!("failed to ..."))?`

## Patterns
- **Newtype**: Wrap primitives for type safety (`struct UserId(u64)`)
- **Enum State Machines**: Make illegal states unrepresentable; match exhaustively (no wildcard `_` for business enums)
- **Builder**: For complex config construction
- **Repository Trait**: `Send + Sync` trait with concrete impls per storage
- **Sealed Traits**: Private module pattern for extensibility control

## Iterators
Prefer iterator chains for transformations; use loops for complex control flow.

## Visibility
- Default to private; `pub(crate)` for internal sharing
- Only `pub` what's part of the public API

## Testing
- Unit: `#[cfg(test)]` modules in same file
- Integration: `tests/` directory (separate binaries)
- **rstest** for parameterized, **proptest** for property-based
- **mockall** for trait mocking, `#[tokio::test]` for async
- Coverage: **cargo-llvm-cov** (`cargo llvm-cov --fail-under-lines 80`)
- Descriptive names: `creates_user_with_valid_email()`, not `test1()`

```bash
cargo test                    # All tests
cargo test -- --nocapture     # Show output
cargo test --lib              # Unit only
cargo llvm-cov --html         # Coverage report
```

Adapted from affaan-m/everything-claude-code Rust rules.
