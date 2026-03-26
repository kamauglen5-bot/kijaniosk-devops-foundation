# IAM Least Privilege

Task:
App reads files from storage

Policy:

Allow:
- Read only (GetObject)

Do NOT allow:
- Delete
- Write

Reason:
- Keeps system secure
- Limits damage if hacked
