---
title: Access control and registry

name: access-and-registry
kind: unit
---

## Access control

`playground.accessControl` holds three lists of principals (see [Sharing and Access Control](/docs/custom-playgrounds/sharing-and-access-control) for recipes):

```yaml
  accessControl:
    canList:
      - anyone
    canRead:
      - anyone
    canStart:
      - owner
```

| Field | Meaning |
|---|---|
| `canList` | Who sees the playground in catalogs and search. |
| `canRead` | Who can open the playground's landing page. |
| `canStart` | Who can start an instance. |

Principals include `owner`, `anyone`, `authenticated`, `user:<...>`, and `student:<training-name>`; the full vocabulary is documented in
[How to Control Access to Your Content](/docs/content-authoring/access-control).
When a manifest is submitted via `labctl`, all three lists must be present and non-empty;
playgrounds cloned without a manifest inherit the access settings of their base (official bases are public).

Older manifests may contain a deprecated `access: {mode: private|public}` block - `labctl` transparently converts it to the equivalent `accessControl` on update.

## Registry auth

Every playground comes with a built-in container registry reachable from inside the VMs at `registry.iximiuz.com`.
By default it's unauthenticated (but only accessible from within the playground); `registryAuth` puts it behind credentials:

```yaml
  registryAuth: someuser:somepassword
```

This is handy for practicing `docker login` flows and private-registry scenarios without leaving the sandbox.
