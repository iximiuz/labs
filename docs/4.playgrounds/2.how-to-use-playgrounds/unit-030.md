---
title: From an IDE (VS Code, Cursor, etc)

name: ide
kind: unit
---

You can develop right on the playground machine using the [Visual Studio Code Remote - SSH extension](https://code.visualstudio.com/docs/remote/ssh) or its JetBrains analog.

### Opening a new playground in your IDE

To open a new playground in your IDE, use the following command ([labctl](/docs/playgrounds/how-to-use-playgrounds#cli) installation is assumed):

```sh
labctl playground start docker --ide code
```

### Opening an existing playground in your IDE

To access an existing playground in your IDE, you can use the **SSH proxy mode**:

```sh
labctl ssh-proxy <playground-id> --ide code
```

Example output:

```text
SSH proxy is running on 58279

# Connect from the terminal:
ssh -i ~/.ssh/iximiuz_labs_user ssh://laborant@127.0.0.1:58279

# For better experience, add the following to your ~/.ssh/config:
Host localhost 127.0.0.1 ::1
  IdentityFile ~/.ssh/iximiuz_labs_user
  AddKeysToAgent yes
  # UseKeychain yes # macOS only
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null

Press Ctrl+C to stop
```

After adding the suggested SSH config entry to your `~/.ssh/config`,
you'll be able to open an existing playground in your IDE with the below commands:

1. Visual Studio Code:

```sh
code --folder-uri vscode-remote://ssh-remote+laborant@127.0.0.1:58279/home/laborant
```

2. Cursor:

```sh
cursor --folder-uri vscode-remote://ssh-remote+laborant@127.0.0.1:58279/home/laborant
```

Check out this [short recording on YouTube](https://youtu.be/wah_yLoYk0M) demonstrating the use case.