+++
title = "Trustable Documentation"
description = "Trustable is a Private AI workbench: a Lovable-like experience for building, running and publishing AI applications on your own infrastructure."
weight = 10
sort_by = "weight"
template = "section.html"
page_template = "page.html"
[extra]
# "Trustable Documentation" is too long for the header and footer nav strips.
nav_title = "Documentation"
+++

Trustable is a **Private AI workbench**: a Lovable-like experience for building,
running and publishing AI applications that never leave your own infrastructure.
You describe what you want, Trustable writes it, and the result runs on your
hardware — your models, your data, your cluster.

This documentation covers the two things you do first: choosing the AI provider
that powers the assistant, and creating and managing your applications.

## How Trustable works

Trustable runs as a single local server that gives you three things at once:

- **A workbench** — the web UI where you list applications, edit their
  configuration, and launch them.
- **An AI coding assistant** — the agent that turns a written description into
  a working frontend, backend actions and data wiring.
- **A complete runtime** — Kubernetes, S3, PostgreSQL, Redis, object storage and
  serverless functions, already integrated, so a generated application has
  somewhere real to run.

Each application you create lives in its own repository. Trustable keeps a
durable copy of it and checks it out into a working area whenever you launch it,
so you can edit, run, revert and publish without ever losing the source of truth.

## Two states of an application

Every application in Trustable is in one or both of these states:

- **Development** — checked out and running locally, so you can iterate on it
  with the AI assistant and see changes immediately.
- **Production** — published to your cluster, reachable by its own URL, serving
  real users.

The workbench shows both at a glance, and you move an application from one to
the other with a single action.

- [setup](setup.md)
- [configuration](config.md)
- [app chat](chat.md)
- [app list](list.md)
- [app edit](edit.md)
- [template](template.md)

