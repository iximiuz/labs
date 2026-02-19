---
title: From the Command Line

name: cli
kind: unit
---

Starting a playground is also possible from the comfort of your local terminal.
For this, you will need a CLI tool called [`labctl`](https://github.com/iximiuz/labctl).

It is a thin wrapper around the iximiuz Labs API with a number of UX improvements.
You can use `labctl` to start and access Linux, Docker, Kubernetes, networking, and other types of playgrounds.

### Installation

The command below will download the latest release to `~/.iximiuz/labctl/bin`, adding it to your PATH.

```sh
curl -sf https://labs.iximiuz.com/cli/install.sh | sh
```

Alternatively, you can install `labctl` via Homebrew (macOS and Linux only):

```sh
brew install labctl
```

### Authentication

After installing `labctl`, you will need to authenticate the CLI session to the iximiuz Labs API.
The command below will open a browser page with a one-time use URL.

```sh
labctl auth login
```

### Starting playgrounds

Once you have authenticated, you can start a new playground with a simple:

```sh
labctl playground start docker
```

You can also automatically **open the playground in a browser** with:

```sh
labctl playground start k3s --open
```

...or **SSH into the playground's machine** with:

```sh
labctl playground start ubuntu-24-04 --ssh
```

### SSH into a playground

Once you have started a playground, you can access it with:

```sh
labctl ssh <playground-id>
```

...or run a one-off command with:

```sh
labctl ssh <playground-id> -- ls -la /
```

### Listing, stopping, restarting, and destroying playgrounds

You can list recent playgrounds with:

```sh
labctl playground list
```

And stop a running playground with:

```sh
labctl playground stop <playground-id>
```

Stopping a playground shuts down its virtual machines, preserving the playground state and the VM disks in a remote storage.
You can restart a stopped playground later on using the following command:

```sh
labctl playground restart <playground-id>
```

To dispose of a running or stopped playground, completely erasing its data, use the `labctl destroy` command:

```sh
labctl playground destroy <playground-id>
```

### Signing out and deleting the CLI

You can sign out and delete the CLI session with:

```sh
labctl auth logout
```

To uninstall the CLI, just remove the `~/.iximiuz/labctl` directory.
