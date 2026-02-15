---
title: What is iximiuz Labs

name: what-is-iximiuz-labs
kind: unit
---

::highlight
**iximiuz Labs** (a.k.a. ServerLabs.io) is a learning-by-doing platform for mastering server-side skills -
Linux, networking, containers, Kubernetes, and everything in between.
::

## Playgrounds

Instead of watching demos or reading theory in isolation, iximiuz Labs lets you practice in realistic but safe remote sandboxes called [Playgrounds](/docs/playgrounds/what-are-playgrounds).

Playgrounds are fast-booting Linux microVMs (often multi-VM, multi-network, with optional extra disks) that run on a fleet of large bare-metal servers maintained by the iximiuz Labs team.
You can start a playground right from your browser or via the [labctl CLI](/docs/playgrounds/how-to-use-playgrounds#cli).
Once up and running, accessing a playground is no different from SSH-ing into a remote server rented from your favorite VPS or Cloud provider.

Install software, break things, debug, rebuild - then throw the environment away (or keep it, if you're on a plan with [persistence](/docs/playgrounds/persistent-playgrounds)).

::slide-show
---
slides:
- image: __static__/Playgrounds-1-rev2.png
  alt: "iximiuz Labs Playgrounds are fully-fledged VMs that allow you to run a wide range of server-side technologies - from simple web servers to Docker and Kubernetes."
  description: "iximiuz Labs Playgrounds are fully-fledged VMs that allow you to run a wide range of server-side technologies - from simple web servers to Docker and Kubernetes."
- image: __static__/Playgrounds-2-rev2.png
  alt: "Playground VMs can be used to simulate complex server setups - pick a kernel and a rootfs (Ubuntu, Rocky, Alpine, etc.), add extra drives with different filesystems, configure multiple networks, etc."
  description: "Playground VMs can be used to simulate complex server setups - pick a kernel and a rootfs (Ubuntu, Rocky, Alpine, etc.), add extra drives with different filesystems, configure multiple networks, etc."
- image: __static__/Playgrounds-3-rev2.png
  alt: "Each playground can have up to 5 VMs, connected into one or more networks, which allows provisioning multi-node Kubernetes clusters and practicing complex networking scenarios."
  description: "Each playground can have up to 5 VMs, connected into one or more networks, which allows provisioning multi-node Kubernetes clusters and practicing complex networking scenarios."
---
::

## Learning Materials

On top of Playgrounds, iximiuz Labs offers a **growing collection of learning materials** that give you structure and feedback:

- [Challenges](/docs/learning-materials/challenges) - bite-sized, realistic, hands-on problems with auto-checking, hints, and solutions
- [Tutorials](/docs/learning-materials/tutorials) - deep and heavily illustrated articles with reproducible steps and attached Playgrounds
- [Courses](/docs/learning-materials/courses) - guided sequences that combine lessons with hands-on completion criteria
- [Skill Paths](/docs/learning-materials/skill-paths) - focused learning paths to acquire or hone specific skills or technologies
- [Roadmaps](/docs/learning-materials/roadmaps) - broader learning journeys to master a certain domain (Linux, Docker, or Kubernetes)

::slide-show
---
slides:
- image: __static__/Tutorial.png
  alt: "Tutorial example: ​How Container Networking Works - Building a Bridge Network From Scratch​"
  description: "Tutorial example: ​How Container Networking Works - Building a Bridge Network From Scratch​"
- image: __static__/Challenge.png
  alt: "Challenge example: ​​Enable Internet Access for a Private Network with a NAT Gateway​​"
  description: "Challenge example: ​​Enable Internet Access for a Private Network with a NAT Gateway​​"
- image: __static__/Course.png
  alt: "Course example: ​Computer Networking Fundamentals For Developers​"
  description: "Course example: ​Computer Networking Fundamentals For Developers​"
- image: __static__/SkillPaths.png
  alt: "Skill Path examples: Master Container Networking, Build Container Images Like a Pro, etc."
  description: "Skill Path examples: Master Container Networking, Build Container Images Like a Pro, etc."
- image: __static__/Roadmap-rev2.png
  alt: "Roadmap example: Learn Docker the Hands-on Way"
  description: "Roadmap example: Learn Docker the Hands-on Way"
---
::

::highlight
The ultimate goal is simple: **learn the fundamentals by doing** -
with enough realism to transfer to the job, and enough safety to experiment freely.
::