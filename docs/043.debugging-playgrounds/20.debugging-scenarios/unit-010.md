---
title: Something doesn't work inside an otherwise functional play
name: broken-service
kind: unit
---

The [toolbox](/docs/debugging-playgrounds/debugging-toolbox) is the same, but where to start depends on what exactly is broken.
Find your situation in the units of this lesson.

The play is up, the terminals work, but a service isn't listening, a command fails, a container won't start.
Nothing playground-specific here - it's a Linux box, and all the usual debugging techniques apply:

```sh
systemctl status <unit>; journalctl -u <unit> -n 100    # is the service running? what did it say?
ps aux | grep <name>; top                                # is the process alive? is something eating the CPU?
ss -ltnp                                                 # who is listening on which port (and on which address)?
curl -v http://localhost:<port>/                         # does it answer locally? (before blaming port exposure or networking)
dmesg | tail; df -h; free -m                             # kernel complaints, full disks, memory pressure
```

A few playground-flavored hints:

- Make sure you're on the right machine: `labctl ssh <play-id> -m <machine>`, or check the machine name in the terminal tab / shell prompt.
- The machines are sized by the manifest (`resources`), and the defaults are modest - a service that works on a beefy laptop may be OOM-killed in a 2-4 GB VM.
- If the service was supposed to be set up by an init task, verify the task actually did what you think - `examinerctl task get <name>` or the **Tasks** tab (see the next scenario).
- To watch a unit's logs without occupying a terminal, stream them from outside: `labctl playground machine journal <play-id> <machine> -u <unit>`.
