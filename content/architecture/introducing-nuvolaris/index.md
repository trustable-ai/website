+++
title = "Introducing Nuvolaris"
description = "Multi-cloud compatibility, integrated frontend and backend services, an extensible CLI, a low-code console, a full-code cloud IDE and the Trustable AI workbench."
weight = 10
+++

Nuvolaris is a cloud-native platform implementing a complete serverless
environment. Figure 1 gives a bird's eye view of Nuvolaris.

![Bird's eye view: the OpenWhisk controller, invokers and runtimes at the centre, with Redis, Milvus, SeaweedFS and PostgreSQL on the left, the admin console, operator, CLI and Trustable on the right, and Prometheus and Velero for monitoring and backup](_page_2_Figure_3.jpeg)

**Figure 1**

Nuvolaris provides a powerful and flexible environment designed for developing and deploying modern cloud-native applications efficiently. Here's a more in-depth look at its key features and capabilities:

## 1. Multi-Cloud and Private Cloud Compatibility with Kubernetes

Nuvolaris is built to work seamlessly across a wide range of Kubernetes distributions. This adaptability means that whether you're using public cloud providers (like AWS, Google Cloud, or Azure) or operating within a private cloud setup, Nuvolaris can run smoothly. The flexibility of Kubernetes orchestration is fully leveraged here, allowing users to scale applications across diverse environments while ensuring robust deployment and management consistency.

## 2. Integrated Development Services for Both Frontend and Backend

Nuvolaris provides a suite of integrated tools and services designed specifically to support full-stack development. Backend functionality is supported seamlessly, allowing for microservices and serverless architectures that are scalable and performant. For frontend needs, it integrates tools to streamline UI development, making it easier to build and deploy end-to-end applications in a single environment.

As shown on the left of Figure 1, these services come with the platform rather than being assembled per project: Redis for caching, Milvus as the vector database for AI workloads, SeaweedFS for S3-compatible object storage and PostgreSQL for relational data. Prometheus and Velero cover monitoring and backup on the operational side.

## 3. A Rich, Extensible CLI for Administration and Development

The Nuvolaris Command Line Interface (CLI) is one of its core strengths. Designed to support both administration and development, the CLI is highly extensible, enabling users to customise and expand its functionalities as needed. This CLI allows for straightforward setup, management, and maintenance of deployments and resources, catering to both developers' needs and system administrators' requirements. By combining administrative and development capabilities into a single, robust CLI, Nuvolaris simplifies interaction and control for all roles involved in the software lifecycle.

## 4. Low-Code Administrative Console for Rapid Prototyping and Editing

Nuvolaris includes a low-code administrative console, a user-friendly interface that allows both technical and non-technical users to build, edit, and quickly prototype applications. This console is particularly useful for projects requiring frequent updates or iterative changes, as it allows for swift modifications without needing extensive code changes.

## 5. Full-Code Development Environment with Cloud-Based IDE Support

For developers seeking a full-code experience, Nuvolaris offers a complete, cloud-based development environment that is compatible with CodeSpace and other popular IDEs. This full-code support in the cloud allows for comprehensive application development, testing, and deployment from a single online workspace. Developers benefit from the flexibility to code freely while leveraging cloud resources, thus ensuring high productivity without the constraints of local environments.

## 6. Trustable, the Private AI Workbench

At the top right of Figure 1 sits [Trustable](@/documentation/_index.md), the Private AI workbench that the Web IDE opens into. It lets you build apps with local AI on your PC: you describe the application you want, an AI coding assistant writes it, and the result runs on the same cluster as everything else in the figure — using the integrated runtimes, object storage and vector database rather than any external service. Applications start from ready-made starters and templates, live in their own repositories, and move from development to production without leaving your infrastructure.

In essence, Nuvolaris combines multi-cloud flexibility, a full-stack development ecosystem, powerful CLI tooling, a low-code console, a fully functional coding environment and the Trustable AI workbench to streamline and enhance the entire development pipeline from start to finish. These features collectively make Nuvolaris an adaptable and efficient platform for teams looking to build, deploy and manage applications across a variety of environments with ease and precision.

Next: [The Serverless Engine](@/architecture/serverless-engine/index.md).
