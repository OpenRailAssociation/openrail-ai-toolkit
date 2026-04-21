# Stage Criteria

Criteria for each stage of the OpenRail incubation process. Source: `docs/incubation/process/index.md` in the technical-committee repo.

## Stage 1 (Onboarded)

| # | Criterion | Check |
|---|---|---|
| 1 | Project contributes to solving railway sector challenges | Questionnaire: description, why a good candidate |
| 2 | Project is clearly described | Questionnaire completeness, README quality |
| 3 | Maintainers are designated | Questionnaire: maintainers field (MAINTAINERS.md is an onboarding activity) |
| 4 | Adopts OpenRail Code of Conduct | Questionnaire: concluding statement (CODE_OF_CONDUCT.md is added during onboarding) |
| 5 | Adheres to OpenRail IP Policy | OSI-approved license in repo, intent to transfer trademarks |

## Stage 2 (Qualified)

| # | Criterion | Check |
|---|---|---|
| 1 | Healthy base of contributors | Commit stats, contributor count |
| 2 | Clear release process | CHANGELOG, versioning, signed releases, SBOMs |
| 3 | Specs have reference implementation | Repo or linked repos |
| 4 | Open governance process | Governance docs, decision-making transparency |
| 5 | Public business roadmap | Roadmap doc or project board |
| 6 | Used in production | Questionnaire, adopters list |
| 7 | REUSE compliant | `reuse lint` passes |
| 8 | DCO enforced | Commit sign-offs, CI checks |
| 9 | Security best practices | Pinned deps, dep update automation, Scorecard ≥ 5/10, SECURITY.md |

### Stage 2 inspection notes: governance and roadmap

Criteria 4 and 5 require deeper inspection than checking for file existence:

**Open governance (criterion 4):**
- Read GOVERNANCE.md — does it describe how decisions are actually taken, or is it a template?
- How are committers and maintainers added? Is the process documented and has it been used?
- Are decisions visible? Look for: public meeting notes, decision records (ADRs), discussion in issues/PRs
- Communication channels: are they listed and active? Can an outsider find where to participate?

**Public business roadmap (criterion 5):**
- Is there a roadmap document or GitHub project board?
- Is it actively maintained or a stale snapshot of internal planning? Check last update date.
- Does it reflect actual development activity? Compare roadmap items to recent commits/PRs.
- GitHub Projects: `gh project list --owner <org>` — are there project boards linked to the repo?
- Milestones: `gh api repos/<owner>/<repo>/milestones` — are they used and current?
- Is the roadmap driven by external input (issues, community requests) or purely internal?

## Stage 3 (Adopted)

| # | Criterion | Check |
|---|---|---|
| 1 | Used in production by ≥ 3 independent adopters | Adopters list |
| 2 | Public list of adopters | publiccode.yml or equivalent |
| 3 | Committers from ≥ 2 independent organizations | Committer stats |
| 4 | Regular stable releases | Release history |
| 5 | Time-bound security update process | SECURITY.md |
| 6 | Independent third-party security audit | Audit report |
| 7 | OpenSSF Best Practices Badge ≥ 8/10 | Badge check |
| 8 | SBOMs for all release artifacts | Release docs |
| 9 | Adequate funding | Funding transparency |
