## 2026-08-06 - subprocess for CLI testing
**Learning:** When testing standalone Python CLI scripts that do not encapsulate their top-level logic inside a `main()` function, using `subprocess.run` to execute the script in a separate process is often safer and more reliable than mocking `sys.argv`. It avoids unintended side-effects during import.
**Action:** Prefer `subprocess` for testing loose CLI scripts, and ensure `sys.executable` is used instead of hardcoding `python3` to maximize cross-platform test reliability.
