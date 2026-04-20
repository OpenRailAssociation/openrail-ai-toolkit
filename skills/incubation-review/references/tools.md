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
