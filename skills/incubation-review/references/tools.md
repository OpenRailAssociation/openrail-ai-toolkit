# Review Tools

Tools used during incubation reviews. Install before first review.

## Python tools (via uv)

```
uv tool install reuse
uv tool install compliance-assistant
```

## Brew tools

```
brew install syft grype scorecard gitleaks
```

## Tool purposes

| Tool | Purpose |
|---|---|
| [reuse](https://github.com/fsfe/reuse-tool) | REUSE compliance check |
| [compliance-assistant](https://github.com/OpenRailAssociation/compliance-assistant) | SBOM generation, license enrichment and enumeration |
| [syft](https://github.com/anchore/syft) | SBOM generation (used by compliance-assistant) |
| [grype](https://github.com/anchore/grype) | Vulnerability scanning from SBOM |
| [scorecard](https://github.com/ossf/scorecard) | OpenSSF Scorecard |
| [gitleaks](https://github.com/gitleaks/gitleaks) | Secrets detection in git history |

## Notes

- scorecard requires `GITHUB_TOKEN` environment variable
- compliance-assistant licensing with `--simplify` requires `flict` (optional)
- compliance-assistant sbom requires `-g syft` flag to specify the generator

## Known failure modes

Tools can hang or block. The Makefile template wraps every invocation in a timeout (default 120s, override with `TIMEOUT=<seconds>`). On macOS, requires `gtimeout` from coreutils (`brew install coreutils`).

| Tool | Failure mode | Symptom |
|---|---|---|
| scorecard | Missing `GITHUB_TOKEN` | Prints error, then waits 40+ minutes for rate limit reset |
| compliance-assistant enrich | ClearlyDefined API unavailable or slow | Hangs on network requests; many packages queued for harvesting |
| gitleaks | Very large repos | Slow on repos with thousands of commits or large binary history |
| grype | First run after install | Downloads vulnerability database (~100MB), can take minutes |

When running tools via an agent: run each tool independently, check output files exist and are non-empty after each run, and skip gracefully if a tool times out or fails.
