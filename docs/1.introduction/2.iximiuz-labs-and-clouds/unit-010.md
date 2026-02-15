---
title: Will It Help Me Improve Cloud Skills?

name: iximiuz-labs-and-clouds
kind: unit
---

Based on our experience and hearing back from hundreds of engineers who actually achieved their learning goals,
a sequence that has traditionally led to the most solid understanding and the most transferable knowledge is:

::highlight
Linux → Networking → Containers → Kubernetes → Cloud
::

Jumping straight into learning the higher-level components, such as AWS VPC, Security Groups, Internet Gateways, or even Kubernetes, is not uncommon, but it often results in longer mastering time and the need to "re-learn" from scratch after switching from AWS to Azure or from Kubernetes to Nomad or AWS ECS.

In contrast, when you first learn about [LANs](/courses/computer-networking-fundamentals) (L2 broadcast domains, typical switch topologies, etc.),
then [L3 routing](/challenges/networking-configure-basic-routing), firewalling with [iptables](/challenges/linux-protect-ports),
and establishing connectivity to the outside world with [NAT](/challenges/networking-configure-nat-gateway),
understanding what VPC and Security Group actually are becomes much easier.

::slide-show
---
slides:
- image: __static__/nat-gateway-problem.png
  alt: "Problem: Enable Internet Access for a Private Network with a NAT Gateway"
  description: "Problem: Enable Internet Access for a Private Network with a NAT Gateway"
- image: __static__/nat-gateway-solution.png
  alt: "Solution: Enable Internet Access for a Private Network with a NAT Gateway"
  description: "Solution: Enable Internet Access for a Private Network with a NAT Gateway"
---
::

One more good thing about this approach is that focusing on fundamentals makes the knowledge transferable sideways, too.

For instance, container networking ([Docker's typical bridge network](/tutorials/container-networking-from-scratch)) and Kubernetes' Node and Pod networking rely on the same L2 broadcast domain,
L3 routing, and iptables concepts from above, even if some of the primitives will be virtualized (e.g., a Linux bridge is a virtual switch and a network namespace is an analog of an isolated network node).

::highlight
This is why at iximiuz Labs, we focus on the **fundamentals of the server-side tech**.
::