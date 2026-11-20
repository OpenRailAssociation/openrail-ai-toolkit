---
name: project-onboarding
description: >
  Onboard a project into the OpenRail Association after the board accepted it: check the
  onboarding tracking issue against the actual state of all repos involved, report what is
  done and what is missing, and prepare the missing changes as local branches.
license: Apache-2.0
tags:
  - openrail
  - onboarding
  - technical-committee
---

# Project Onboarding

Work through the onboarding of a newly accepted OpenRail project. Onboarding touches several repos, each with its own conventions; most of the work is finding out what is already done. The checklist itself lives in the [onboarding issue template](https://github.com/OpenRailAssociation/technical-committee/blob/main/.github/ISSUE_TEMPLATE/onboarding-new-project.md); each project has a tracking issue with the label `Onboarding`.

## Prerequisites

- `gh` CLI authenticated
- Local checkouts of the repos to change: `technical-committee`, `openrail-org-config`, `website`

## Facts to collect

Two facts cannot be derived from the repos. Get them before preparing any change, and ask the user if they are not in the tracking issue:

- **Board vote date.** From the board's Loomio poll if accessible, otherwise ask.
- **Project representative** in the Technical Committee, with their GitHub handle. The proposal lists maintainers, not the representative.

## Steps

1. **Read the tracking issue** including comments: `gh issue view <n> --repo OpenRailAssociation/technical-committee --comments`. Note the proposal PR, the canonical repo name(s), and which items are ticked.

2. **Check every item against the actual state**, not only the checkboxes. Ticked items can be incomplete and unticked items can be done.

   | Item | Where to check |
   |---|---|
   | Proposal merged | `gh pr view <proposal-pr> --json state` |
   | Project list | `docs/joining/projects.md` in technical-committee |
   | Members list | `docs/technical-committee/members.md` in technical-committee |
   | TC GitHub team | `teams/org-technical-committee.yaml` in openrail-org-config |
   | License review | a comment in the tracking issue; procedure in `docs/joining/onboarding/license-review.md` in technical-committee, run before the repos are moved |
   | Repos moved | `gh repo list OpenRailAssociation` |
   | Project teams | `teams/project-<repo>.yaml` in openrail-org-config |
   | CODEOWNERS | `.github/CODEOWNERS` in openrail-org-config |
   | Required files | repo root, compared with `project-templates/` in technical-committee; plus `publiccode.yml` |
   | Web site | `data/projects.yml` in website |

   Check the remote (`gh api repos/<org>/<repo>/contents/<path>`) or pull first: local checkouts are often behind. Mailing list, Signal group, and the weekly meeting invitation cannot be checked from here; take them from the issue.

3. **Report** what is done, what is missing, and which items need the user (mailing list, Signal group, meeting invitation, domain transfer). Ask for missing facts.

4. **Prepare changes** on local branches, one branch per repo, committed but not pushed. The user reviews and pushes.

   - **technical-committee**, project list and members list on one branch:
     - Project list, in the right stage section: `* **Name** ([proposal](<link to proposal on main>)), accepted by vote of the board on YYYY-MM-DD`, with each repo URL as a sub-item.
     - Members list, after the last project representative and before the appointed members (new representatives are appended after the last project representative): `* [Full Name](https://github.com/<handle>) (ProjectName)`.
   - **openrail-org-config**:
     - Add the representative to `teams/org-technical-committee.yaml` with a `# ProjectName` comment.
     - The project team file is named after the canonical repo name (`project-msc-viewer.yaml`), the team inside it after the display name (`MscViewer`). Follow an existing project with a base team plus a maintainers team.
     - CODEOWNERS can only reference teams that exist, so it goes in a separate, later PR.
   - **website**: add a line to `data/projects.yml` pointing to the raw URL of the project's own `publiccode.yml`, as the most recent entries do (`https://raw.githubusercontent.com/OpenRailAssociation/<repo>/refs/heads/main/publiccode.yml`). The page renders `name`, `description.en.shortDescription`, `url`, and `developmentStatus`; check the file has them. Preview with `hugo server`.

5. **Hand over**: list the branches and commits, and what the user does manually. Put the tracking issue link in the PR descriptions, not in commit messages.

## Constraints

- Never push, open PRs, or edit the tracking issue unless the user asks.
- DCO sign-off (`git commit -s`) is required in technical-committee only. The website uses conventional commits (`projects: add <name>`).
- Do not guess the vote date or the representative.
- Repo transfers and domain transfers need organization owners; describe the step, do not attempt it.
