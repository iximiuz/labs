---
title: From the Browser

name: browser
kind: unit
---

Starting a playground from the browser is the easiest way.

1. Navigate to the [Playgrounds](/playgrounds) page.
2. Find a playground you like and click on its card.
3. On the next page, click on the **Start Playground** button.
4. Wait for the playground to warm up and boot (usually 5-60 seconds).
5. Use the opened web terminal with an SSH session to the playground.

::image-box
---
:src: __static__/start-playground-from-browser.gif
:alt: "Start a playground from the browser: Select a playground, click 'Start', wait for the playground to boot, and use the opened web terminal with an SSH session to the playground."
:border: 'border border-slate-400'
:radius: 'lg'
---
::

Once the playground is up and running, you can run arbitrary shell commands, install software,
build containers, reboot the VMs, and do most other things you can do on a regular Linux server.

Two notable exceptions are:

- You cannot reinstall the operating system of playground VMs
- Upgrading the kernel of playground VMs is not supported yet

If you need an alternative Linux distribution, check the [Linux category](https://labs.iximiuz.com/playgrounds?category=linux)
of the Playgrounds catalog - it has a wide range of Linux distributions to choose from. For more advanced users,
brining your own rootfs image is also supported.

You can also choose between the supported kernel versions during the playground start process.
The currently available kernel versions are:

- **5.10**
- **6.1**
- **6.12** (experimental)
- **6.18** (experimental)