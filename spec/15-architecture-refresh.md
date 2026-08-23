# Spec 15 — Architecture documentation refresh

Branch: `spec-15`

## Goal

Bring the Architecture section of the site in line with the current stack:

1. Remove every reference to **MinIO**, replacing it with **SeaweedFS** as the
   S3-compatible object storage.
2. Replace **MastroGPT** with **Trustable**, described the way the
   Documentation section already describes it (a Private AI workbench: a
   Lovable-like experience for building, running and publishing AI applications
   on your own infrastructure).
3. Add **Milvus** as the vector database component of the integrated services.

## Files in scope

- `content/architecture/_index.md` — section overview list.
- `content/architecture/components/index.md` — section 4 (MastroGPT → Trustable)
  plus the front-matter description and the closing paragraph.
- `content/architecture/integrated-services/index.md` — section 2 (MinIO → SeaweedFS),
  the front-matter description, and a new Milvus section.

No other content file mentions MinIO or MastroGPT. `support/profile/README.md`
matches only the hostname `trustable.miniops.me`, which is unrelated.
Generated files under `docs/` are rebuilt from content and are not edited by hand.

## Plan

### 1. `content/architecture/integrated-services/index.md`

- Front matter `description`: "Redis cache, SeaweedFS or Ceph object storage,
  PostgreSQL and FerretDB, Milvus vector database, Prometheus monitoring and
  Velero backup."
- Rename `## 2. MinIO or Ceph Object Storage` to `## 2. SeaweedFS or Ceph Object Storage`
  and rewrite the body: SeaweedFS is an Apache-2.0 licensed, S3-compatible
  distributed object store optimised for large numbers of small files, with
  fast key-to-file lookups and optional erasure coding. Keep the Ceph paragraph.
  Replace the closing "In the Nuvolaris ecosystem, MinIO or Ceph…" with SeaweedFS.
- Insert a new `## 4. Milvus Vector Database` after the PostgreSQL/FerretDB
  section, describing Milvus as an open-source vector database for embeddings and
  similarity search, and its role in Nuvolaris as the retrieval layer for
  RAG and other AI applications built with Trustable.
- Renumber the subsequent sections: Prometheus becomes 5, Velero becomes 6.

### 2. `content/architecture/components/index.md`

- Front matter `description`: "The Kubernetes operator, the CLI, the Console and
  Trustable — the management stack around OpenWhisk."
- Rename `## 4. MastroGPT` to `## 4. Trustable` and rewrite the three bullets to
  describe Trustable as the Private AI workbench: a Lovable-like experience where
  a written description becomes a working application, started from templates and
  starters, running on the user's own infrastructure — with a link to
  `@/documentation/_index.md`.
- Update the closing paragraph to name Trustable.

### 3. `content/architecture/_index.md`

- Update the Components bullet: "the Kubernetes operator, the CLI, the Console
  and Trustable".
- Update the Integrated Services bullet to mention the vector database.

## Out of scope

Regenerating `docs/` (the build) and the figure images, which still show the old
component names. The user asks for the build separately.

## Addendum — align text to the figures

The figures had already been redrawn before this work started. Checking all six
images under `content/architecture/` confirms they show Trustable, Milvus and
SeaweedFS, and no MinIO or MastroGPT. The text was therefore aligned to them:

- `integrated-services/index.md` — the three alt texts described the wrong
  images (the first is Redis/Milvus/SeaweedFS/PostgreSQL, not "cache and object
  storage"; the second is Prometheus; the third is Velero). Rewrote them, added a
  lead-in splitting data services from operational services, and reordered the
  sections to follow the figure: Redis, Milvus, SeaweedFS, PostgreSQL,
  Prometheus, Velero. Noted that FerretDB sits on the same PostgreSQL instance,
  which is why it does not appear separately in the figure.
- `components/index.md` — the intro sentence listed only operator, CLI and
  console; added Trustable and described the flow the figure shows. Rewrote the
  alt text and linked the Console's Web IDE bullet to Trustable.
- `introducing-nuvolaris/index.md` — Figure 1 shows Milvus, SeaweedFS and
  Trustable, none of which the text mentioned. Rewrote the alt text, added the
  integrated data services to feature 2, added a new feature 6 for Trustable,
  and updated the closing summary and the front-matter description.
- `_index.md` — section blurb and the Integrated Services bullet now name
  Milvus and SeaweedFS and the Trustable workbench.

## Addendum 2 — drop Ceph

Ceph is no longer offered as an alternative object store. Removed every mention
from `integrated-services/index.md`: the front-matter description, the section
heading (now "SeaweedFS Object Storage"), the "either/or" lead-in, the Ceph
paragraph, and the closing sentence. The on-premise / hybrid-deployment point the
Ceph paragraph carried was kept and reattributed to SeaweedFS, so nothing is lost
beyond the product name.
