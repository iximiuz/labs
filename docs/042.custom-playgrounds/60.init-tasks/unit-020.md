---
title: Startup files and welcome messages

name: startup-files
kind: unit
---

For small tweaks - shell profiles, config files, motd-style notes - a full init task is overkill.
Each machine can declare up to 10 **startup files** that are baked into the machine's filesystem **before it boots**:

```yaml
  machines:
    - name: dev-01
      drives:
        - source: golang
          mount: /
      startupFiles:
        - path: /home/laborant/.bashrc
          append: true
          content: |
            export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
            export GOPATH=$HOME/go/
        - path: /etc/app/config.yaml
          owner: laborant
          mode: "600"
          content: |
            environment: playground
```

- `path` must be absolute; missing parent directories are created.
- `append: true` adds to an existing file instead of replacing it - the go-to for `.bashrc` and similar modifications.
- `owner` (`user`, `user:group`, or numeric IDs) and `mode` (octal, without the leading zero - e.g. `"600"`) default to `root`-owned `"644"`.

::remark-box
---
kind: warning
---
Startup files is the only reliable way to customize login shell behavior (e.g., by placing something in the `~/.bashrc` file). Init tasks run already _after_ the machine is booted, and technically, the user may acquire a shell before all init tasks complete.
::

Rule of thumb: use startup files for *content you already know at authoring time* (configs, aliases, seed data),
and [init tasks](/docs/custom-playgrounds/init-tasks#init-tasks) for anything that must be *executed* (installing packages, starting services).

## Welcome messages

The first thing a user sees in a terminal is the machine's welcome message. It's configured per user and is well worth the effort -
a good welcome message explains what the machine is, what's installed, and where to start:

```yaml
      users:
        - name: laborant
          default: true
          welcome: |
            This is a development machine with Go, Docker, and kubectl preinstalled.
            The demo app lives in ~/app - run `make help` to see what it can do.
```

Set `welcome: '-'` to suppress the message entirely (useful for secondary machines).
