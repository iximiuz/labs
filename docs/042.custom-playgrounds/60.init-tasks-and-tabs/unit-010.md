---
title: Init tasks

name: init-tasks
kind: unit
---

Init tasks are shell scripts that run inside the playground machines during startup.
They are the primary way to turn a generic base image into *your* environment: install packages, clone repositories, start services, generate data.
The playground shows a loading screen until all init tasks complete, so the user always lands in a fully provisioned environment
(unless they close the loading modal).

`initTasks` is a map of named tasks:

```yaml [manifest.yaml]
kind: playground
name: web-dev-lab
title: Web Dev Lab
playground:
  machines:
    - name: dev-01
      users:
        - name: laborant
          default: true
      drives:
        - source: docker
          mount: /
      network:
        interfaces:
          - network: local
  initTasks:
    init_fetch_app:
      init: true
      machine: dev-01
      user: laborant
      timeout_seconds: 120
      run: |
        git clone https://github.com/example/app.git ~/app

    init_start_services:
      init: true
      machine: dev-01
      needs:
        - init_fetch_app
      timeout_seconds: 180
      run: |
        cd /home/laborant/app && docker compose up -d
  accessControl:
    canList:
      - owner
    canRead:
      - owner
    canStart:
      - owner
```

Field by field:

- `init: true` marks the task as an init task (executed once, at startup).
- `machine` - which VM the task runs on.
- `user` - the user to run the script as; defaults to `root`.
- `run` - the script itself (executed with `bash`).
- `needs` - names of tasks that must complete first; dependencies form a graph, so you can fan out and join provisioning steps across machines.
- `timeout_seconds` - **defaults to 60 seconds**; set it generously for anything that touches the network or a package manager.

::remark-box
---
:kind: warning
---

⚠️ A failing or timed-out init task keeps the playground stuck on the loading screen. Test your scripts by starting the playground and watching the task progress - `labctl playground tasks <play-id>` shows the status of each task from the command line:

```text
NAME                 MACHINE  STATUS     INIT  HELPER
init_fetch_app       dev-01   completed  true  false
init_start_services  dev-01   completed  true  false
```
::

## Parameterized playgrounds

Init tasks can be made conditional on **init conditions** - user-supplied parameters requested at start time:

```yaml
  initConditions:
    values:
      - key: k8s_flavor
        default: k3s
        options:
          - k3s
          - kubeadm
  initTasks:
    init_install_kubeadm:
      init: true
      machine: dev-01
      conditions:
        - key: k8s_flavor
          value: kubeadm
      run: |
        ...
```

When starting such a playground, the UI prompts for the values, and with `labctl` they are passed explicitly:

```sh
labctl playground start web-dev-lab-<suffix> -i k8s_flavor=kubeadm
```

Tasks whose conditions don't match the chosen values are simply skipped (they won't even appear in the task list).
