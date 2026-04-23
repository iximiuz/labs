---
title: Running Claude Code in a Playground with Access to a Local Browser

name: coding-agent-with-browser-access
kind: unit
---

## Motivation

Running a coding agent like [Claude Code](https://www.anthropic.com/claude-code) directly on your laptop is convenient,
but it also means giving it access to your filesystem, your shell, and - if you wire up a browser MCP - your primary Google Chrome profile with all its logged-in sessions. That's a lot of blast radius for an autonomous process.

A safer setup is to run the agent in a disposable playground VM and let it reach back to a **separate, throwaway** Chrome instance on your local machine over a forwarded port. The agent gets to iterate on code _and_ see the rendered result in a real browser, while your primary browser profile stays untouched.

::image-box
---
:src: __static__/chrome-dev-tools-mcp.png
:alt: "The coding agent running in a playground VM can drive your local Chrome via the Chrome DevTools MCP."
---

The coding agent running in a playground VM can drive your local Chrome via the Chrome DevTools MCP.
::

## Prerequisites

- [`labctl`](https://github.com/iximiuz/labctl) CLI
- Google Chrome installed locally
- A local IDE (optional, for step 6)

## Setting up the environment

1. Start a new [development playground](/playgrounds/nodejs) and capture its ID:

```sh
PLAY_ID=$(labctl playground start nodejs)  # or golang, python, etc.
```

2. SSH into the playground and install Claude Code:

```sh
labctl ssh $PLAY_ID
```

Once inside the VM:

```sh
curl -fsSL https://claude.ai/install.sh | bash
```

3. Install the [Chrome DevTools MCP](https://github.com/ChromeDevTools/chrome-devtools-mcp) using the `claude mcp add` command:

```sh
claude mcp add chrome-devtools -- \
    npx chrome-devtools-mcp@latest --browser-url http://localhost:9222
```

::remark-box
Note that the recommended "plugin way" of installing the Chrome DevTools MCP works,
but it requires you to manually adjust the MCP server command to add the `--browser-url` argument
pointing to the forwarded remote debugging port inside the playground VM **after the installation**:

```sh
claude plugin marketplace add ChromeDevTools/chrome-devtools-mcp
claude plugin install chrome-devtools-mcp
```

The problem is that there is no easy way to find the right MCP settings file to edit,
but you can always ask Claude Code to adjust its own configuration.
::

4. On your **local machine**, start a separate Google Chrome instance with a dedicated profile and remote debugging enabled.

On macOS:

```sh
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
    --remote-debugging-port=9222 \
    --user-data-dir=/tmp/chrome-profile-stable
```

On Linux:

```sh
/usr/bin/google-chrome \
    --remote-debugging-port=9222 \
    --user-data-dir=/tmp/chrome-profile-stable
```

On Windows:

```sh
"C:\Program Files\Google\Chrome\Application\chrome.exe" ^
    --remote-debugging-port=9222 ^
    --user-data-dir="%TEMP%\chrome-profile-stable"
```

::remark-box
---
:kind: warning
---

Do **not** point `--user-data-dir` at your primary Chrome profile unless you fully understand the risks of giving a coding agent uncontrolled access to a browser with active sessions on sensitive sites (email, banking, cloud consoles, etc.).
::

5. [Forward the local port](/docs/playgrounds/forward-remote-ports) `9222` into the playground so that the remote Claude Code can drive your local browser:

```sh
labctl port-forward $PLAY_ID -R 9222:9222
```

6. Back in the SSH session, launch Claude Code and ask it to do some web development. The Chrome DevTools MCP will connect to `localhost:9222` inside the playground, which is transparently forwarded to the Chrome instance running on your laptop.

```sh
claude --dangerously-skip-permissions
```

7. Make the remote application accessible in the local browser by either exposing it as a public URL with [`labctl expose local`](/docs/playgrounds/expose-local-endpoints) or forwarding it with [`labctl port-forward -L`](/docs/playgrounds/forward-remote-ports):

```sh
labctl expose port $PLAY_ID 3000 --public
```

or:

```sh
labctl port-forward $PLAY_ID -L 3000:3000
```

Then tell Claude Code to open the application in the local browser using the generated URL or the forwarded port (e.g., `http://localhost:3000`).

## Editing the remote codebase locally

If you prefer to browse and edit the project in your local IDE rather than over SSH, open the playground's workspace with [`labctl ide`](/docs/cli/labctl#labctl-ide):

```sh
labctl ide code $PLAY_ID --workdir path/to/source
```

This opens VS Code attached to the playground VM, while Claude Code keeps running remotely and continues to drive the Chrome instance on your laptop through the forwarded port.
