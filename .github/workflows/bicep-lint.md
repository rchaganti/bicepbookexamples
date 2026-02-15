---
name: Bicep Schema and Feature Check
description: >
  Checks all .bicep files in the repository for schema issues, linting errors,
  and feature updates based on the latest Azure Bicep release.

on:
  schedule: "weekly"
  pull_request:
    paths:
      - "**/*.bicep"
      - "**/*.bicepparam"
      - "**/bicepconfig.json"
  push:
    branches:
      - main
    paths:
      - "**/*.bicep"
      - "**/*.bicepparam"
      - "**/bicepconfig.json"
  workflow_dispatch:

permissions:
  contents: read
  issues: read
  pull-requests: read

steps:
  - name: Install Bicep and run linting
    run: |
      # Install Bicep CLI
      curl -Lo /usr/local/bin/bicep https://github.com/Azure/bicep/releases/latest/download/bicep-linux-x64
      chmod +x /usr/local/bin/bicep
      BICEP_VERSION=$(bicep --version 2>&1)
      echo "Installed: ${BICEP_VERSION}"

      # Fetch latest release info
      curl -sL https://api.github.com/repos/Azure/bicep/releases/latest > ${GITHUB_WORKSPACE}/bicep-release.json

      # Create results directory
      mkdir -p ${GITHUB_WORKSPACE}/lint-results

      # Save version info
      echo "${BICEP_VERSION}" > ${GITHUB_WORKSPACE}/lint-results/version.txt

      # Lint all bicep files and capture results
      echo "=== BICEP LINT RESULTS ===" > ${GITHUB_WORKSPACE}/lint-results/lint-output.txt
      TOTAL=0
      ERRORS=0
      WARNINGS=0
      CLEAN=0

      for f in $(find ${GITHUB_WORKSPACE} -name "*.bicep" -not -path "*/lint-results/*"); do
        TOTAL=$((TOTAL + 1))
        REL_PATH="${f#${GITHUB_WORKSPACE}/}"
        echo "" >> ${GITHUB_WORKSPACE}/lint-results/lint-output.txt
        echo "--- FILE: ${REL_PATH} ---" >> ${GITHUB_WORKSPACE}/lint-results/lint-output.txt
        OUTPUT=$(bicep build "$f" --stdout 2>&1 >/dev/null || true)
        if [ -n "$OUTPUT" ]; then
          echo "$OUTPUT" >> ${GITHUB_WORKSPACE}/lint-results/lint-output.txt
          if echo "$OUTPUT" | grep -qi "error"; then
            ERRORS=$((ERRORS + 1))
            echo "STATUS: ERROR" >> ${GITHUB_WORKSPACE}/lint-results/lint-output.txt
          else
            WARNINGS=$((WARNINGS + 1))
            echo "STATUS: WARNING" >> ${GITHUB_WORKSPACE}/lint-results/lint-output.txt
          fi
        else
          echo "STATUS: CLEAN" >> ${GITHUB_WORKSPACE}/lint-results/lint-output.txt
          CLEAN=$((CLEAN + 1))
        fi
      done

      # Save summary
      echo "TOTAL=${TOTAL}" > ${GITHUB_WORKSPACE}/lint-results/summary.txt
      echo "ERRORS=${ERRORS}" >> ${GITHUB_WORKSPACE}/lint-results/summary.txt
      echo "WARNINGS=${WARNINGS}" >> ${GITHUB_WORKSPACE}/lint-results/summary.txt
      echo "CLEAN=${CLEAN}" >> ${GITHUB_WORKSPACE}/lint-results/summary.txt

      echo "Linting complete: ${TOTAL} files, ${ERRORS} errors, ${WARNINGS} warnings, ${CLEAN} clean"

tools:
  edit:
  bash:
    - "cat *"
    - "echo *"
    - "find *"
    - "ls *"
    - "jq *"
    - "python3 *"
    - "bash *"
  github:
    toolsets: [repos, issues, pull_requests]

network:
  allowed:
    - "defaults"
    - "github"

safe-outputs:
  allowed-github-references: ["repo"]
  create-issue:
    title-prefix: "[Bicep Lint] "
    labels: ["bicep", "automated"]
    max: 1
    close-older-issues: true
    footer: true
---

# Bicep Schema and Feature Check

You are a Bicep linting and schema validation agent. The Bicep CLI has already been run on all `.bicep` files BEFORE you started. All results are saved in the `lint-results/` directory. Your job is to analyze these results and generate a comprehensive report.

## Step 1: Read Bicep version and lint results

Read the pre-computed results:

1. Read `lint-results/version.txt` for the installed Bicep CLI version
2. Read `lint-results/summary.txt` for the total/error/warning/clean counts
3. Read `lint-results/lint-output.txt` for the detailed per-file lint results

## Step 2: Read latest Bicep release info

Read `bicep-release.json` in the workspace root. This contains the latest Bicep release from GitHub. Extract:

- The `tag_name` (version)
- The `published_at` (release date)
- Key highlights from `body` (release notes: new features, deprecations, breaking changes)

## Step 3: Review bicepconfig.json files

Read all `bicepconfig.json` files in the repository and review them for:

- Deprecated configuration options
- Experimental features that have been promoted to stable in the latest Bicep release
- Missing recommended linting rules
- Invalid or outdated analyzer rule names

## Step 4: Check for API version currency

Examine the `.bicep` files and check if the API versions used in resource declarations are current. Flag any resources using API versions that are more than 2 years old (before 2024) as candidates for update.

## Step 5: Generate the report

Create a summary issue with the following sections:

### Report Structure

1. **Bicep Version**: The installed Bicep CLI version and latest release highlights
2. **Linting Results Summary**: Total files scanned, files with errors, files with warnings, clean files
3. **Errors**: List each file with errors, including the specific error messages
4. **Warnings**: List each file with warnings, including the specific warning messages
5. **External Dependencies**: Files that reference external modules or registries (errors about missing modules/registries)
6. **Configuration Review**: Findings from bicepconfig.json analysis
7. **API Version Updates**: Resources using outdated API versions with recommended updates
8. **Feature Opportunities**: New Bicep features from recent releases that could benefit this codebase (e.g., new decorators, improved type system features, new built-in functions)

### Formatting Guidelines

- Use tables for file-level summaries
- Use code blocks for specific error/warning messages
- Group findings by chapter/directory for readability
- Include actionable recommendations where possible
- If this is a pull request, also add a summary comment on the PR

If there are no issues found, still create the report confirming all files passed validation, and include any relevant feature update opportunities.
