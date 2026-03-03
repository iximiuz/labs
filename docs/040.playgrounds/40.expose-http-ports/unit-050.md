---
title: Exposing a Kubernetes application via a NodePort service

name: exposing-kubernetes-application-via-nodeport
kind: unit
---

1. Start a new [Kubernetes playground](/playgrounds/k3s):

```sh
PLAY_ID=$(labctl playground start k3s)
```

2. Deploy a sample Kubernetes application (a single Pod would do the trick):

```sh
labctl ssh $PLAY_ID -- kubectl run nginx-01 --image=nginx:alpine
```

3. Expose the application with a NodePort service:

```sh
labctl ssh $PLAY_ID -- kubectl expose pod nginx-01 --port=80 --type=NodePort
```

4. Find the application's NodePort:

```sh
labctl ssh $PLAY_ID -- kubectl get svc nginx-01
```

```text
NAME       TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
nginx-01   NodePort   10.43.195.70   <none>        80:30762/TCP   42s
```

5. Expose the NodePort service using the right port number **and one of the cluster's nodes**:

```sh
labctl expose port $PLAY_ID 30762 --machine node-01 --public
```

```text
HTTP port node-01:30762 exposed as https://69a725671fce5dfccd59a92f-026f01.node-eu-d241.iximiuz.com
https://69a725671fce5dfccd59a92f-026f01.node-eu-d241.iximiuz.com
```

6. Verify that the Nginx server is accessible by opening the generated URL in a browser.
