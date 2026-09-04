---
title: Startup files and welcome messages

name: startup-files
kind: unit
---

For small tweaks - shell profiles, config files, seed data, helper scripts - a full init task is overkill.
`playground.startupFiles` is a list of files baked into the playground's machines **before they boot**:

```yaml
playground:
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
      machines: [dev-01]        # optional; omitted = every machine of the play
```

- `path` must be absolute; missing parent directories are created.
- `append: true` adds to an existing file instead of replacing it - the go-to for `.bashrc` and similar modifications.
- Every entry needs `append: true` or both `owner` and `mode` set. `owner` (`user`, `user:group`, or numeric IDs) and `mode` (octal, without the leading zero - e.g. `"600"`) default to `root`-owned `"644"` when the file is created, and are kept unchanged when appending.
- `machines` restricts an entry to the named machines; omit it to apply the entry to every machine in the play.

At most 20 entries per manifest.

::remark-box
---
kind: warning
---
Startup files is the only reliable way to customize login shell behavior (e.g., by placing something in the `~/.bashrc` file). Init tasks run already _after_ the machine is booted, and technically, the user may acquire a shell before all init tasks complete.
::

Rule of thumb: use startup files for *content you already know at authoring time* (configs, aliases, seed data, helper scripts),
and [init tasks](/docs/custom-playgrounds/init-tasks#init-tasks) for anything that must be *executed* (installing packages, starting services).

## Fetching files instead of inlining them

Instead of `content`, a `source` fetches the file rather than inlining its bytes - or, with `extract: true`, unpacks a tar archive into a destination directory:

```yaml
playground:
  startupFiles:
    # A helper script from this content's own __static__ folder.
    - path: /usr/local/bin/setup.sh
      source: __stаtic__/setup.sh
      owner: root
      mode: "755"

    # A tar archive extracted into a destination directory, created if missing.
    - path: /opt/app            # destination directory
      source: __stаtic__/app.tar.gz
      extract: true
      owner: laborant

    # Any https URL - GitHub raw content is the typical case.
    - path: /usr/local/bin/cdebug
      source: https://raw.githubusercontent.com/iximiuz/cdebug/main/hack/install.sh
      owner: root
      mode: "755"
```

- `content` and `source` are mutually exclusive - exactly one of them per entry.
- Files are fetched and cached by the platform, so a startup file always reflects the current source without any cache-busting on your part.
- `extract: true` unpacks a `source` archive - `.tar`, or gzip-compressed `.tar.gz`/`.tgz` (no other compression is supported) - into `path` before the machine boots, running in an isolated sandbox; `owner` sets who owns the extracted files (default `root`), and `mode`, `append`, and `content` can't be combined with `extract`.
- `labctl content push` builds the archive for you when a startup file points at `__static__/<folder>.tar.gz` (or `.tgz`/`.tar`) and a `<folder>/` directory exists next to the declaring `index.md` (or `manifest.yaml`): the folder's files are tarred on every push, and on every change in `--watch` mode, so the folder is the source of truth and the archive needs no build step. Keep the folder itself out of the push with `.labctlignore` - `labctl` watches it regardless.
- Limits: at most 1 GiB per fetched file.

::remark-box
---
kind: info
---
`machines[].startupFiles` (declared inside a machine, rather than at the top of `playground:`) still works - it's the original, "legacy" form. It can be combined with the playground-level form: existing manifests using it keep working unchanged and are never reformatted, but the playground-level list shown above is recommended for new manifests. When both are present for a machine, the playground-level entries are applied first, then that machine's own `startupFiles`.
::

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
