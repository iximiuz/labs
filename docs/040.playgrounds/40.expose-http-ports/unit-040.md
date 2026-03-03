---
title: Exposing a Docker container's published port

name: exposing-docker-container
kind: unit
---

1. Start a new [Docker playground](/playgrounds/docker):

```sh
PLAY_ID=$(labctl playground start docker)
```

2. Start a new Nginx container making it available on the playground VM's `0.0.0.0:8080` address:

```sh
labctl ssh $PLAY_ID -- docker run -d -p 8080:80 nginx:alpine
```

3. Expose the published port 8080 with a public URL:

```sh
labctl expose port $PLAY_ID 8080 --public
```

```text
HTTP port docker-01:8080 exposed as https://69a724cd1fce5dfccd59988d-b605c8.node-eu-d241.iximiuz.com
https://69a724cd1fce5dfccd59988d-b605c8.node-eu-d241.iximiuz.com
```

4. Verify that the Nginx server is accessible from the public URL:

```sh
curl https://69a724cd1fce5dfccd59988d-b605c8.node-eu-d241.iximiuz.com
```

The output should be the Nginx welcome page.
