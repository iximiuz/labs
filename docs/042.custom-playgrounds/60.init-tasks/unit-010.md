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
- `needs` - names of tasks that must complete first.
- `timeout_seconds` - **defaults to 60 seconds**; set it generously for anything that touches the network or a package manager.

## Execution order

Tasks with no `needs` start concurrently as soon as their machine boots; `needs` chains them into a dependency graph.
Since every task names its target machine, the graph can span the whole playground -
a task on one machine can wait for provisioning on another, which is how you express "start the app server only after the database VM is seeded".

Two practical gotchas:

- Tasks run as `root` unless `user` says otherwise. If a task prepares files for the interactive user (cloning a repo into `/home/laborant`, for example), set `user: laborant` - or you'll leave root-owned files in their home directory.
- Init tasks execute once per playground instance during its initialization; they are not re-run after in-session machine reboots.

## Debugging init tasks

A failing or timed-out init task keeps the playground stuck on the loading screen,
so test your scripts by starting the playground and watching the task progress.
`labctl playground tasks <play-id>` shows the status of each task from the command line:

```text
NAME                 MACHINE  STATUS     INIT  HELPER
init_fetch_app       dev-01   completed  true  false
init_start_services  dev-01   running    true  false
```

While the tasks are still running, you can already SSH into the machines (`labctl ssh <play-id> -m <machine>`)
and inspect the environment - handy for figuring out why a script misbehaves.

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
Combined with `options`, `default`, and free-form values (validated by an optional `validationRegex`),
init conditions let one playground serve several scenarios - different Kubernetes flavors, tool versions, or difficulty levels.

A good real-world example is the [Kubernetes Cluster](https://labs.iximiuz.com/playgrounds/k8s-omni) playground (`k8s-omni`) -
a multi-node kubeadm cluster where both the container runtime and the networking plugin are chosen at start time:

```yaml
  initConditions:
    values:
      - key: Container runtime
        default: containerd
        options:
          - containerd
          - cri-o
      - key: Networking plugin
        default: flannel
        nullable: true  # can be left unset - the cluster starts with no CNI plugin installed
        options:
          - calico
          - cilium
          - flannel
          - static
```

Every runtime- and plugin-specific provisioning step (installing containerd or CRI-O, applying the Cilium or Flannel manifests,
configuring static routes, and so on) is a separate init task guarded by the matching condition:

```yaml
    init_cplane_10_cri_o_install:
      init: true
      machine: cplane-01
      conditions:
        - key: Container runtime
          value: cri-o
      run: |
        apt-get install -y cri-o podman
        systemctl enable --now crio
```

This is the real power of parameterized playgrounds: instead of maintaining a dozen near-identical copies,
a single manifest covers the whole matrix of container runtimes × networking plugins -
including a cluster with no CNI at all, for practicing networking setup from scratch (a classic CKA exercise).

The `k8s-omni` manifest is public, so you can study the complete technique with:

```sh
labctl playground manifest k8s-omni
```
