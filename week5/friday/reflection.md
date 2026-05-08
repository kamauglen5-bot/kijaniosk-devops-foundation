# Week 5 Reflection

## 1. Requirement tension or uncertainty

The main tension I encountered was between making the pipeline strict and making it fast. Adding more validation steps improves reliability, but it also increases build time. I chose to prioritise reliability because this pipeline is meant for a financial system where correctness is more important than speed. I reduced unnecessary complexity in some stages to keep total runtime under the required limit.

---

## 2. Technical vs non-technical explanation

A technical way of describing the pipeline would be: "The Jenkins pipeline executes a sequence of stages defined in a declarative Jenkinsfile, including linting, building, parallel test execution, artifact archiving, and Nexus publishing with credential injection."

A simpler explanation would be: "Every time a developer saves code, the system automatically checks it, tests it, and saves a safe version if everything works."

Both versions describe the same system, but the technical version focuses on implementation details while the simple version focuses on understanding and communication.

---

## 3. What would break first at scale

If the system grew from 4 developers to 40, the first thing to break would likely be the Nexus publishing and artifact storage process. This is because all builds would start uploading artifacts at a much higher rate, creating potential bottlenecks in storage and network throughput.

To fix this, we would need to introduce caching, artifact cleanup policies, or possibly distribute the artifact registry across multiple nodes to handle higher load.

---

## 4. Summary

Overall, the CI pipeline improved consistency and reliability of software delivery. It ensures that only validated and tested code is stored as a versioned artifact, reducing risk and improving traceability.