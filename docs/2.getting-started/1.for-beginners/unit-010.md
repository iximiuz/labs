---
title: For Linux and DevOps Beginners

name: for-beginners
kind: unit
---

At the moment, for a Linux/DevOps beginner, the best place to start at iximiuz Labs is the [hands-on Docker roadmap](/roadmaps/docker).
We recommend solving hands-on challenges from the roadmap,
starting from the top, and always following the links to the theoretical materials that most challenges include.
And of course, don't forget to check the Solution sections if you get stuck or even if you've solved the challenge -
there might be an alternative or simpler way, and the editorial solutions may shed some extra light on what's going on under the hood.

::image-box
---
:src: __static__/Roadmap-rev2.png
:alt: Docker Roadmap
---
Roadmap: [Docker The Hands-on Way](/roadmaps/docker)
::

Another beginner-friendly piece of learning materials is the [L2 Networking Fundamentals course](/courses/computer-networking-fundamentals),
augmented by these L3 challenges:

- [Configure Routes to Connect Two Private Networks](/challenges/networking-configure-basic-routing)
- [Enable Internet Access for a Private Network with a NAT Gateway](/challenges/networking-configure-nat-gateway)

The above networking materials can be taken before, after, or in parallel with the Docker roadmap.

After getting through a couple of dozen Docker challenges and studying the networking fundamentals materials,
it's a great time to take the [Container Networking from Scratch](/tutorials/container-networking-from-scratch) tutorial.

::image-box
---
:src: __static__/bridge.png
:alt: Container Networking from Scratch tutorial
---
::

The applicability of the knowledge in it is much broader than just Docker bridge networks -
it's the foundation everyone needs before approaching the more complex Kubernetes networking model,
and it'll also come in handy while learning other virtualization tech
(e.g., Firecracker, QEMU, VirtualBox VMs, Lima, Kata Containers, etc.).

While going through the above materials, you'll get to solve [many practical Linux problems](/challenges?filter=all&category=linux).
Some in the form of complementary challenges, some as subtasks of Docker or networking challenges.
In any case, you'll become much more fluent and confident in using the terminal and operating servers.

For people with prior Linux and container experience, or those who are eager to jump right into Kubernetes,
we recommend starting with the [How Kubernetes Reinvented Virtual Machines](/tutorials/kubernetes-vs-virtual-machines) tutorial.
This tutorial provides a certain perspective that will help you connect the dots between the traditional VM model,
containers, and orchestrators like Kubernetes.

The next logical step is to take the [Docker Containers vs. Kubernetes Pods](/tutorials/containers-vs-pods) tutorial,
and finally get your hands dirty by solving [practical Kubernetes challenges](/challenges?category=kubernetes&difficulty=easy&difficulty=medium&filter=all).

::slide-show
---
slides:
- image: __static__/vm-service.png
  alt: A group of virtual machines constituting a service.
- image: __static__/deployment-2000-opt.png
  alt: Kubernetes Deployment - a means to replicate Pods.
- image: __static__/canary-2000-opt.png
  alt: A single Kubernetes Service fronting two Deployments.
---
::

Finally, we need to emphasise that iximiuz Labs is not a single course but a holistic learning and experimentation platform.
One of the key features of iximiuz Labs is its [Playgrounds](/playgrounds).
In essence, they are remote, preconfigured Linux VMs that are ideal for practicing Linux,
networking, Docker, or Kubernetes in a safe, controlled environment.
Most of the platform's learning materials embed a playground on the side to help you practice what you've just read,
but you can (and should) use standalone playgrounds for your learning tasks, too.

A typical example: while studying system design, you may want to explore the traditional 3-tier web app architecture,
and the best way to do it is to actually deploy an API server,
a database, and a client with your own hands using some well-known sample applications like [Awesome Docker Compose samples](https://github.com/docker/awesome-compose) or [Kubernetes application examples](https://github.com/kubernetes/examples).