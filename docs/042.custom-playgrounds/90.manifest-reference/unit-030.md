---
title: Networks

name: networks
kind: unit
---

`playground.networks` declares the isolated bridge networks of the playground; machines join them via `network.interfaces`:

```yaml
  networks:
    - name: frontend
      subnet: 10.0.1.0/24
    - name: backend
      subnet: 10.0.2.0/24
      gateway: 10.0.2.254
      private: true

  machines:
    - name: web-01
      network:
        interfaces:
          - network: frontend
            address: 10.0.1.10
          - network: backend       # address auto-assigned
```

## Network fields

| Field | Type | Default | Notes |
|---|---|---|---|
| `name` | string | required | Hostname-like, unique within the playground. |
| `subnet` | string | required | IPv4 CIDR, e.g. `172.16.0.0/24`. |
| `gateway` | string | first free IP in the subnet | Plain IPv4 address (no mask). |
| `private` | bool | `false` | `true` = no NAT to the internet and no default route via this network. |

A playground has at least one network; when the manifest defines none, the base's default network is used (conventionally `local`, `172.16.0.0/24`).
Networks are isolated from each other - inter-network traffic flows only through machines attached to both.

## Interface fields

| Field | Type | Default | Notes |
|---|---|---|---|
| `network` | string | required on the first interface | The network to join. |
| `address` | string | first free IP in the subnet | Static IPv4, with or without a mask (`10.0.1.10` or `10.0.1.10/24`; the mask defaults to the subnet's). |

Interfaces appear in the VM in list order as `eth0`, `eth1`, ...
The machine's default route goes via the first non-`private` network among its interfaces.
Machines resolve each other by machine name and by `<machine>.<network>` names.
