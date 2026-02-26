---
title: Custom Root FS

name: custom-rootfs
kind: unit
---

It's possible to create a playground with a custom root filesystem, and there are various reasons you might want to do this:

- You want something that's not available from one of the existing [base images](https://github.com/iximiuz/labs/tree/main/playgrounds).
- You want to add additional dependencies on top of one of those existing base images.
- You have a custom playground that's based on an existing base image but it installs a bunch of things and the init tasks make the user wait a long time before the playground is ready.

Depending on which approach you want to take, the process is some variant of the following:

- create a Dockerfile locally that has all the things you want in it

- test that it builds okay

- push the built image to a container registry (preferably ghcr.io over dockerhub due to rate limiting)

- use that image as the drive for a custom playground via the web UI
![using a custom oci URL in the playground UI](./custom-oci-web-ui.png)

- use that image as the drive for a custom playground via a manifest.yaml file and push via `labctl`.

```yaml
          drives:
            - source: oci://ghcr.io/lpmi-13/amazing-demo-image:v1
              mount: /
              size: 30GiB
```


## Additional Resources

- GET_BETTER_EMOJI [Writeup of one experience doing this](https://dev.to/lpmi13/custom-rootfs-for-playgrounds-in-iximiuz-labs-1p7g)
