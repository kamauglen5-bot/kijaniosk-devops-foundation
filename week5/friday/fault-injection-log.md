# Fault Injection Log — CI Pipeline Behaviour

This document records how each pipeline stage behaves when intentionally broken and how the system responds.

---

## 1. Lint Stage Failure

| Fault | Observed Behaviour | Why this is correct |
|------|--------------------|---------------------|
| Introduced syntax error in code | Pipeline stopped at Lint stage, Build and all later stages skipped | Prevents invalid code from entering the build process |

---

## 2. Build Stage Failure

| Fault | Observed Behaviour | Why this is correct |
|------|--------------------|---------------------|
| Broke build command | Build failed, Verify/Archive/Publish did not run | Prevents unusable artifacts from being created |

---

## 3. Test Stage Failure

| Fault | Observed Behaviour | Why this is correct |
|------|--------------------|---------------------|
| Forced test failure | Pipeline stopped before artifact creation | Ensures only tested code is packaged |

---

## 4. Security Audit Failure

| Fault | Observed Behaviour | Why this is correct |
|------|--------------------|---------------------|
| Introduced vulnerable dependency | Pipeline stopped at security stage | Prevents insecure code from being published |

---

## 5. Publish Stage Failure

| Fault | Observed Behaviour | Why this is correct |
|------|--------------------|---------------------|
| Wrong credentials / Nexus URL | Build completed but publish failed | Ensures validation stages still run before upload attempt |