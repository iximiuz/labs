---
title: Using custom rootfs images

name: custom-rootfs
kind: unit
---

It's possible to create a playground with a custom root filesystem, and there are various reasons you might want to do this:

- You want something that's not available from one of the existing [base images](https://github.com/iximiuz/labs/tree/main/playgrounds).
- You want to add additional dependencies on top of one of those existing base images.
- You have a custom playground that's based on an existing base image but it installs a bunch of things and the init tasks make the user wait a long time before the playground is ready.

Depending on which approach you want to take, the process is some variant of the following:

- Create a Dockerfile locally that has all the things you want in it

- Test that it builds okay

- Push the built image to a container registry (preferably ghcr.io; **note that Docker Hub is not supported** due to its strict rate limiting)

- Use that image as the drive for a custom playground via a manifest.yaml file and push via `labctl`.

```yaml
kind: playground
name: <playground-name>
playground:
  machines:
    - name: <machine-name>    
      drives:
        - source: oci://ghcr.io/lpmi-13/amazing-demo-image:v1
          mount: /
          size: 30GiB
```

- Use that image as the drive for a custom playground via the web UI

::image-box
---
:src: __static__/custom-oci-web-ui.png
:alt: Setting a custom OCI image as a VM drive rootfs source using the Playground Constructor UI.
:border: 'border border-slate-400'
:radius: 'lg'
---

Setting a custom OCI image as a VM drive rootfs source using the Playground Constructor UI.
::

## Additional Resources

- [Writeup of one experience doing this](https://dev.to/lpmi13/custom-rootfs-for-playgrounds-in-iximiuz-labs-1p7g)
