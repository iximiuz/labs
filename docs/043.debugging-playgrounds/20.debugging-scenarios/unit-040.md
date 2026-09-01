---
title: A playground run doesn't seem to be reachable
name: unreachable
kind: unit
---

Symptoms: the terminal tab shows "Connecting..." forever, the IDE tab doesn't load, `labctl ssh` hangs.

1. First things first - **exclude local connectivity issues**. If the web terminal isn't connecting, try `labctl ssh <play-id>` from your machine; if `labctl ssh` fails, open the play page and try the web terminal.
   If one of them works, the play is fine, and the problem is on the path: a corporate proxy or firewall dropping WebSocket connections, a browser extension, a VPN, a flaky network.
   The connection status dot in the play page header helps too: green means the browser holds a live connection to the play, orange - it's still connecting, red - the play is gone.
2. Then assess the play's state in the Play Debug Console (**Play Spec**): is `running` true, are all `machines` in the `RUNNING` state, are the boot conditions `True`,
   has the play perhaps already expired (`expiresIn`)? The same from the command line: `labctl playground status <play-id>` (machines are listed as `name=STATE (ready)`) and `labctl playground machines <play-id>`.
3. Finally, resort to the per-machine commands. `labctl playground machine console <play-id> <machine>` shows whether the guest booted and got to the login prompt;
   `labctl playground machine journal <play-id> <machine> -u ssh` (`-u sshd` on non-Debian distros) shows what the SSH daemon is doing;
   a machine in the `STOPPED` state can be brought back with `labctl playground machine restart`, and a wedged one bounced with `labctl playground machine reboot`.

Also keep in mind that a machine with `noSSH: true` in the manifest has no shell access by design - neither terminals nor `labctl ssh` will work for it (the Play Spec shows the flag).
