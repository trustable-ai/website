+++
title = "Nuvolaris Architecture"
description = "How Nuvolaris implements a complete serverless environment: the OpenWhisk engine, the management components, the integrated services and the clouds it runs on."
weight = 20
sort_by = "weight"
template = "section.html"
page_template = "page.html"
[extra]
nav_title = "Architecture"
+++

Nuvolaris is a cloud-native platform implementing a complete serverless
environment. It combines multi-cloud flexibility, a full-stack development
ecosystem, powerful CLI tooling, a low-code console, a fully functional coding
environment and the Trustable Private AI workbench to streamline the entire
development pipeline from start to finish.

This paper describes the architecture in five parts:

- [Introducing Nuvolaris](@/architecture/introducing-nuvolaris/index.md) — the
  platform's key features and capabilities.
- [The Serverless Engine](@/architecture/serverless-engine/index.md) — Apache
  OpenWhisk, and what happens internally when an action runs.
- [Nuvolaris Components](@/architecture/components/index.md) — the Kubernetes
  operator, the CLI, the Console and Trustable.
- [Integrated Services](@/architecture/integrated-services/index.md) — Redis,
  Milvus, SeaweedFS object storage, the databases, monitoring and backup.
- [Supported Clouds](@/architecture/supported-clouds/index.md) — public cloud,
  private cloud and bare-metal deployments.
