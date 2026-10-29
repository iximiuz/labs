---
title: Examples of Playgrounds Created by iximiuz Labs Users

name: playground-examples
kind: unit
---

Here are some of the [playgrounds created by iximiuz Labs](/playgrounds?filter=community) users that showcase their skills and creativity:

## Ibtisam's CI/CD Lab

A series of playgrounds starting with an [Ubuntu-based Dev Machine](https://labs.iximiuz.com/playgrounds/SilverStack-dev-machine-e672bcf7) carrying the common DevOps tools, then adding [Jenkins](https://labs.iximiuz.com/playgrounds/SilverStack-jenkins-server-63fe430c), [Nexus](https://labs.iximiuz.com/playgrounds/SilverStack-nexus-server-9a3f87e9), and [SonarQube](https://labs.iximiuz.com/playgrounds/SilverStack-sonarqube-server-7761f36f) servers, and finally combing all 4 VMs into a complete [CI/CD solution](https://labs.iximiuz.com/playgrounds/SilverStack-CICD-Stack-1766a8a1). And the best part, all the machines can be accessed on their own domains like `jenkins.ibtisam-iq.com` or `sonar.ibtisam-iq.com` - thanks to the Cloudflare Tunnel magic. Ibtisam thoroughly documented his setup in a blog post [Building a Self-Hosted CI/CD Stack Behind NAT: From EC2 to iximiuz Labs with Cloudflare Tunnel](https://runbook.ibtisam-iq.com/self-hosted/ci-cd/iximiuz/), and the iximiuz Labs playground manifests he wrote to create the lab are [available on GitHub](https://github.com/ibtisam-iq/silver-stack/tree/main/iximiuz). Ibtisam even went the extra mile and baked custom rootfs images for each of the servers, [outlining the process in a separate runbook](https://runbook.ibtisam-iq.com/containers/iximiuz/).

I cannot think of a better way to demonstrate your infrastructure skills than this combo 👏

::image-box
---
:src: __static__/SliverStack-Jenkins-Server-Playground.png
:alt: "Ibtisam's CI/CD Lab Jenkins Server Playground"
:border: 'border border-slate-400'
:radius: 'lg'
---
::

## Arjun's Full Ubuntu Desktop in the Browser

Arjun created a [playground](https://labs.iximiuz.com/playgrounds/ubuntu-desktop-on-web-df04797f) that runs a full Ubuntu Desktop in the browser using [Apache Guacamole](https://guacamole.apache.org/).
The playground both shows Arjun's ability to set up a complex infrastructure and his outside-the-box thinking - using a headless remote VM to run a full Linux desktop isn't the most obvious way to go, but it's a creative alternative for purchasing a Mac mini to run your OpenClaws.

::image-box
---
:src: __static__/Ubuntu-Desktop-Playground.jpg
:alt: "Arjun's Full Ubuntu Desktop in the Browser Playground"
:border: 'border border-slate-400'
:radius: 'lg'
---
::

<!--
TODO: Add more examples

- Adam
  - https://labs.iximiuz.com/playgrounds?author=adam-leskis&filter=all
  - https://dev.to/lpmi13/an-iximiuz-cluster-of-clusters-with-tailscale-and-cilium-43d4
  - https://dev.to/lpmi13/custom-rootfs-for-playgrounds-in-iximiuz-labs-1p7g
  - https://dev.to/lpmi13/what-to-devops-an-iximiuz-labs-speedrun-to-the-rescue-384 and https://www.youtube.com/watch?v=W2RTsBTbAsI
  - https://dev.to/lpmi13/remote-homelab-admin-with-tailscale-1jp2 and https://www.youtube.com/watch?v=VlHK9XdbQtY

- Mark
  - https://labs.iximiuz.com/playgrounds?author=mark-sagi-kazar&filter=all
-->
