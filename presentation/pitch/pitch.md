---
marp: true
theme: default
paginate: true
size: 16:9
title: Trustable — Investor Pitch
description: Build apps with prompts, using Local AI on a full stack environment you own.
style: |
  :root {
    --navy: #0b1b3a;
    --navy-2: #12294f;
    --blue: #1e63d0;
    --cyan: #22c1e8;
    --muted: #55637d;
  }
  /* Light content slides: soft gradient ground, cyan accent down the edge,
     and a faint blue bloom in the corner so nothing is a flat fill. */
  section {
    background:
      radial-gradient(900px 520px at 100% 0%, rgba(34,193,232,0.14), transparent 60%),
      radial-gradient(700px 500px at 0% 100%, rgba(30,99,208,0.10), transparent 60%),
      linear-gradient(160deg, #ffffff 0%, #eef3fb 100%);
    color: var(--navy);
    font-family: "Work Sans", system-ui, -apple-system, sans-serif;
    font-size: 25px;
    padding: 56px 70px 56px 84px;
    border-left: 12px solid var(--cyan);
  }
  section h1 {
    color: var(--navy);
    font-size: 54px;
    letter-spacing: -0.02em;
    margin-bottom: 0.3em;
  }
  section h2 {
    color: var(--blue);
    font-size: 38px;
    letter-spacing: -0.01em;
    margin-top: 0;
  }
  section h3 { color: var(--muted); font-size: 25px; font-weight: 600; }
  strong { color: var(--blue); }
  a { color: var(--blue); }
  /* A rule under headings, echoing the site's hairline. */
  section:not(.lead) h2 {
    border-bottom: 3px solid var(--cyan);
    padding-bottom: 0.2em;
    display: inline-block;
  }
  /* Lead slides: deep navy gradient with a cyan glow. Everything on them is
     light on dark — never dark text on the navy. */
  section.lead {
    background:
      radial-gradient(1000px 620px at 78% 12%, rgba(34,193,232,0.30), transparent 62%),
      radial-gradient(760px 560px at 12% 96%, rgba(30,99,208,0.42), transparent 62%),
      linear-gradient(155deg, #0b1b3a 0%, #12294f 55%, #081426 100%);
    color: #ffffff;
    text-align: center;
    justify-content: center;
    border-left: 12px solid var(--cyan);
  }
  section.lead h1 { color: #ffffff; }
  section.lead h2 { color: var(--cyan); border: none; }
  section.lead h3 { color: #c7d6ef; }
  section.lead p { color: #e3ecfa; }
  section.lead strong { color: var(--cyan); }
  section.lead a { color: var(--cyan); }
  /* The logo is dark artwork: set it on a light plate so it stays readable
     against the navy ground. */
  .plate {
    display: inline-block;
    background: #ffffff;
    border-radius: 14px;
    padding: 18px 30px;
  }
  .cols {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 2rem;
    align-items: center;
  }
  .three {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
    gap: 1.5rem;
    text-align: center;
    font-size: 21px;
  }
  .three img { border-radius: 8px; }
  .todo {
    background: #fff5d6;
    border-left: 5px solid #e0a800;
    padding: 0.6em 1em;
    font-size: 21px;
    color: #6b5200;
  }
  footer { color: var(--muted); font-size: 16px; }
---

<!-- _class: lead -->

<span class="plate">

![w:420](images/logo-trustable.png)

</span>

# IT is Trustable

## Build apps with prompts — on **AI you own**

Build, run and publish AI applications
that **never leave your own infrastructure**

---

## The Problem

<div class="cols">
<div>

Every AI development platform today asks you to make the same trade.

- To build with AI, you **send your code and your data** to someone else's cloud
- For regulated industries, defence, healthcare and public administration, that is **not an option**
- The alternative has been to **give up the AI experience entirely** and build by hand

### The result

Organizations that most need AI leverage are the ones least able to use it.

</div>
<div>

![w:420](images/private-document.png)

</div>
</div>

---

<!-- _class: lead -->

# The Solution

## Build apps with prompts, using **Local AI**, on a **full stack environment**

![w:620](images/mac-spark.png)

The model runs on your hardware. The stack runs on your hardware.
Nothing ever leaves your machine.

---

## Build Apps with Local AI on your PC

<div class="cols">
<div>

Customize and build **full stack applications with prompts**, using Local, Private or Sovereign AI.

Describe what you want and Trustable writes it — **frontend, backend actions and data wiring** — and runs it on the stack it ships with.

It is Nuvolaris technology *inside* the platform, not a third-party tool: what it builds runs on your own stack, on your own hardware.

**No code or data leaves your infrastructure.**

</div>
<div>

![w:460](images/mac-spark.png)

![w:340](images/logo-nuvolaris.png)

</div>
</div>

---

## Start From Templates — NuvolarIA

<div class="cols">
<div>

![w:250](images/logo-nuvolaria.png)

**NuvolarIA is a set of applications**, not a single product — a catalog of ready-to-use apps shipped with the platform.

Pick one and customise it to your needs with the AI, instead of starting from scratch.

Mini CRM, project dashboards, API monitors, document and mail assistants — each one a real, deployable application rather than a demo.

</div>
<div>

![w:270](images/trustable-ai-appsuite.png) ![w:270](images/trustable-ai-minicrm.png)

*Applications built and running on Trustable*

</div>
</div>

---

## Deploy Anywhere

<div class="cols">
<div>

Deploy in your **private server** with a complete stack for AI.

From a desktop appliance, to a **GPU server in your own rack**, to a **sovereign data centre** — the same application, the same platform, no rewrite.

</div>
<div class="three" style="grid-template-columns: 1fr 1fr;">
<div>

![w:330](images/private-ai.png)

**Your server**

</div>
<div>

![w:210](images/sovereign-ai.png)

**Your data centre**

</div>
</div>
</div>

---

## A Complete Stack, Not a Component

<div class="cols">
<div>

Frontend, APIs, database and storage, hosting, compute, FAAS, security, rate limiting, caching, load balancing, logging and recovery.

**Kubernetes · S3 · PostgreSQL · Redis · Prometheus · Velero**

### Why this matters

Competitors sell a model or a UI. Trustable ships the **entire production stack** the application actually needs — which is why it can run somewhere that has no cloud at all.

</div>
<div>

![w:520](images/nuvolaris-stack.png)

</div>
</div>

---

## Scale Everywhere — Three Markets, One Platform

<div class="three">
<div>

![w:270](images/local-ai.png)

**Local AI**
*One desk*

The NuvolarIA appliance on your own desk. Your models and data never leave the machine.

</div>
<div>

![w:270](images/private-ai.png)

**Private AI**
*One organization*

A GPU server in your own rack, serving whole teams behind your firewall.

</div>
<div>

![w:210](images/sovereign-ai.png)

**Sovereign AI**
*One nation*

A data centre operated as an AI provider, under your own jurisdiction.

</div>
</div>

---

## One Platform, Every Scale

![w:1000](images/trustable-machines.png)

The same application runs from a **laptop to a sovereign cloud**.

Customers enter at the tier they can afford today and grow into the next one — the platform, and the relationship, scales with them.

---

## What People Build

![w:900](images/layout-ai-applications.png)

The high-value use cases are exactly the ones organizations **cannot** send to a public cloud: internal mail, customer records, confidential documents.

---

## Technology & Moat

<div class="cols">
<div>

- **Owned end to end.** The serverless engine, the platform services and the AI builder are Nuvolaris technology — not a wrapper over a third-party API
- **No vendor dependency.** No per-token cost to a model provider, and no upstream vendor who can change terms
- **Deployment is the product.** A complete, integrated, self-hosted stack is a years-long engineering effort
- **Open foundation.** Kubernetes and the CNCF ecosystem, so customers are never locked in

</div>
<div>

![w:400](images/logo-nuvolaris.png)

![w:420](images/trustable-ai-projectdashboard.png)

</div>
</div>

---

## Traction

<div class="cols">
<div>

<div class="todo">

**TODO — supply real figures before sending.** Customers and pilots, deployed appliances, revenue or ARR, pipeline, notable logos, community or download numbers.

</div>

<div class="todo">

**TODO — Team.** Founders, relevant background, key hires, advisors.

</div>

<div class="todo">

**TODO — Business model.** Appliance sale, platform licence, support subscription, per-node pricing.

</div>

</div>
<div>

![w:400](images/trustable-machines.png)

</div>
</div>

---

## The Ask

<div class="cols">
<div>

<div class="todo">

**TODO — supply before sending.** Amount raised, round type, use of funds, key milestones this round buys, current investors.

</div>

</div>
<div>

![w:420](images/local-ai.png)

</div>
</div>

---

<!-- _class: lead -->

<span class="plate">

![w:360](images/logo-trustable.png)

</span>

# IT is Trustable

## Build with AI. **Keep your data.**

[trustable.it](https://trustable.it) · [trustable.it/documentation](https://trustable.it/documentation/)
