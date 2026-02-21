---
title: Our Focus and Approach

name: platform-focus
kind: unit
---

Based on our experience and hearing back from hundreds of engineers who actually achieved their learning goals,
a sequence that has traditionally led to the most solid understanding and the most transferable knowledge is:

::highlight
Linux → Networking → Containers → Kubernetes → Cloud
::

Jumping straight into learning the higher-level components, such as AWS VPC, Security Groups, Internet Gateways, or even Kubernetes, is not uncommon, but it often results in longer mastering time and the need to "re-learn" from scratch after switching from AWS to Azure or from Kubernetes to Nomad.

In contrast, when you first learn about [LAN concepts](/courses/computer-networking-fundamentals) (L2 broadcast domains, typical switch topologies, etc.),
then [L3 routing](/challenges?tag=routing), firewalling with [iptables](/challenges?tag=iptables),
and establishing connectivity to the outside world with [NAT](/challenges?tag=nat),
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

All iximiuz Labs' Playgrounds use Linux, and all our learning materials are hands-on,
which means you will pick up the Linux skills as a side effect of following our networking and containerization materials.
And Linux topics that require some special attention (e.g., cgroups, namespaces, etc.) will be covered by dedicated [tutorials](/tutorials?category=linux&tag=cgroups) and [challenges](/challenges?category=linux).

A great thing about this approach is that focusing on fundamentals makes the knowledge transferable sideways.
For instance, container networking ([Docker's typical bridge network](/tutorials/container-networking-from-scratch)) and Kubernetes' Node and Pod networking rely on the same L2 broadcast domain primitives,
and VPC and Security Group concepts are built on top of the traditional L3 routing and iptables capabilities.
So by learning Linux, networking, and containers, you will also improve your Kubernetes and Cloud game.

::highlight
This is why at iximiuz Labs, we focus on the **fundamentals of the server-side tech**.
::