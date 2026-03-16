---
title: From an IDE (VS Code, Cursor, etc)

name: ide
kind: unit
---

You can develop right on the playground machine using the [Visual Studio Code Remote - SSH extension](https://code.visualstudio.com/docs/remote/ssh) or its JetBrains analog.

Supported IDEs:

- `code` (Visual Studio Code)
- `cursor` (Cursor)
- `windsurf` (Windsurf)

::remark-box
If the IDE fails to connect, add the following to your `~/.ssh/config` file:

```sh
Host localhost 127.0.0.1 ::1
  IdentityFile ~/.ssh/iximiuz_labs_user
  AddKeysToAgent yes
  # UseKeychain yes  # <--- macOS-only option
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
```
::

### Opening a new playground in your IDE

To open a new playground in your IDE, use the following command ([labctl](/docs/playgrounds/how-to-use-playgrounds#cli) installation is assumed):

```sh
labctl playground start docker --ide code
```

::remark-box
This mode is intentionally simple and does not support custom working directories or cloning repositories.
For a more powerful experience, see the next section.
::

### Opening an existing playground in your IDE

To open a currently running playground in your IDE, use the following command:

```sh
labctl ide <name> <playground-id>
```

This will start an SSH proxy, wait for the connection to be ready, and open the IDE automatically.

### Using a custom working directory

By default, the IDE opens the user's home directory. Use `--workdir` (`-w`) to open a specific directory instead:

```sh
labctl ide <name> <playground-id> --workdir projects
```

Relative paths are resolved from the user's home directory. Absolute paths are used as-is.

### Cloning a public repository

Use `--repo` (`-r`) to clone a Git repository into the playground before opening the IDE.
For example, to clone the `github.com/iximiuz/kexp` repository into the playground before opening the VSCode IDE, use the following command:

```sh
PLAY_ID=$(labctl playground start golang)

labctl ide code $PLAY_ID --repo https://github.com/iximiuz/kexp
```

When a single repo is specified without an explicit `--workdir`, the IDE opens the cloned repository's directory.

You can also specify a custom clone path using the `<url>:<path>` format:

```sh
labctl ide <name> <playground-id> --repo https://github.com/user/repo:my-project
```

### Cloning a private repository (SSH + agent forwarding)

For private repositories that require SSH authentication, use an SSH-style URL with the `--forward-agent` flag:

```sh
labctl ide <name> <playground-id> \
  --repo git@github.com:user/private-repo \
  --forward-agent
```

::remark-box
---
:kind: warning
---

**WARNING:** The `--forward-agent` flag forwards your local SSH agent to the playground VM.
This means the playground machine can use your SSH keys for the duration of the session.
Use it with caution.
::

### Cloning multiple repositories into one working directory

Use `--repo` multiple times and set a shared `--workdir`:

```sh
labctl ide <name> <playground-id> \
  --workdir projects \
  --repo https://github.com/user/frontend \
  --repo https://github.com/user/backend
```

Both repositories will be cloned into the `projects/` directory (as `projects/frontend` and `projects/backend`), and the IDE will open the `projects/` folder.

### Using the SSH Proxy mode manually

You can also use the SSH Proxy mode manually to forward a local port to the playground VM's SSHD port (22).
For example, to forward the local port 2222 to the playground VM's SSHD port (22), use the following command:

```sh
labctl ssh-proxy <playground-id> --address localhost:2222
```

Then you can access the playground VM using a remote SSH extension for your IDE.

Example for VSCode:

```sh
cursor --folder-uri vscode-remote://ssh-remote+laborant@127.0.0.1:2222/home/laborant
```

Example for Cursor:

```sh
cursor --folder-uri vscode-remote://ssh-remote+laborant@127.0.0.1:2222/home/laborant
```

Check out this [short recording on YouTube](https://youtu.be/wah_yLoYk0M) demonstrating the use case.