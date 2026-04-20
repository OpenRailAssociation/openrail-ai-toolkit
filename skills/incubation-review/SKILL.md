---
name: incubation-review
description: >
  Use when reviewing an OpenRail incubation application. Handles setting up a review workspace,
  running license scans, vulnerability scans, secrets detection, REUSE compliance checks,
  and producing a structured review report against OpenRail stage criteria.
license: MIT
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

Run the tools (see above), then manually inspect:

- Required community files (LICENSE, README, CODE_OF_CONDUCT, CONTRIBUTING, MAINTAINERS, GOVERNANCE)
- License grep: `git grep -i "licen[s|c]e"`, `git grep -iE "copy(right|left)"`
- Secrets grep: `git grep -iE "(password|secret|api.?key|token)\s*[:=]"`
- Hardcoded URLs, IPs, credentials
- Tech stack verification against questionnaire claims
- Code structure and organization
- Test presence
- Commit history shape and contributor diversity

### 4. Write the report

Follow the report format in `references/report-format.md`. The report is a single cohesive document, not a chronological investigation log.

## Rules

- Stage 1 barrier is intentionally low — don't block on nice-to-haves
- For Stage 1, the CoC and MAINTAINERS checks are about the questionnaire commitment, not repo files (those come during onboarding)
- Be factual and evidence-based; quote specific files and questionnaire answers
- Include concrete details: actual secret values, specific IPs, exact file paths
- Make file/directory references hyperlinks to the public GitHub repo
- Don't flag AI config files (CLAUDE.md, AGENTS.md) as concerns — note them as development context
