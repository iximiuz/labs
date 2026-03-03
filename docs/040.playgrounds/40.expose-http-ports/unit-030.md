---
title: How to Expose HTTP/HTTPS Ports using the CLI

name: cli
kind: unit
---

You can also expose a port using [`labctl`](/docs/playgrounds/how-to-use-playgrounds#cli):

```sh
labctl expose port --help
```

```text
Expose an HTTP(s) service running in the playground

Usage:
  labctl expose port <playground> <port> [flags]

Flags:
  -h, --help                  help for port
      --host-rewrite string   Rewrite the host header passed to the target service
  -s, --https                 Enable if the target service uses HTTPS (including self-signed certificates)
  -m, --machine string        Target machine (default: the first machine in the playground)
  -o, --open                  Open the exposed service in browser
      --path-rewrite string   Rewrite the path part of the URL passed to the target service
  -p, --public                Make the exposed service publicly accessible
```

Below are a few practical examples of how to use the `labctl expose port` command.
