# Pull Request

## Description

<!-- Describe the changes in this PR and why they are needed. -->

## PR Title Checklist

> [!IMPORTANT]
> The PR title **must** follow the [Conventional Commits](https://www.conventionalcommits.org/) format.
> It is used as the squash-merge commit message onto `main`.

**Format:** `<type>[(<scope>)][!]: <description>`

- `(<scope>)` is optional and describes the area of the codebase affected (e.g., `deps`, `docker`, `ci`)
- `!` is optional and indicates a **breaking change**

**Supported types:** `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`, `revert`

**Examples:**

- `feat: add support for new compiler version`
- `fix: correct build failure detection in build script`
- `docs: update README with usage instructions`
- `ci(deps): bump actions/checkout from 3 to 4`
- `refactor: simplify Docker image build process`
- `test: add integration tests for build project script`
- `feat!: drop support for legacy compiler versions`
- `fix(docker)!: change base image breaking existing mounts`

## Checklist

- [ ] PR title follows the Conventional Commits format
- [ ] Changes are covered by tests (new or existing)
- [ ] All CI checks pass
- [ ] Documentation updated if required (e.g. `README.md`, `action.yml` descriptions)
- [ ] No secrets or sensitive data committed
