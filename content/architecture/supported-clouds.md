+++
title = "Supported Clouds"
description = "Nuvolaris is provider-agnostic: it runs on public cloud Kubernetes, private cloud distributions and bare-metal hardware."
weight = 50
+++

Nuvolaris is designed as a flexible, provider-agnostic serverless platform, making it compatible with a wide range of cloud solutions.

This versatility allows users to choose the infrastructure that best suits their needs, whether it's public cloud, private cloud or bare-metal setups.

Here's a detailed overview of the supported options.

## 1. Public Cloud

- **AWS (Amazon Web Services):** Nuvolaris integrates seamlessly with AWS, leveraging its Kubernetes services, such as EKS, for scalable deployment. AWS users can take advantage of the wide array of AWS-native services for additional functionality, paired with Nuvolaris' serverless environment.
- **GCP (Google Cloud Platform):** With GCP, Nuvolaris utilises Google Kubernetes Engine (GKE) to offer robust and managed Kubernetes environments, facilitating high-availability deployments and enabling quick scalability.
- **Microsoft Azure:** Nuvolaris supports Azure Kubernetes Service (AKS), allowing Azure users to run serverless functions within Azure's cloud-native ecosystem, combining the simplicity of Nuvolaris with Azure's enterprise-grade cloud infrastructure.

## 2. Private Cloud

- **Rancher (k3s):** Nuvolaris is compatible with Rancher's lightweight Kubernetes distribution, k3s, making it ideal for private cloud deployments that require efficient resource use without compromising on Kubernetes' functionality.
- **Ubuntu (MicroK8s):** Supporting MicroK8s, Nuvolaris enables users to run lightweight, production-grade Kubernetes on Ubuntu, tailored for both development and enterprise scenarios where flexibility and control are priorities.
- **Red Hat OpenShift:** Nuvolaris integrates with OpenShift for users looking for a private cloud option that offers security, scalability, and extensive Kubernetes customization, allowing for advanced configuration and orchestration capabilities.

## 3. Bare-Metal Cloud

- **Hetzner and OVH:** For organisations preferring on-premises or bare-metal environments, Nuvolaris can be deployed directly on hardware providers like **Hetzner** and **OVH**, allowing users to harness dedicated physical servers. This configuration offers high performance and privacy, ideal for workloads requiring low latency and enhanced data sovereignty.
