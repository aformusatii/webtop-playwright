# Start from LinuxServer.io Webtop base image
FROM lscr.io/linuxserver/webtop:debian-xfce

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV NODE_VERSION=latest

# Update base system and install dependencies for Node.js and Playwright
RUN apt-get update && \
    apt-get install -y curl gnupg ca-certificates apt-transport-https net-tools&& \
    # Add NodeSource repo for latest Node.js
    curl -fsSL https://deb.nodesource.com/setup_current.x | bash - && \
    apt-get install -y nodejs && \
    # Verify installation
    node -v && npm -v && \
    # Install Playwright dependencies (browser libs, fonts, etc.)
    # npx playwright install-deps && \
    # Install global npm packages
    # npm install -g @openai/codex @playwright/test @playwright/mcp && \
    # Install Playwright browsers (Chromium, Firefox, WebKit)
    # npx playwright install && \
    # npx playwright install chrome && \
    # Clean up to reduce image size
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Optionally verify installations
RUN echo "Node.js version:" && node -v && \
    echo "NPM version:" && npm -v
    #echo "Playwright version:" && npx playwright --version && \
    #echo "OpenAI package installed at:" && npm list -g openai

# Clear stale desktop locks after an unclean shutdown, before services start.
COPY --chmod=755 init/10-clean-desktop-runtime.sh /custom-cont-init.d/10-clean-desktop-runtime.sh
