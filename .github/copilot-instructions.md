# Copilot Instructions

## Updating Pinned Package Versions in the Dockerfile

When bumping the base image (e.g. `ubuntu:24.04`) or when package versions become stale,
update the pinned `apt-get install` versions using the following procedure:

1. Remove the version pins from all packages in the `apt-get install` command.
2. Build the Docker container up to (and including) the package-install layer:
   ```bash
   docker build --target install-ccs -t ccs-build-versions .
   ```
   If the full build is not feasible (e.g. requires large downloads), create a
   temporary `Dockerfile` that contains only the `FROM` and `RUN apt-get install …`
   block:
   ```bash
   docker build -f /tmp/Dockerfile.versions -t ccs-build-versions /tmp
   ```
3. Query the exact installed versions from the resulting image:
   ```bash
   docker run --rm ccs-build-versions \
     dpkg-query -W -f='${Package}=${Version}\n' \
     apt-utils autoconf bash build-essential curl git \
     libc6-i386 libtool software-properties-common unzip wget
   ```
4. Re-add the version pins in the `Dockerfile` using the versions reported by the
   command above.
5. Rebuild the image with the new pins to confirm the build succeeds.

