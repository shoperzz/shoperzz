# Security Policy — Shoperzz

## Why Security is Critical Here

Shoperzz handles real financial transactions — Orange Money, Wave, MTN MoMo — in markets where every CFA franc counts. A security flaw is not just a bug. It's a potential loss of money for real users, and an irreparable loss of trust for the project.

We take security seriously. If you discover a vulnerability, we are grateful — and we act fast.

---

## Supported Versions

| Version | Security Support |
|---|---|
| latest (1.x) | ✅ Supported — patches applied |
| 0.x (beta) | ⚠️ Best effort — migration to 1.x recommended |
| < 0.x | ❌ Not supported |

---

## How to Report a Vulnerability

### ⚠️ DO NOT open a public GitHub issue

A publicly exposed flaw before correction endangers all projects using Shoperzz in production. Public issues are indexed immediately.

### The Correct Procedure

**1. Send an email to <security@shoperzz.dev>**

Use the subject: `[SECURITY] Short description of the flaw`

Include in your report:

- Precise description of the vulnerability
- Affected components (`@shoperzz/core`, `@shoperzz/plugin-payment-orange-money`, etc.)
- Conditions required to exploit the flaw
- Steps to reproduce (proof of concept if possible)
- Estimated impact (exposed data, affected transactions, etc.)
- Your suggested fix if you have one

**2. Encryption (optional but recommended for critical flaws)**

Our public PGP key is available at: <https://shoperzz.dev/.well-known/security.txt>

**3. Response Time**

| Step | Deadline |
|---|---|
| Acknowledgment of receipt | 48h maximum |
| Initial assessment | 5 business days |
| Patch developed | Depending on criticality (see below) |
| Patch release | With the next release |
| Public disclosure | After the patch is deployed |

---

## Criticality Levels and Remediation Deadlines

| Level | Description | Target Deadline |
|---|---|---|
| **Critical** | Remote code execution, unauthorized access to payments, API key exposure | 48h |
| **High** | Authentication bypass, customer data exposure, transaction manipulation | 7 days |
| **Medium** | Limited information leakage, partial denial of service | 30 days |
| **Low** | Limited impact, minor bypasses | 90 days |

---

## What is in Scope

- `@shoperzz/core` — the main engine
- `@shoperzz/cli` — the `npx shoperzz` command
- All official `@shoperzz/plugin-*` plugins
- Official project GitHub Actions
- Official documentation (injections, malicious redirects)

---

## What is Out of Scope

- Community plugins `@shoperzz-community/*` — contact their maintainer directly
- Projects built with Shoperzz — contact the relevant project team
- Vulnerabilities in Vendure, NestJS, or other third-party dependencies — report them directly to those projects

---

## Our Commitment to Security Researchers

If you report a vulnerability to us in good faith following this procedure:

- **We will not take any legal action** against you
- **We will credit you** in the CHANGELOG and release notes (unless you prefer to remain anonymous)
- **We will keep you informed** of the patch's progress
- **We will notify you** before public disclosure

---

## Disclosure Policy

We follow **coordinated disclosure**:

1. The researcher privately reports the flaw to us
2. We develop and test the patch
3. We deploy the patch in a release
4. 7 days after the release, the flaw is publicly documented in the CHANGELOG
5. The researcher can publish their own research after step 4

If a patch takes more than 90 days, we work with the researcher to agree on a disclosure date.

---

## Project Security Practices

These practices are continuously applied in Shoperzz:

- **Weekly dependency audit** — automated `pnpm audit` every Monday via GitHub Actions
- **CodeQL analysis** — static TypeScript code analysis on every PR
- **Mandatory HMAC validation** — all payment webhooks are validated with constant-time comparison
- **Sensitive data** — no API keys or secrets in code or logs
- **Mandatory soft delete** — financial data is never physically deleted
- **Declarative permissions** — each plugin explicitly declares the access it needs

---

*Last updated: see git history of this file*
*Security contact: <security@shoperzz.dev>*
