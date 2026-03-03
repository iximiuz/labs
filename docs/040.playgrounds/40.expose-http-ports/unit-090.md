---
title: Troubleshooting

name: troubleshooting
kind: unit
---

If the generated URL is not working, check the following:

- Is the target application up and running?
- Do you use the correct machine and port in the **Expose HTTP(S) Ports** dialog (or the CLI command)?
- Does the target application serves traffic over HTTP or HTTPS? If the latter, did you set the **HTTPS** option to **Yes** in the **Expose HTTP(S) Ports** dialog?
- Does the target port appear in the `ss -lntp` output when run from the playground VM?
- Is the target port open on the machine's main interface (or `0.0.0.0`)?
- Does the test `curl` command from the **Expose HTTP(S) Ports** dialog show the expected response?
