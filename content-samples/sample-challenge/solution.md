This is a Containers 101 challenge.

The solution will use the `ghcr.io/iximiuz/labs/nginx:alpine` image,
but you can use any other image you like (as long as it's long-running container).

To start a container, you can use the following command:

<!--more-->

```sh
docker run -d ghcr.io/iximiuz/labs/nginx:alpine
```

The `-d` flag runs the container in the background, so you can continue using the same shell.

To verify the container is running, you can use the following command:

```sh
docker ps
```

If the output of the above command is empty, the container is not running.
To check its status, adjust the command to:

```sh
docker ps -a
```

Hopefully, the container is running, though, so grab its ID from the `docker ps` output and paste it to the input task.

To find the PID of the container, you can use the following command:

```sh
docker container inspect \
    --format '{{.State.Pid}}' \
    CONTAINER
```

...where `CONTAINER` is either the container name or ID.

Alternatively, you can list all processes on the host and try finding the containerized process in the output:

```sh
ps auxf | grep nginx
```

The PID returned by the `docker container inspect` command and
the PID of the topmost `nginx` process in the output of the `ps` command should match,
because Linux containers are, in fact, regular processes running on the host.

Finally, to find the IP address of the container, you can use the following command:

```sh
docker container inspect \
    --format '{{.NetworkSettings.IPAddress}}' \
    CONTAINER
```

...where `CONTAINER` is again either the container name or ID.

If the container you chose has a full-blown Linux distribution (like the `nginx:alpine` image),
you can also try to find its IP address by executing `ip addr show` from inside the container:

```sh
docker exec CONTAINER ip addr show
```

The output of the above command should include the IP address of the container,
which in turn should match the IP address returned by `docker container inspect`.
