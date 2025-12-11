# Project Atlas

## Problem

* The team ships code, but not safely.
* Local setup is slow.
* Deployments are risky.
* Nobody knows what breaks until users complain.
* Observability is an afterthought.

**Goal:** Make shipping safer, faster, and more predictable — without drowning the team in tooling.

---

# What I Built

I picked three improvements that give the team immediate leverage:

* **Local DX automation** — cut setup time, remove inconsistency, reduce cognitive load.
* **Lightweight observability stack** — logs + metrics that tell you what’s breaking and why.
* **Deployment safety pipeline** — canaries, approvals, structured rollout, safer migrations.

Each one is intentionally small, simple, and opinionated — the minimum system that actually improves reliability.

### 1. Local Developer Experience

**The Problem**

Engineers were spending their mornings fighting Docker commands, mismatched Ruby versions, missing DBs.
Everyone’s machine behaved differently.

**The Solution**

I automated local setup into a handful of Rake tasks:

* docker-compose for consistent environments
* one-command server startup
* one-command DB setup & migrations
* automatic bundle install

**Impact**

* Setup reduced from 30 min → 5 min
* Zero “works on my machine” bugs

**New hires can push code on day one**

Engineers focus on features, not plumbing

**Example:**

```bash
# Before: Multiple manual steps
docker-compose up -d db
docker-compose run api bundle install
docker-compose run api bin/rails db:create
docker-compose run api bin/rails db:migrate
docker-compose run --service-ports api bin/rails server

# After: Single command
rake docker:server
```

### 2. Observability That Doesn’t Get in the Way

**The Problem**

No one could answer basic questions:
* What’s failing?
* How often?
* Which endpoints are slow?
* Are users impacted?

**The Solution**

I added observability primitives that give 80% of the value with 20% of the complexity:

* Structured JSON logs for every request: method, path, status, duration, IP
* Prometheus metrics: request count + duration histograms
* Zero manual instrumentation — works out of the box

**Impact**
* Faster debugging
* Real-time visibility
* Can graph performance immediately
* The team now knows why things break, not just that they break

Example log:
```json
{ "method": "GET", "path": "/restaurants", "status": 200, "duration_ms": 45.2 }
```

### 3. Deployment Safety Pipeline

**The Problem**

* Deployments were “all or nothing.”
* No QA, no staging, no approvals.
* If you break prod, everyone finds out at the same time.

**The Solution**

A simple staged deployment flow:

* CI runs lint + tests
* Auto-deploy to QA
* Integration tests
* Approve migrations
* Canary: 10% traffic
* Approve full rollout

**Impact**

* Canary catches most bad deploys before users see them
* Approval gates stop accidental production pushes
* Clear rollback path
* Engineers deploy with confidence instead of fear

Example:
```
Tag → CI → QA → Integration Tests → [Approve Migrations]
 → [Approve Canary] → [Approve Production]

```

---

## How This Improves Engineering

### Developer Experience

* Fast onboarding
* Predictable local environments
* Clear workflows
* Lower cognitive load
* Immediate feedback through CI + metrics

### Reliability

* Canary limits blast radius
* Approval gates prevent accidental outages
* Logs + metrics give real visibility
* Safer migrations & easier rollback

---

## Trade-offs

### Safety > Speed
Added a few minutes to deployments, removed hours of debugging and days of outages.

### Lightweight > Comprehensive

* Prometheus + logs instead of Datadog/APM.
* Simple pipeline instead of full feature-flag infra.

### Local-first > Cloud-first

* Docker Compose for simplicity; production-ready images for scale.
* The system is intentionally minimal — easy to understand, easy to extend.
---

## Failure Modes and Recovery

### Deployment Fails
* Detected via integration tests or canary metrics
* Rollback: revert tag or redeploy previous image
* Migrations wrapped behind approvals

### Performance Regression

* Detected via Prometheus histograms + log durations
* Canary absorbs impact
* Rollback safe

### Bad Migrations / Data Loss
* Pre-deploy checks
* Manual approval required
* Rollback via db:rollback or backups

### Infra Flakes
* GitHub Actions retry
* Manual deploy fallback
* Health checks protect production

Bias is always toward minimising blast radius.

### Scaling from 5 → 50 Engineers

At 5 engineers, this system is enough.

At 50, the entropy grows — so the platform evolves:
* Feature flags for safe rollouts
* Distributed tracing (OpenTelemetry)
* Error tracking (Sentry / APM)
* Automated migration safety
* Preview environments
* Service mesh / Hystrix (circuit breaks) for resilience
* Better documentation & runbooks

The base architecture supports adding these without rework.

### If I Had Another Day

* Add Sentry for exception tracking
* Introduce feature flags for safer rollouts
* Migration safety tooling
* /health endpoint for deploy validation
* Performance monitoring (p95/p99, slow queries)

Small improvements with high ROI.

### Conclusion

It wasn’t the “perfect infra” that I could think of.,
but it is just enough infrastructure to:

* Make local development painless
* Make production observable
* Make deployments safe
* Make engineers faster, not busier

These improvements give the team leverage today and a foundation they won’t have to rip out tomorrow.