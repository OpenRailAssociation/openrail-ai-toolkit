---
name: archive-playground-repo
description: >
  Add an archive notice to a repo's README in the OpenRail-Playground organization
  and open a PR announcing the repo will be archived in one week.
license: Apache-2.0
tags:
  - openrail
  - playground
  - archive
  - maintenance
---

# Archive Playground Repo

Prepend an archive notice to a repository's README and open a pull request. The PR serves as the one-week notice before the repo is actually archived.

## Prerequisites

- `gh` CLI authenticated with write access to the target repo in `OpenRail-Playground`

## Message templates

**README notice:**

```markdown
> [!WARNING]
> This repository has been archived. It is no longer maintained and no contributions are accepted. The code is provided as-is for reference purposes.
```

**Commit message:**

```
Add archive notice to README
```

**PR title:**

```
Archive this repository
```

**PR body:**

```
This repository is no longer actively maintained. It will be archived in one week. If you have concerns, please comment on this PR.
```

## Steps

1. **Identify the repo.** The user provides a repo name within `OpenRail-Playground`. Confirm it exists and is not already archived:

   ```
   gh repo view OpenRail-Playground/<repo> --json isArchived,name,defaultBranchRef
   ```

   Also check if an archive PR or branch already exists:

   ```
   gh pr list --repo OpenRail-Playground/<repo> --head archive-notice --state open --json url
   ```

   If a PR already exists, report its URL and stop. If the repo is already archived, stop.

2. **Check for recent activity.** Look at recent commits, issues, and PRs:

   ```
   gh api repos/OpenRail-Playground/<repo>/commits?per_page=1 --jq '.[0] | {date: .commit.committer.date, message: .commit.message}'
   gh api repos/OpenRail-Playground/<repo>/issues?state=open&per_page=5 --jq '.[] | {number, title, updated_at}'
   gh api repos/OpenRail-Playground/<repo>/pulls?state=open&per_page=5 --jq '.[] | {number, title, updated_at}'
   ```

   If there is activity within the last 6 months (commits, open issues, or open PRs), surface it to the user and ask whether to proceed.

3. **Present messages for review.** Show the user all four messages (from the templates above), filled in with the repo name if applicable. Wait for approval or edits before proceeding.

4. **Get the default branch SHA.** Use the default branch name from step 1:

   ```
   gh api repos/OpenRail-Playground/<repo>/git/refs/heads/<default-branch> --jq '.object.sha'
   ```

5. **Create the branch.**

   ```
   gh api repos/OpenRail-Playground/<repo>/git/refs \
     -f ref=refs/heads/archive-notice \
     -f sha=<sha-from-step-4>
   ```

6. **Get the current README.** Fetch content and SHA (needed for the update):

   ```
   gh api repos/OpenRail-Playground/<repo>/contents/README.md --jq '{sha: .sha, content: .content}'
   ```

   Base64-decode the content.

7. **Prepend the archive notice.** Prepend the approved README notice followed by a blank line to the existing content. Base64-encode the result.

8. **Push the updated README to the branch.**

   ```
   gh api repos/OpenRail-Playground/<repo>/contents/README.md -X PUT \
     -f message="<approved commit message>" \
     -f content=<base64-encoded-new-content> \
     -f sha=<file-sha-from-step-6> \
     -f branch=archive-notice
   ```

9. **Open the pull request.**

   ```
   gh pr create \
     --repo OpenRail-Playground/<repo> \
     --head archive-notice \
     --title "<approved PR title>" \
     --body "<approved PR body>"
   ```

10. **Report.** Confirm the PR URL to the user.

## Constraints

- Do not merge the PR — it stays open as the notice period.
- The README notice is about the repo's state for visitors, not about the archiving process.
- One repo per invocation. Run the skill multiple times for multiple repos.
