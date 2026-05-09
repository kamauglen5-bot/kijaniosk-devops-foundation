# Post Incident Review – Week 5 Monday Incident

## 1. Summary
During a live investor demonstration, the deployment pipeline routed traffic to an unintended environment, causing a brief service disruption.

## 2. Timeline
- 09:00 – Demo started
- 09:02 – Deployment triggered
- 09:03 – Traffic routed incorrectly
- 09:04 – Error detected
- 09:05 – Service restored

(Some timestamps estimated from logs)

## 3. Root Cause
The deployment system did not strictly enforce environment selection, allowing traffic to switch without validation.

## 4. Contributing Factors
- Missing environment lock file validation
- Manual trigger dependency
- Lack of pre-switch verification step

## 5. What went well
Rollback mechanism successfully restored service quickly without manual intervention.

## 6. Action Items
- Enforce environment validation before switch (Owner: DevOps)
- Add pre-switch health verification gate (Owner: Platform Team)
- Add automated deployment audit logging (Owner: SRE Team)
