+++
title = "Integrated Services"
description = "Redis cache, SeaweedFS object storage, PostgreSQL and FerretDB, Milvus vector database, Prometheus monitoring and Velero backup."
weight = 40
+++

Nuvolaris includes a number of integrated services as shown in Figure 4: the
data services that applications use directly, and the operational services that
keep the platform healthy.

![Data services: Redis, Milvus, SeaweedFS and PostgreSQL](_page_11_Picture_3.jpeg)

![Prometheus monitoring](_page_11_Picture_4.jpeg)

![Velero backup](_page_11_Picture_5.jpeg)

**Figure 4**

## 1. Redis Cache

Redis (Remote Dictionary Server) is an open-source, in-memory data structure store primarily used as a cache and message broker. Redis is particularly well-suited for caching due to its low latency and high throughput, as it stores data directly in memory, unlike traditional databases that rely on disk storage.

In a serverless platform like Nuvolaris, Redis acts as a high-performance layer to cache dynamic content, optimises response times and improves overall application speed.

## 2. Milvus Vector Database

Milvus is an open-source vector database built for storing, indexing and searching the high-dimensional embeddings produced by AI models. Instead of matching exact values, it answers similarity queries — "which stored vectors are closest to this one" — over billions of entries, using indexes such as HNSW and IVF, and combines them with ordinary metadata filtering.

In Nuvolaris, Milvus is the retrieval layer for AI workloads: it holds the embeddings of documents, images and other content so that applications built with [Trustable](@/documentation/_index.md) can implement retrieval-augmented generation, semantic search and recommendation entirely on your own infrastructure, with no data leaving the cluster.

## 3. SeaweedFS Object Storage

We include an S3 storage using SeaweedFS.

SeaweedFS is an Apache 2.0 licensed open-source, Amazon S3-compatible distributed object store. It is designed around fast key-to-file lookups, which makes it particularly efficient at handling very large numbers of small objects, and it scales out by simply adding volume servers. Optional replication and erasure coding let you trade storage cost against durability without changing the S3 API your applications use.

Being S3-compatible, it is an ideal on-premise storage solution for private cloud environments or hybrid deployments: applications talk to it with the ordinary S3 API, so anything written against S3 works unchanged.

In the Nuvolaris ecosystem, SeaweedFS provides a robust object storage solution that can be used to store application data, backups, and even static content, ensuring that data is both secure and accessible.

## 4. PostgreSQL and FerretDB Database

PostgreSQL, often referred to as Postgres, is an open-source relational database known for its extensibility, reliability, and SQL compliance. It is widely regarded as one of the most advanced databases available, especially within cloud-native ecosystems.

FerretDB is an optional layer on top of that same PostgreSQL instance — which is why the figure shows only PostgreSQL. It is an open-source database that acts as a drop-in replacement for MongoDB, using PostgreSQL as its storage backend. It is ideal for users who want MongoDB-like functionality without the restrictions and licensing constraints of MongoDB, especially as MongoDB's licensing changes have impacted its use in certain environments.

In a Nuvolaris setup, PostgreSQL and FerretDB provides robust database services for handling application data that requires relational structure and advanced querying capabilities, which is particularly valuable for data-driven application.

## 5. Prometheus Monitoring

Prometheus is an open-source monitoring and alerting toolkit designed specifically for reliability and scalability in cloud-native environments. It collects and stores metrics data, offering visibility into system health and performance.

In Nuvolaris, Prometheus is essential for monitoring the health of services and infrastructure, enabling proactive incident response and resource optimization in a scalable, serverless environment.

## 6. Velero Backup

Velero is an open-source tool for managing Kubernetes backups, disaster recovery, and migration. It's designed specifically for Kubernetes clusters and provides reliable backup, restore, and migration of cluster resources and persistent volumes.

For Nuvolaris, Velero is vital in ensuring business continuity, providing peace of mind with automated backups and quick recovery options, reducing data loss risk and maintaining application availability in the case of accidental deletion, corruption, or failure.

Next: [Supported Clouds](@/architecture/supported-clouds/index.md).
