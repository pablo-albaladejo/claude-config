---
name: 12-factor
description: The Twelve-Factor App methodology — design principles for portable, scalable, maintainable software-as-a-service applications. Use when reviewing or designing app configuration, deployment, processes, logging, and dev/prod parity.
triggers:
  - 12-factor
  - twelve-factor
  - config in environment
  - runtime config
  - dev/prod parity
  - environment variables
  - stateless processes
  - port binding
  - disposability
  - log streams
---

# The Twelve-Factor App

Reference: https://12factor.net

A methodology for building software-as-a-service apps that are portable, scalable, and maintainable. Apply these factors when designing, reviewing, or debugging any app configuration, deployment pipeline, or runtime behavior.

---

## Factor I — Codebase

**One codebase tracked in revision control, many deploys.**

- One repo → many deploys (sandbox, prod, local)
- Multiple apps share code via dependency packages, never by forking the repo
- Each deploy is the same codebase at a different commit

| ✅ Compliant | ❌ Non-compliant |
|---|---|
| Monorepo with packages, single source of truth | Separate repos for sandbox vs prod |
| Feature branches merged to main, deployed from there | Hotfix applied directly to prod, never merged |

---

## Factor II — Dependencies

**Explicitly declare and isolate dependencies.**

- All dependencies declared in a manifest (`package.json`, `pyproject.toml`, etc.)
- No reliance on system-wide packages
- Dependency isolation (e.g. `node_modules`, `venv`) prevents bleed-through

| ✅ Compliant | ❌ Non-compliant |
|---|---|
| `pnpm install --frozen-lockfile` in CI | `npm install` (allows drift from lockfile) |
| All deps in `package.json` | `brew install imagemagick` expected on host |

---

## Factor III — Config

**Store config in the environment, never in code.**

Config is anything that varies between deploys (credentials, hostnames, Cognito pool IDs, feature flags). It must come from the environment at runtime, not be baked into the artifact at build time.

> **The litmus test:** Can you open-source the codebase right now, without compromising any credentials or environment-specific values?

| ✅ Compliant | ❌ Non-compliant |
|---|---|
| Lambda reads `process.env.COGNITO_POOL_ID` at runtime | `VITE_COGNITO_POOL_ID` baked into JS bundle at build time |
| Frontend fetches `/config.json` on startup | Cognito pool ID hardcoded in `use-auth.tsx` |
| SSM Parameter Store / Secrets Manager at runtime | `.env.production` committed to repo |
| CloudFront serves environment-specific `config.json` | Build step reads SSM and writes values into JS bundle |

### Serverless / SPA pattern

SPAs cannot read `process.env` at runtime. The correct 12-factor pattern:

```
CDK deploy → writes config.json to S3/CloudFront origin
App startup → fetch('/config.json') → initialise SDK with runtime values
```

Never pass environment-specific values as Vite `define`/`env` — that bakes them in at build time and makes the artifact non-portable across environments.

---

## Factor IV — Backing Services

**Treat backing services as attached resources.**

A backing service is any service consumed over the network: databases, queues, caches, Cognito pools, third-party APIs. They are attached resources, swappable without code changes — only config changes.

| ✅ Compliant | ❌ Non-compliant |
|---|---|
| Cognito pool ID from config/env | Pool ID hardcoded in source |
| DynamoDB table name from env var | `const TABLE = 'deepgent-prod-sessions'` in code |
| Can swap prod DB for a test DB via config | Requires code change to point to different store |

---

## Factor V — Build, Release, Run

**Strictly separate build and run stages.**

```
Build   → transform code into executable artifact (compile, bundle, package)
Release → combine artifact + environment config → immutable release
Run     → execute the release in the environment
```

- Artifacts must be **environment-agnostic** — the same binary/bundle works in any environment
- Config is injected at the Release stage, not the Build stage
- Every release has a unique ID (semver, timestamp, commit SHA)
- Releases are immutable — never modify a deployed release; create a new one

| ✅ Compliant | ❌ Non-compliant |
|---|---|
| JS bundle has no env-specific values; config.json injected at release | `pnpm build` reads sandbox SSM, bakes pool IDs into bundle |
| Release artifact works in sandbox and prod unchanged | Separate builds for sandbox and prod |
| `release.json` with version + commit SHA in artifact | Mutable "latest" artifact overwritten on every deploy |

### Pipeline model

```
Source ──► Build ──► [env-agnostic artifact]
                           │
                    ┌──────┴──────┐
                    │   Release   │ ← inject env config here
                    └──────┬──────┘
                           │
                       ┌───┴───┐
                       │  Run  │
                       └───────┘
```

---

## Factor VI — Processes

**Execute the app as one or more stateless processes.**

- Processes are stateless and share-nothing
- Any data that must persist lives in a backing service (DynamoDB, S3, ElastiCache)
- No sticky sessions; no in-memory state shared across requests

| ✅ Compliant | ❌ Non-compliant |
|---|---|
| Session data in DynamoDB/ElastiCache | Session stored in Lambda memory across invocations |
| Each Lambda invocation is independent | Relies on `/tmp` cache being warm between calls |

---

## Factor VII — Port Binding

**Export services via port binding.**

The app is self-contained and exports HTTP by binding to a port. No web server injection (Apache, nginx as app glue) — the app itself is the web server.

| ✅ Compliant | ❌ Non-compliant |
|---|---|
| Hono app binds to `PORT` env var | App requires nginx to proxy to it |
| Lambda handler is self-contained | App depends on container's pre-installed runtime |

---

## Factor VIII — Concurrency

**Scale out via the process model.**

- Scale horizontally by adding more processes, not by making a single process larger
- Different workloads run as different process types (web, worker, scheduler)

| ✅ Compliant | ❌ Non-compliant |
|---|---|
| Lambda concurrency scales automatically | Single-threaded server with `cluster` module hack |
| Separate Lambda for background jobs | Web handler spawns background threads |

---

## Factor IX — Disposability

**Maximize robustness with fast startup and graceful shutdown.**

- Processes start quickly (seconds, not minutes)
- Processes shut down gracefully on `SIGTERM`
- Crash-only design: safe to kill at any time

| ✅ Compliant | ❌ Non-compliant |
|---|---|
| Lambda cold starts < 1s | Initialization requires loading 500MB into memory |
| No in-flight requests left dangling on shutdown | Request handler ignores cancellation signals |

---

## Factor X — Dev/Prod Parity

**Keep development, staging, and production as similar as possible.**

Three gaps to minimize:
- **Time gap**: deploy frequently (continuous deployment)
- **Personnel gap**: developers deploy their own code
- **Tools gap**: same backing services in dev as prod (same DB engine, same queue)

| ✅ Compliant | ❌ Non-compliant |
|---|---|
| Same Cognito pool type in sandbox and prod | Sandbox uses mock auth, prod uses real Cognito |
| Same DynamoDB in all envs (different table names) | SQLite locally, DynamoDB in prod |
| Sandbox uses same CDK stack as prod | Different infrastructure configs per env |

---

## Factor XI — Logs

**Treat logs as event streams.**

- App never manages log files or log routing
- Writes to stdout/stderr as an unbuffered stream
- The execution environment captures and routes logs (CloudWatch, Datadog, etc.)

| ✅ Compliant | ❌ Non-compliant |
|---|---|
| `console.log(JSON.stringify(event))` | Write to `/tmp/app.log`, rotate manually |
| Lambda stdout → CloudWatch automatically | App ships logs to S3 directly |
| Structured JSON lines | Unstructured multi-line log entries |

---

## Factor XII — Admin Processes

**Run admin/management tasks as one-off processes.**

- DB migrations, data backups, one-time scripts run as isolated one-off processes
- Same codebase, same config, same environment as the app
- Never run interactively on a production server

| ✅ Compliant | ❌ Non-compliant |
|---|---|
| Migration Lambda triggered from CI/CD | SSH into EC2 and run `node migrate.js` manually |
| `pnpm --filter @app/backend migrate` in buildspec | Manual `aws dynamodb` commands run in console |

---

## Common Violations in Serverless / SPA Apps

| Violation | Factor | Fix |
|---|---|---|
| Vite bakes `VITE_COGNITO_POOL_ID` into JS bundle at build time | III, V | Serve `config.json` from CloudFront; app fetches it at startup |
| Lambda reads SSM at module load, caches in memory across invocations | III, VI | Read SSM at cold start only, or use Parameter Store SDK caching |
| Hardcoded DynamoDB table names in Lambda code | IV | Pass table names as env vars via CDK `environment` block |
| Different CloudFormation stacks for sandbox vs prod | X | Same stack, different CDK context values |
| `SESSION_SECRET` passed as CDK context arg (visible in CF template) | III | Store in Secrets Manager; read at runtime |
| `.env.production` committed to repo | III | All secrets in SSM/Secrets Manager; `.env` only for local dev, in `.gitignore` |
| S3 bucket name hardcoded in Lambda | IV | Pass as env var from CDK construct |

---

## Runtime Config Injection Pattern (SPA)

When a Single Page App needs environment-specific config (API URLs, Cognito pool IDs, feature flags):

```typescript
// ❌ WRONG — baked in at Vite build time
const POOL_ID = import.meta.env.VITE_COGNITO_POOL_ID;

// ✅ CORRECT — fetched at runtime
const config = await fetch('/config.json').then(r => r.json());
const POOL_ID = config.cognitoPoolId;
```

CDK generates `config.json` during deploy:

```typescript
// In CDK stack
new BucketDeployment(this, 'config-json', {
  sources: [Source.jsonData('config.json', {
    cognitoPoolId: cognito.companyPool.userPoolId,
    cognitoClientId: cognito.companyClient.userPoolClientId,
    apiUrl: `https://api.${domainName}`,
  })],
  destinationBucket: siteBucket,
  distribution: cloudFrontDistribution,
  distributionPaths: ['/config.json'],
});
```

The JS bundle is now **environment-agnostic** — the same artifact deploys to sandbox and prod. Only `config.json` differs.
