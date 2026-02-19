---
title: Instantly fork playground runs

name: instant-forking
kind: unit
---

Using copy-on-write overlay volumes for playground persistence enables some really powerful use cases.

Imagine you're working on a task - it can be a server configuration issue, a particularly involved Kubernetes cluster,
or a coding problem. You've been on it for hours - cloning GitHub repos, running ad hoc shell commands, restarting services, etc.
Finally, you manage to produce a certain state you want to preserve. You hit the Stop button, enjoying the playground persistence,
and go to sleep.

But the next day, you wake up not with 1 but with 3 ideas how to proceed. If only it were possible to "clone" the state of your
playground and try all three hypotheses against the same system.

Infrastructure as Code is the way, but there is a big problem with this approach - you need to know upfront that the
setup should be scripted. Clearly, we're already past that point.


::image-box
---
:src: __static__/Persistent-Playgrounds-2.png
:alt: "Once a playground is stopped, you can fork it to create a new playground with the exact same state. The best part is that forks are instant and take no extra space (until modified)."
---

Once a playground is stopped, you can fork it to create a new playground with the exact same state. The best part is that forks are instant and take no extra space (until modified).
::
