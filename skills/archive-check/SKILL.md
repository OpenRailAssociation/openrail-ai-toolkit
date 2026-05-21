---
name: archive-check
description: >
  Check for open archive PRs in OpenRail-Playground repos that are older than one week,
  then archive those repos (or provide URLs for manual archiving).
license: Apache-2.0
tags:
  - openrail
  - playground
  - archive
  - maintenance
---

# Archive Check

Find open archive PRs in the OpenRail-Playground organization that have passed the one-week notice period, and archive the repos.

## Prerequisites

- `gh` CLI authenticated with admin access to `OpenRail-Playground` (needed for archiving)

## Steps

1. **Find open archive PRs across the organization.** Search for PRs that indicate archival intent:

   ```
   gh search prs "archive" --owner OpenRail-Playground --state open --json repository,title,createdAt,url
   ```

   From the results, filter to PRs whose title signals archival (e.g. contains "archive", "archiving", "deprecate", "end of life"). Discard unrelated matches.

2. **Filter to PRs older than one week.** From the results, identify PRs where `createdAt` is more than 7 days ago.

3. **Check for comments on each eligible PR.**

   ```
   gh pr view <pr-url> --json comments --jq '.comments | length'
   ```

4. **Present the list for review.** Show the user a table of repos ready to archive, including:
   - Repo name
   - PR URL
   - PR creation date
   - Number of comments (flag any with comments > 0 so the user can review them before deciding)

   Wait for the user to confirm which repos to proceed with.

5. **For each approved repo:**

   a. **Merge the PR** (so the archive notice is in the README):

   ```
   gh pr merge <pr-url> --merge
   ```

   b. **Archive the repo:**

   ```
   gh repo archive OpenRail-Playground/<repo> --yes
   ```

   c. Report the result.

6. **For repos not yet past the notice period**, list them with their creation date and days remaining.

## Constraints

- Never archive a repo whose PR is less than 7 days old.
- If `gh repo archive` fails due to insufficient permissions, output a list of URLs for manual archiving: `https://github.com/OpenRail-Playground/<repo>/settings` (the archive button is under Settings > Danger Zone).
- If there are comments on the PR raising objections, flag the repo to the user instead of archiving.
