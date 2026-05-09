# KijaniKiosk CI Pipeline Overview

Every time a developer uploads new code to the shared repository, an automated process begins checking whether the change is safe, functional, and ready to become an official application version. This process reduces manual checking and lowers the risk of unstable software reaching customers.

The pipeline begins with a linting stage that checks whether the code follows agreed quality and formatting standards. If the code fails this check, the process stops immediately to avoid wasting time on code that already violates team standards.

After linting passes, the build stage creates the application package and confirms that the software can be assembled correctly. The verification stage then runs two checks in parallel: automated tests confirm expected behaviour while the security audit checks for known dependency vulnerabilities.

Once verification succeeds, the build artifacts are archived with fingerprinting enabled so that each output can be traced back to the exact pipeline execution that created it. The final stage publishes a uniquely versioned package to the Nexus artifact repository for future deployment use.

| Stage | Purpose |
|---|---|
| Lint | Confirms code quality standards |
| Build | Confirms application can compile |
| Test | Confirms features work correctly |
| Security Audit | Checks for dependency vulnerabilities |
| Archive | Stores traceable build outputs |
| Publish | Uploads approved version to Nexus |

## What Happens When Something Goes Wrong

If any stage detects a problem, the process stops automatically and later stages do not run. For example, if code formatting fails, the application is not built or published. If testing fails, no release version is stored in the repository. This prevents unstable or unsafe software from progressing further into the delivery process.

The pipeline also records logs and build history to help engineers identify the exact point of failure quickly. Credentials used for publishing are protected through Jenkins credential management and are not stored directly inside the pipeline code.

This pipeline does not yet deploy applications automatically to staging or production environments. It also does not include advanced performance testing, rollback automation, or production monitoring integrations. These would be the next improvements as the platform grows.
