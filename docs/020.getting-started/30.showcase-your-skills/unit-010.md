---
title: Showcase Your Skills

name: showcase-your-skills
kind: unit
---

::remark-box
This section is about **how to stand out in the job market as a DevOps/SRE/Platform engineer** by showcasing your Linux, networking, containers, and Kubernetes skills using iximiuz Labs playgrounds.
::

Hands-on experience and real-world problem solving skills are two factors that truly differentiate tech candidates.
Certificates? In our opinion, not so much.
The latter often focus on Linux or Kubernetes trivia and command-line muscle memory, which are becoming of questionable day-to-day utility, especially with AI generating better and better YAML manifests and CLI commands.

However, the question is, how to prove your experience and **provide evidence of your infrastructure skills?**
Showcasing software development skills is somewhat easier - devs can create GitHub repositories with their code and even deploy sites demonstrating their work. But how to prove your DevOps/SRE/sysadmin abilities?

::highlight
This is the problem that shareable online Linux playgrounds can solve.
::

When you encounter an interesting automation use case or nail a particularly tricky multi-server setup, or bend a Kubernetes cluster to your will,
we recommend preparing a custom iximiuz Labs playground​ to demonstrate the problem and the solution(s) you've come up with.

Some examples:

- [​Set up Kubernetes the Hard Way​](/playgrounds/kubernetes-the-hard-way-7df4f945)
- [​Configure a HA Kubernetes Cluster​](/playgrounds/kubernetes-ha-d02b8d83)
- [​Configure an etcd Cluster](/playgrounds/etcd-cluster-e368a3ff) (often overlooked)​
- ​Compare two alternative solutions (e.g., [OpenBao vs. Vault](/playgrounds/openbao-vault-a3133f3e))
- [​Set up an ELK Stack​](/playgrounds/my-elk-stack-log-observability-6d722e9b)
- [​Make Docker work on Btrfs​](/playgrounds/docker-on-btrfs-93561c5b)
- Deploy a 3-tier web app ([and record a demo](https://www.youtube.com/watch?v=W2RTsBTbAsI))

::image-box
---
:src: __static__/Playgrounds-4.png
:alt: "An example of a setup you can configure using a 5-node Flexbox playground."
---

An example of a setup you can configure using a 5-node [Flexbox](/playgrounds/flexbox) playground.
::

All of the above are technically just remote Linux VMs, configured in a certain way and exposed publicly with a URL,
which makes them **a perfect shareable unit of experience**.
Now, instead of including a link to a GitHub repo with a bunch of Terraform files (which may or may not be ~~AI slop~~ working),
you can include a link to an interactive environment that the hiring team can actually start and explore (and get impressed by your Linux, Docker, or Kubernetes talent).

Getting started with [custom playgrounds](/docs/playgrounds/custom-playgrounds) is straightforward:
fill out the name and (optionally) description on [labs.iximiuz.com/new/playground](/new/playground) and click **Create**.

Once the playground is created, you can use the UI constructor to add or remove virtual machines, deploy custom init scripts, set up multiple networks, or add extra drives:

::image-box
---
:src: __static__/playground-constructor.png
:alt: "iximiuz Labs Playgrounds constructor UI"
:border: 'border border-slate-400'
:radius: 'lg'
---

[Video Demo](https://www.youtube.com/watch?v=gNlQ65frMcs)
::

Of course, all of the above can also be done in the command line with [`labctl`](https://github.com/iximiuz/labctl):

- `labctl playground create` to get started
- `labctl playground manifest` to view a YAML manifest of an existing playground
- `labctl playground update` to update the playground
- `labctl playground start` to start a new instance of the playground

::details-box
---
summary: Click here for a working "labctl playground create" example
---

```sh
labctl playground create --base flexbox my-custom -f -<<EOF
kind: playground
title: My Awesome Custom Playground
categories:
  - linux
playground:
  accessControl:
  canList:
    - owner
  canRead:
    - owner
  canStart:
    - owner
  machines:
  - name: vm-1
    users:
    - name: root
      default: true
    drives:
    - source: ubuntu-24-04
      mount: /
    network:
    interfaces:
      - network: local
    resources:
    cpuCount: 2
    ramSize: 4G
EOF
```
::

You can find a few more practical examples of how to create custom playgrounds in [this blog post](https://iximiuz.com/en/posts/iximiuz-labs-playgrounds-2.0/),
and, of course, you can always get some inspiration from the [playgrounds published by other iximiuz Labs users​](/playgrounds?filter=community) -
there are quite a few already!
The best part about it is that you can always explore how the existing playgrounds are implemented
(by either adding **/settings** to the playground URL or using the `labctl playground manifest` command).
And you can even clone an existing playground and base your own work on it, dodging the "blank page" trap (a.k.a., writer's block).

By assembling a few Linux, networking, Docker, or Kubernetes playgrounds, you'll gain invaluable insights into the target technology, navigate and resolve several automation challenges, and deepen your own understanding (even if you thought you were already an expert - happens to me all the time, even after all the years of tinkering).

::highlight
But don't stop at scripting!
::

The playground is only done when other people can understand how (and why) to use and learn something from it.
Prepare a good problem description, add a diagram or two, and write helpful welcome messages that people will see when they log in to your playground VMs. It'll make the playground much easier to share on social, in a blog post, or with teammates, and including a link to such a well-crafted playground in your resume will **showcase another key skill hiring managers look for: clear communication.**

::image-box
---
:src: __static__/kubeadm-playground.png
:alt: "Kubeadm Playground by Márk Sági-Kazár"
---

[Kubeadm Playground](/playgrounds/kubeadm-072aadb3) by Márk Sági-Kazár
::

Finally, by sharing your work publicly long enough, you'll signal your professional interests to the outside world, attract like-minded people, and **form the much-needed connections for a successful career**, gaining people's trust.
Start investing in your public profile today, one playground, blog post, or side project at a time.