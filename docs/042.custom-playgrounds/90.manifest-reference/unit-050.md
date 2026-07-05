---
title: Init tasks and conditions

name: init-tasks
kind: unit
---

`playground.initTasks` is a map of named provisioning tasks executed inside the machines during startup
(see [the init tasks lesson](/docs/custom-playgrounds/init-tasks-and-tabs#init-tasks) for a guided tour):

```yaml
  initTasks:
    init_install_tools:
      init: true
      machine: dev-01
      user: root
      timeout_seconds: 120
      run: |
        apt-get update && apt-get install -y jq

    init_seed_data:
      init: true
      machine: dev-01
      user: laborant
      needs:
        - init_install_tools
      run: |
        mkdir -p ~/data && echo hello > ~/data/seed.txt
```

| Field | Type | Default | Notes |
|---|---|---|---|
| `init` | bool | `false` | Must be `true` for playground init tasks (they run once, at startup, before the playground is handed to the user). |
| `machine` | string | required | The VM to run on. |
| `user` | string | `root` | The user to run the script as. |
| `run` | string | required | The shell script (executed with `bash`). |
| `needs` | list of strings | - | Task names that must complete first; cycles are rejected. |
| `timeout_seconds` | int | `60` | Increase for anything network- or package-manager-bound. |
| `conditions` | list of `{key, value}` | - | Run the task only when the given init-condition values were selected. |

## Init conditions

`playground.initConditions` declares start-time parameters that users provide in the UI or via `labctl playground start -i key=value`:

```yaml
  initConditions:
    values:
      - key: k8s_flavor
        default: k3s
        options: [k3s, kubeadm]
      - key: repo_url
        default: ""
        nullable: true
        placeholder: https://github.com/you/repo
        validationRegex: "^https://.*$"
```

| Field | Type | Notes |
|---|---|---|
| `key` | string | The parameter name referenced by tasks' `conditions`. |
| `default` | string | Pre-selected value. |
| `options` | list of strings | Renders as a dropdown when set. |
| `nullable` | bool | Allows an empty value. |
| `placeholder` | string | Input hint in the UI. |
| `validationRegex` | string | Client-side validation for free-form values. |
