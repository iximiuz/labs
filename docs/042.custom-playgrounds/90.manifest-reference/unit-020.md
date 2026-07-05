---
title: Machines

name: machines
kind: unit
---

`playground.machines` is a list of VM definitions (1 to 5 machines per playground):

```yaml
  machines:
    - name: dev-01
      backend: firecracker
      kernel:
        source: "6.1"
      users:
        - name: laborant
          default: true
          welcome: |
            Hello there!
      drives:
        - source: ubuntu-24-04
          mount: /
          size: 10GiB
      network:
        interfaces:
          - network: local
      resources:
        cpuCount: 2
        ramSize: 2GiB
      startupFiles:
        - path: /home/laborant/.bashrc
          append: true
          content: |
            alias k=kubectl
      noSSH: false
```

| Field | Type | Default | Notes |
|---|---|---|---|
| `name` | string | required | Hostname-like; also the machine's hostname and DNS name inside the playground. With any base other than `flexbox`, machine names must match the base's machines (subsets allowed, new names rejected). |
| `users` | list | required | At least one user; see below. |
| `backend` | string | `firecracker` | `firecracker` or `cloud-hypervisor`; the latter enables [nested virtualization](/docs/playground-recipes/nested-virtualization) (paid feature). |
| `kernel.source` | string | `6.1` | Kernel version to boot, e.g. `5.10`, `6.1`, `6.12`, `6.18`. |
| `drives` | list | required | See below. |
| `network.interfaces` | list | required | At least one interface; see [Networks](/docs/custom-playgrounds/manifest-reference#networks). |
| `resources` | object | auto-computed | See below. |
| `startupFiles` | list | - | See below. |
| `noSSH` | bool | `false` | Disables SSH access and hides the machine's terminal tab. |

## Users

| Field | Type | Default | Notes |
|---|---|---|---|
| `name` | string | required | Must exist in the rootfs image (`root` always does; official images ship `laborant`, except Alpine). |
| `default` | bool | first listed user | The user that terminals and `labctl ssh` log in as. |
| `welcome` | string | image default | Login banner; `'-'` disables it. |

`root` is always available, even if not listed.

## Drives

| Field | Type | Default | Notes |
|---|---|---|---|
| `source` | string | - (empty drive) | A named rootfs image (`ubuntu-24-04`, `docker`, ...) or an OCI reference `oci://ghcr.io/user/image:tag` (Docker Hub not supported). Required for the root drive only. |
| `mount` | string | - (not mounted) | Mount point inside the VM. Exactly one drive per machine must have `mount: /`. Non-root drives with a `mount` are auto-formatted and auto-mounted. |
| `size` | string | base/platform default | `1GiB` to `100GiB` per drive; at most `240GiB` total per playground. |
| `filesystem` | string | `ext4` (when formatting applies) | `ext4`, `ext2`, `ext3`, `xfs`, or `btrfs`. A source-less drive with no `mount` and no `filesystem` stays raw/unformatted. |
| `readOnly` | bool | `false` | Attach the drive read-only. |

Drives map to devices in list order: `/dev/vda`, `/dev/vdb`, ... Up to 24 drives per machine.
(You may also see `source: snapshot` with a `snapshot` object in dumped manifests - that's how [playgrounds saved from a stopped instance](/docs/playgrounds/persistent-playgrounds#saving-as-custom) reference their drive snapshots; these entries are platform-generated, not hand-written.)

## Resources

| Field | Type | Default | Notes |
|---|---|---|---|
| `cpuCount` | int | auto | Number of vCPUs (min 1). |
| `ramSize` | string | auto | Human-readable size, e.g. `512MiB`, `2GiB`. |

Per-VM and per-playground totals are capped by your plan (free tier: 2 vCPU / 4 GiB per VM, 5 vCPU / 8 GiB per playground; paid plans: 4 vCPU / 10 GiB per VM, 10 vCPU / 16 GiB per playground). Requests exceeding the budget are scaled down proportionally rather than rejected.

## Startup files

| Field | Type | Default | Notes |
|---|---|---|---|
| `path` | string | required | Absolute path; parent directories are created. |
| `content` | string | required | File content. |
| `append` | bool | `false` | Append instead of overwrite. |
| `owner` | string | `0:0` | `user`, `user:group`, or numeric `UID[:GID]`. |
| `mode` | string | `"644"` | Octal permissions, without the leading zero (e.g. `"600"`, not `"0600"`). |

Up to 10 startup files per machine.
