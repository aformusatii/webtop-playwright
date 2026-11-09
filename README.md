# Webtop Playwright

[![Build and publish image](https://github.com/aformusatii/webtop-playwright/actions/workflows/publish-image.yml/badge.svg)](https://github.com/aformusatii/webtop-playwright/actions/workflows/publish-image.yml)

A LinuxServer Debian XFCE desktop with Node.js and automatic recovery from
stale desktop locks after an unclean shutdown. Playwright packages and browsers
are optional; they are not installed by the default Dockerfile.

## Run locally

Requires Docker Compose and an existing `common-network` network.
Create it with `docker network create common-network` if needed.

```bash
git clone https://github.com/aformusatii/webtop-playwright.git
cd webtop-playwright
docker compose up -d --build
```

Open `https://localhost:8035` (self-signed certificate) or `http://localhost:8034`.
Port `8036` is reserved for an optional Playwright MCP service, disabled by default.

Set `PUID`, `PGID`, and `TZ` in `docker-compose.yaml` for your environment.
Desktop files persist in `config/`, which is excluded from Git and image builds.
Keep the desktop on a trusted network or behind an authenticated reverse proxy.

## Container image

GitHub Actions builds `linux/amd64` images and publishes them to
`ghcr.io/aformusatii/webtop-playwright` using the built-in `GITHUB_TOKEN`.

- Pushes to `main` publish `latest` and a `sha-…` tag.
- Version tags such as `v1.0.0` publish matching image tags.
- Pull requests validate and build without publishing.
- Manual builds are available from the Actions tab.

## Startup recovery

`init/10-clean-desktop-runtime.sh` clears stale X11 and D-Bus runtime files
before desktop services start. It is included in the image and mounted read-only
by Compose. Never run it manually against an active desktop.

To install the hook into an older container without recreating it:

```bash
docker exec -u 0 webtop-playwright mkdir -p /custom-cont-init.d
docker cp init/10-clean-desktop-runtime.sh webtop-playwright:/custom-cont-init.d/
docker exec -u 0 webtop-playwright chmod 755 /custom-cont-init.d/10-clean-desktop-runtime.sh
docker restart webtop-playwright
```

For containers already using the `init/` mount, update the script and restart.
Rebuilds preserve `/config`; install required system packages in the Dockerfile
so they survive container recreation.
