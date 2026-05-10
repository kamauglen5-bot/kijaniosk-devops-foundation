# Week 8 Production Delivery vs Week 7 Approach

This week represents a transition from manually executed deployment workflows to a fully containerized and orchestrated production delivery system. The goal was to build a reproducible pipeline where an application can be packaged, versioned, deployed, and recovered automatically without manual intervention. Compared to Week 7, which relied heavily on environment-specific execution and manual deployment steps, Week 8 introduces consistency, automation principles, and system resilience through Kubernetes and container registry workflows.

In Week 7, deployments were typically tied to the local environment. This meant that running the application depended on preconfigured system state, and recovery from failure required manual redeployment. There was limited ability to guarantee that the same application version would behave consistently across different environments. Week 8 resolves this by introducing a container-based architecture where the application is packaged into an immutable image. This ensures that every deployment uses the same runtime environment regardless of where it is executed.

A key improvement this week is the introduction of versioned image delivery through a container registry. Instead of relying on local builds, the application is built, tagged with a version tied to source control, and pushed to a remote registry. This creates traceability between code changes and deployed artifacts. In Week 7, this traceability was weak or inconsistent, making rollback unreliable. In Week 8, rollback is simplified by referencing previous image versions directly.

Another major advancement is the shift from single-instance execution to a replicated system managed by Kubernetes. Week 7 systems typically ran as a single process, meaning any failure resulted in downtime. In contrast, Week 8 introduces multiple replicas managed by a controller that ensures the system continuously matches the desired state. When a failure was simulated by deleting running instances during testing, Kubernetes automatically recreated replacement instances without manual intervention. The observed recovery time from failure to fully running state was approximately under one minute, demonstrating automated self-healing behavior.

### Comparison Table

| Concern | Week 7 Approach | Week 8 Approach |
|----------|----------------|-----------------|
| Deployment mechanism | Manual or environment-dependent deployment requiring local setup consistency | Declarative container-based deployment managed through Kubernetes orchestration |
| Rollback mechanism | Manual rollback requiring reconfiguration or redeployment of previous state | Versioned container images enable instant rollback by referencing previous tags |
| Failure recovery | Manual intervention required after system failure or service crash | Automatic self-healing using replica management ensures desired state is restored |
| Scaling | Limited and typically single-instance deployment requiring manual scaling decisions | Horizontal scaling through replicas automatically managed by Kubernetes |

One of the most important measurable improvements is system resilience. During failure testing, running instances were deliberately removed. The system automatically detected the missing replicas and restored them without external intervention. The recovery time observed during this process was under one minute from failure to full restoration of running instances. This demonstrates a shift from reactive recovery to proactive self-healing infrastructure behavior.

Another significant improvement is image efficiency. The production container created this week uses a multi-stage build approach, resulting in a significantly smaller image size compared to earlier baseline builds. The final optimized image is under 100MB, improving deployment speed, reducing storage requirements in the registry, and making scaling more efficient. This is a critical improvement for production environments where resource efficiency directly impacts cost and performance.

Despite these advancements, the system is not yet fully production-hardened. Configuration values are still embedded directly within deployment definitions rather than being externalized into dedicated configuration management systems. Additionally, observability is limited, meaning system behavior under load or failure conditions is not fully visible. Advanced deployment strategies such as progressive rollouts and advanced health separation are also not yet implemented. These limitations indicate that while the system is stable and reproducible, it is not yet optimized for large-scale production environments.

Week 9 is expected to address these gaps by introducing external configuration management, secure handling of sensitive values, and improved deployment safety mechanisms. These enhancements will further improve system flexibility and operational safety, moving the architecture closer to enterprise-grade production standards.

Overall, Week 8 represents a significant architectural improvement over Week 7 by introducing reproducibility, automation, and resilience. The system is now capable of being rebuilt, redeployed, and recovered consistently across environments, marking a major step toward production-ready infrastructure.
