---
name: incubation-review
description: >
  Use when reviewing an OpenRail incubation application. Handles setting up a review workspace,
  running license scans, vulnerability scans, secrets detection, REUSE compliance checks,
  and producing a structured review report against OpenRail stage criteria.
license: Apache-2.0
tags:
  - openrail
  - incubation
  - review
  - governance
---

# OpenRail Incubation Review

Review a project's application for a stage in the OpenRail incubation process.

## Prerequisites

- `gh` CLI authenticated with GitHub
- Review tools installed (see `references/tools.md`)
- The OpenRail `technical-committee` repo available locally

## Setup

Create a review workspace for the project:

```
make -f <path-to-this-skill>/assets/Makefile.template setup \
  REPO_URL=<github-clone-url> \
  REPO_ORG=<github-org> \
  REPO_NAME=<repo-name> \
  REVIEW_DIR=~/openrail-src/REVIEWS/<project-name>
```

This clones the repo to `~/openrail-src/<org>/<repo>` and creates the review workspace at `~/openrail-src/REVIEWS/<project-name>/` with per-tool output directories and a Makefile.

## Workspace structure

```
~/openrail-src/REVIEWS/<project-name>/
  ├── Makefile                  # Generated from template, configured for this project
  ├── README.md                 # Review metadata (project, PR, date, stage)
  ├── reuse/                    # reuse lint output
  ├── gitleaks/                 # secrets scan output
  ├── scorecard/                # OpenSSF Scorecard output
  ├── sbom/                     # SBOM generation and enrichment
  ├── grype/                    # vulnerability scan output
  └── licensing/                # license enumeration output
```

## Running tools

From the review workspace directory:

```
make reuse          # REUSE compliance check
make gitleaks       # Secrets scan on git history
make scorecard      # OpenSSF Scorecard (requires GITHUB_TOKEN)
make sbom           # Generate and enrich SBOM
make licensing      # Extract license list from enriched SBOM
make grype          # Vulnerability scan from enriched SBOM
make all            # Run all tools
```

Each target writes output to its own directory. Targets are independent except where noted (licensing and grype depend on sbom). Failed tools do not block others.

Tools can hang (see `references/tools.md` for known failure modes). The Makefile uses timeouts. When running via an agent: run tools one at a time, verify each produced output before moving on, and skip with a note if a tool times out or fails.

## Review workflow

### 1. Fetch the application

```
gh pr diff <number> --repo OpenRailAssociation/technical-committee
```

Read the filled-out questionnaire from the PR diff.

### 2. Evaluate stage criteria

For each criterion of the target stage (see `references/stage-criteria.md`):

- ✅ Met — evidence is clear
- ⚠️ Partially met — vague, incomplete, or raises questions
- ❌ Not met — missing or clearly insufficient

### 3. Inspect the repository

Inspection is tiered. Start with Tier 1; go deeper on request or when findings warrant it.

#### Tier 1 — Manual inspection (always)

No tools required beyond git and standard shell.

1. **Required community files** — per TC project templates:
   - LICENSE, README.md, CODE_OF_CONDUCT.md, CONTRIBUTING.md, MAINTAINERS.md, GOVERNANCE.md
   - SECURITY.md (required for Stage 2+)
2. **Tree overview** — directory structure, language breakdown, file count
3. **License grep** — manual search per TC license review guide:
   - `git grep -i "licen[s|c]e"` / `git grep -iE "copy(right|left)"` / `git grep -i "public domain"`
4. **Secrets grep** — quick scan for obvious leaks:
   - `git grep -iE "(password|secret|api.?key|token)\s*[:=]"` (exclude test fixtures, templates, docs)
5. **Hardcoded values** — URLs, IPs, credentials in config or code
6. **Tech stack verification** — compare actual languages/frameworks to questionnaire claims
7. **Code structure** — organization, separation of concerns, obvious red flags
8. **Test presence** — do test directories/files exist? rough coverage sense
9. **Documentation quality** — beyond README: inline docs, architecture docs, API docs
10. **Issue and PR activity** — not just counts, but movement:
    - `gh issue list --repo <url> --state all --json state --jq 'group_by(.state) | map({state: .[0].state, count: length})'`
    - Are issues being closed or just accumulating? Check ratio of open to closed.
    - Are there recent issues (last 3 months)? Stale issue trackers signal abandoned projects.
    - Any external contributors in issues/PRs, or only the core team?
    - Labels, milestones, project boards — signs of organized planning vs. ad-hoc tracking
11. **Commit history shape** — total commits, time span (first to last), contributors, stars/forks
12. **AI-assisted development** — check for agent configuration files and assess their quality:
    - Known files: `.github/copilot-instructions.md` (GitHub Copilot), `.amazonq/rules/` (Amazon Q), `CLAUDE.md` (Claude Code), `.cursor/rules/` (Cursor), `.agents/skills/` (Agent Skills standard)
    - Presence alone is not enough. Read the files and assess:
      - Do they define coding standards (formatting, type checking, testing)?
      - Do they describe the architecture and project structure?
      - Do they set constraints (e.g. mandatory type hints, specific test patterns)?
      - Or are they generic boilerplate with no project-specific content?
    - Multiple agent config files (e.g. both Copilot and Amazon Q) suggest the team actively uses AI tooling and has thought about guardrails
    - Check commit messages for AI co-authorship signals:
      - `git log --all --format='%b' | grep -iE 'Co-authored-by:.*\b(claude|copilot|cursor|codeium|amazon.q|gemini|openai|chatgpt)\b'`
      - `git log --all --format='%b' | grep -iE 'Assisted-by:'`
      - Claude Code adds `Co-authored-by: Claude <noreply@anthropic.com>` by default; other tools may use `Assisted-by:` trailers
    - Report what you find — this is informational context for the TC, not a positive or negative signal

#### Tier 2 — Automated tooling

Run from the review workspace via `make <target>`. Each tool writes to its own directory. Run what's available, skip with a note what isn't. Never block the review on missing tools.

#### Tier 3 — Deep dive (on request)

1. **Dependency tree analysis** — transitive deps, version pinning, update freshness
2. **Build verification** — does it build from clean checkout per README instructions?
3. **Test execution** — do tests pass? what's the coverage?
4. **Docker verification** — does docker-compose work? what images are pulled?
5. **AI/LLM integration review** — if project uses AI: what APIs, what data flows, what's configurable
6. **Architecture review** — modularity, coupling, extension points

### 4. Write the report

Follow the report format in `references/report-format.md`. The report is a single cohesive document, not a chronological investigation log.

## Rules

- Stage 1 barrier is intentionally low — don't block on nice-to-haves
- Don't evaluate against Stage 2 criteria when reviewing a Stage 1 application
- For Stage 1, the CoC and MAINTAINERS checks are about the questionnaire commitment, not repo files (those come during onboarding)
- For Stage 1, vague or "TBD" answers on roadmap, governance, maturity plan are common — note them but don't block
- Be factual and evidence-based; quote specific files and questionnaire answers
- Include concrete details: actual secret values, specific IPs, exact file paths
- Make file/directory references hyperlinks to the public GitHub repo
- Don't flag AI config files (CLAUDE.md, AGENTS.md) as concerns — note their presence and what they reveal about the development process (relevant context especially for single-developer projects)
- The review is advisory input for the TC — the TC makes the final decision

## TC documentation references

These files in `OpenRailAssociation/technical-committee` inform the review:

- `docs/incubation/process/index.md` — stage criteria and process
- `docs/joining/onboarding/license-review.md` — license review procedure and tools
- `docs/practices/security.md` — security best practices (Scorecard, dependency management, SECURITY.md)
- `docs/practices/reuse.md` — REUSE adoption guide
- `docs/practices/dco.md` — DCO requirements (Stage 2+)
- `docs/joining/onboarding/_index.md` — onboarding process overview
- `.github/ISSUE_TEMPLATE/onboarding-new-project.md` — onboarding checklist
- `project-templates/` — templates for CODE_OF_CONDUCT, CONTRIBUTING, GOVERNANCE, MAINTAINERS, README
