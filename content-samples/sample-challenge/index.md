---
kind: challenge

title: 'Sample Challenge: Start and Inspect a Container With Docker'

description: |
  Learn how to author challenges on iximiuz Labs by "reverse engineering" a realistic challenge example.

categories:
  - linux
  - containers

tagz:
  - hello-world
  - example
  - challenge-docs

difficulty: easy

createdAt: 2025-03-28
updatedAt: 2025-07-30

cover: __static__/different-ways-to-start-containers.png

playground:
  name: docker

tasks:
  verify_container:
    hintcheck: |
      if [ $(docker_container_count_total) -gt 1 ]; then
        echo "Have you started more than one container?"
        echo "This challenge requires only one container to be running."
        exit 0
      fi

      if [ $(docker_container_count_total) -gt 0 ] && [ $(docker_container_count_running) -eq 0 ]; then
        echo "Seems like there is a container, but it's not running."
        echo "Did it crash, exited too quickly, or have you created but not started it?"
        exit 0
      fi
    run: |
      [ $(docker_container_count_running) -gt 1 ] && echo "Too many running containers" && exit 1
      [ $(docker_container_count_running) -lt 1 ] && echo "No running containers" && exit 1

      sleep 2  # making sure it's stable enough

      [ $(docker_container_count_running) -gt 1 ] && echo "Too many running containers" && exit 1
      [ $(docker_container_count_running) -lt 1 ] && echo "No running containers" && exit 1

      docker ps -q --no-trunc

  verify_container_id:
    needs:
      - verify_container
    env:
      - CONTAINER_ID=x(.needs.verify_container.stdout)
    failcheck: |
      if ! docker_container_is_running ${CONTAINER_ID}; then
        echo "The container isn't running anymore. Did it crash?"
        exit 1
      fi
    hintcheck: |
      if ! docker_container_is_running ${CONTAINER_ID}; then
        echo "To understand what happened, try running 'docker ps -a'."
        echo "It'll show all containers, including non-running ones."
      fi
    run: |
      PROVIDED_ID="$(cat /tmp/container-id.txt)"
      if [ "${PROVIDED_ID}" == "" ]; then
        echo "Provided container ID is empty"
        exit 1
      fi

      if [[ "${CONTAINER_ID}" != "${PROVIDED_ID}"* ]]; then
        echo "Container ID is not correct"
        exit 1
      fi

  verify_container_pid:
    needs:
      - verify_container
    env:
      - CONTAINER_ID=x(.needs.verify_container.stdout)
    failcheck: |
      if ! docker_container_is_running ${CONTAINER_ID}; then
        echo "The container isn't running anymore. Did it crash?"
        exit 1
      fi
    hintcheck: |
      if ! docker_container_is_running ${CONTAINER_ID}; then
        echo "To understand what happened, try running 'docker ps -a'."
        echo "It'll show all containers, including non-running ones."
      fi
    run: |
      PROVIDED_PID="$(cat /tmp/container-pid.txt)"
      if [ "${PROVIDED_PID}" == "" ]; then
        echo "Provided container PID is empty"
        exit 1
      fi

      if [ "${PROVIDED_PID}" != "$(docker_container_pid ${CONTAINER_ID})" ]; then
        echo "Container PID is not correct"
        exit 1
      fi

  verify_container_ip:
    needs:
      - verify_container
    env:
      - CONTAINER_ID=x(.needs.verify_container.stdout)
    failcheck: |
      if ! docker_container_is_running ${CONTAINER_ID}; then
        echo "The container isn't running anymore. Did it crash?"
        exit 1
      fi
    hintcheck: |
      if ! docker_container_is_running ${CONTAINER_ID}; then
        echo "To understand what happened, try running 'docker ps -a'."
        echo "It'll show all containers, including non-running ones."
      fi
    run: |
      PROVIDED_IP="$(cat /tmp/container-ip.txt)"
      if [ "${PROVIDED_IP}" == "" ]; then
        echo "Provided container IP is empty"
        exit 1
      fi

      if [ "${PROVIDED_IP}" != "$(docker_container_ip ${CONTAINER_ID})" ]; then
        echo "Container IP is not correct"
        exit 1
      fi
---

This sample material serves as a guide on how to author **challenges** on iximiuz Labs.
You can find the source of this document on [GitHub](https://github.com/iximiuz/labs-content-samples/tree/main/sample-challenge).
Feel free to use it as a starting point for your own challenges.


## What is a Challenge on iximiuz Labs?

Challenges are focused hands-on problems designed to help the learner hone their DevOps or Server Side skills.
While tutorials are more about explaining concepts, challenges are about applying those concepts.
Some challenges can be more educational, while others can be based on real-world scenarios.
Challenges must have automated solution checks and can provide hints and feedback based on user's actions in the playground.


## Can I add a Solution to the Challenge?

Yes, but please don't place it in the challenge's `index.md` file.
Instead, create a new file in the challenge's directory named `solution.md`
(or `solution-01.md`, `solution-02.md`, etc. if the challenge has multiple solutions) and place the solution there.
This way, you won't "spoil" the challenge for those learners who prefer to solve it on their own.


## How to Author a Challenge

From the authoring perspective, the process is rather similar to authoring tutorials.
Refer to the comprehensive [tutorial authoring guide](/tutorials/sample-tutorial) to learn how to author content on iximiuz Labs.
The main difference between a tutorial and a challenge is semantic:

- A tutorial explains concepts and provides a guided walkthrough.
- A challenge expects the learner to apply concepts.

Similar to tutorials, challenges can be started and completed by authenticated users.
However, the completion of a challenge is checked automatically in the background,
so the user doesn't need to mark the challenge as completed manually when all tasks are accomplished.


## Example Challenge

In this challenge, you will need to perform the most fundamental Docker operation - start a container.

::image-box
---
:src: __static__/different-ways-to-start-containers.png
:alt: Different ways to start containers (Docker, Podman, nerdctl, ctr.)
:max-width: 600px
---
::

You can use any container image you like,
but we recommend choosing a long-running container (e.g., `nginx`)
because to complete this challenge you will also need to inspect the running container and answer a few questions about it.

::simple-task
---
:tasks: tasks
:name: verify_container
---
#active
Waiting for the container to start...

#completed
Yay! The container is running 🎉
::

::hint-box
---
:summary: Hint 1
---

It's an easy one - `docker --help` is your friend.
::

To keep track of containers, Docker assigns a unique ID to each of them.
Can you find the ID of the container that you've just started?

::user-input-task
---
:tasks: tasks
:name: verify_container_id
:validateRegex: ^[a-f0-9]+$
:destination: /tmp/container-id.txt
---
#active
Waiting for the container ID to be identified...

#completed
Yay! You've found the running container ID 🎉
::

::hint-box
---
:summary: Hint 2
---

Same advice as in the previous hint - `docker --help` is your friend 😉
::

Now, when you have a running container, let's try to understand what it actually is.

Did you know that [Docker containers are "just" Linux processes](https://iximiuz.com/en/posts/oci-containers/)?
Can you locate the main container's process? What is its PID?

::user-input-task
---
:tasks: tasks
:name: verify_container_pid
:validateRegex: ^[0-9]+$
:destination: /tmp/container-pid.txt
---
#active
Waiting for the container PID to be identified...

#completed
Yay! You've found the running container PID 🎉
::

::hint-box
---
:summary: Hint 3
---

If containers are _regular Linux processes_, will they show up in `ps` or `top` output? 🤔
::

::hint-box
---
:summary: Hint 4
---

Entered a PID of a process that definitely belongs to the container, but the solution checker doesn't accept it?
One of the key Docker design principles is to run **one service per container**.
However, it doesn't mean that every container will have only one process inside.
Actually, more often than not, you'll find a whole process tree inside a container.
Try identifying the root process of that tree.
That's what the checker expects.
::

::hint-box
---
:summary: Hint 5
---

Still having trouble?
You can always fall back to `docker inspect` to cross-check your findings.
::

Approximating containers to _regular Linux processes_ is helpful, but it's not very accurate.
Thinking of containers as of _boxes for processes_ might be even more helpful at times.

::image-box
---
:src: __static__/container-box.png
:alt: A Linux container visualized as a box for one application.
:max-width: 500px
---
::

From inside the box, it may look like the containerized app is running on its own machine.
In particular, such a virtualized environment will have its own network interface and an IP address.
Can you find the IP address of the container that you've just started?

::user-input-task
---
:tasks: tasks
:name: verify_container_ip
:validateRegex: ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$
:destination: /tmp/container-ip.txt
---
#active

Waiting for the container IP address to be identified...

#completed
Yay! You've found the running container IP 🎉
::

::hint-box
---
:summary: Hint 6
---

There are many ways to find the container IP address.
If you're a Linux guru, you can try your luck with `ip netns` and `ip addr`.
::

::hint-box
---
:summary: Hint 7
---

Don't feel comfortable messing with Linux network namespaces?
You can always use the `docker inspect` command to find the container IP address.
::
