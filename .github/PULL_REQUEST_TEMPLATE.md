# Pull Request

## Description

<!-- Describe the changes in this PR and why they are needed. -->

## PR Title Checklist

> [!IMPORTANT]
> The PR title **must** follow the [Conventional Commits](https://www.conventionalcommits.org/) format.
> It is used as the squash-merge commit message onto `main`.

**Format:** `<type>: <description>`

**Supported types:** `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`, `revert`

**Examples:**

- `feat: add support for new compiler version`
- `fix: correct build failure detection in build script`
- `docs: update README with usage instructions`
- `ci: add commitlint for pull request titles`
- `refactor: simplify Docker image build process`
- `test: add integration tests for build project script`

## Checklist

- [ ] PR title follows the Conventional Commits format
- [ ] Changes are covered by tests (new or existing)
- [ ] All CI checks pass
- [ ] Documentation updated if required (e.g. `README.md`, `action.yml` descriptions)
- [ ] No secrets or sensitive data committed
