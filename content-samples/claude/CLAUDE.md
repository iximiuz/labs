# General Project Information

The project contains several collections of learning materials for different server-side technologies: Linux, networking, containers, Kubernetes, etc.
The materials are hosted on the [iximiuz Labs](https://labs.iximiuz.com) interactive learning platform.

## Role and Responsibilities

You're an author agent. Your responsibilities are to:

- Create new challenges, tutorials, courses, and skill paths
- Update existing challenges, tutorials, courses, and skill paths
- Test and troubleshoot challenges and tutorials by running the attached playground and executing the commands in it

## Content Structure

The materials are grouped by the content kind:

- [Challenges](../challenges) - bite-sized practical problems that can be solved by running commands in a sandboxed environment (with automated verification)
- [Tutorials](../tutorials) - technical deep-dives into the subject matter, often contain reproducible shell commands that can be executed in an attached Linux playground
- [Courses](../courses) - compound pieces of learning materials that can been seen as a combination of tutorials (called lessons) and challenges (linked from the lessons)
- [Skill Paths](../skill-paths) - a flat and relatively short list of other learning materials linked together by a common theme (unlike courses, has a minimal added information on top of the linked materials)

All materials are written in markdown. Challenges, tutorials, and course lessons additionally can have a "playground" section defined in the markdown's frontmatter (as a YAML preamble).

### Folder Naming Convention

Each subfolder is named after the corresponding page on `labs.iximiuz.com`. For example:

- `challenges/linux-network-namespace/` -> https://labs.iximiuz.com/challenges/linux-network-namespace
- `tutorials/container-networking-from-scratch/` -> https://labs.iximiuz.com/tutorials/container-networking-from-scratch
- `courses/containerd-cli/` -> https://labs.iximiuz.com/courses/containerd-cli
- `skill-paths/build-container-images/` -> https://labs.iximiuz.com/skill-paths/build-container-images

Some remote content has a random hex suffix (e.g., `docker-101-container-exec-6e812f1f`) while the local folder omits it (e.g., `docker-101-container-exec`). Use the `detect-local-content-folder` skill to resolve local paths reliably.

### Content Format Reference

Before creating or editing content, fetch the self-documenting format samples from the [rules](rules/) directory. The rules reference sample files in the [iximiuz/labs](https://github.com/iximiuz/labs/tree/main/content-samples) repository (see the `content-samples` subfolder).

## Playgrounds

A Playground is a sandboxed environment represented by one or more remote virtual machines (VMs) that are pre-provisioned and pre-configured with the necessary tools and dependencies. The learning platform offers a rich collection of predefined playgrounds (`ubuntu-24-04`, `debian-stable`, `docker`, `k8s-omni`, `k3s`, etc.). Use the `list-available-playgrounds` skill to browse the catalog.

Playgrounds can be used as is or additionally customized by defining `init` tasks in the playground's section of the `index.md` file.

## Tasks

Tasks are shell scripts defined in the YAML frontmatter of `index.md` that are executed by the **examiner** - an agent running on the playground VM. Tasks serve two purposes: preparing the environment and verifying the user's progress. Each task has a `run:` field with a shell script where exit code 0 means success and non-zero means failure.

### Init Tasks

Init tasks (`init: true`) run automatically when the playground starts, before the user interacts with it. They set up the environment: creating files, importing container images, starting services, configuring network namespaces, etc. Named with the `init_` prefix by convention (e.g., `init_import_images`, `init_create_netns`).

### Verification Tasks

Verification tasks (no `init` field) check whether the user has completed a challenge objective. They run when triggered by the platform and their output is shown to the user. Named with the `verify_` prefix by convention (e.g., `verify_container_running`, `verify_netns_created`).

### Task Dependencies and Data Flow

Tasks can depend on other tasks via `needs:` and pass data between each other via `env:` with the `x(.needs.<task>.stdout)` syntax. This allows building multi-step verification chains.

### Task Sizing Guidelines

Follow the **single responsibility principle** when designing tasks. Each task should do one thing and its success or failure should reflect a single action. This makes debugging easier and gives clearer signal when something fails. For example, instead of one init task that installs a tool, pulls an image, and starts a service, split it into three tasks chained with `needs:`:

- `init_install_tool` - install the required CLI tool
- `init_pull_image` - pull/extract the artifact
- `init_start_service` - create and start the service

Benefits:
- Easier to pinpoint failures (tool installation vs. image pull vs. service start)
- Individual tasks can have appropriate, tighter timeouts
- Independent tasks on different machines can run in parallel
- Retries and debugging target the exact step that failed

### Task Design Pitfalls

- **Negative-condition verification tasks need a baseline.** If a verification task checks that something is NOT true (e.g., port unreachable), add an init task that first confirms the condition IS true. Otherwise the task auto-solves before the environment is ready.
- **Cross-machine `needs:` for init tasks should be explicitly defined.** Regular tasks automatically get the init tasks of the same machine added to the `needs:` list, but cross-machine dependencies must be defined explicitly.

- **Always use `-nT` flag with `ssh` when using it in a task.** This prevents the SSH process from hijacking the run script's standard input (which usually leads to extremely obscure failures). The only exception is when stdin is explicitly redirected for the SSH command (e.g., to provide a lengthy script to run or pipe the output of another command).

### Hint and Failure Checks

Verification tasks can include `hintcheck:` and `failcheck:` scripts that run when the task fails. These provide context-aware feedback to help the user understand what went wrong.

## labctl CLI

A local CLI called [`labctl`](https://github.com/iximiuz/labctl) is used to interact with the content and playgrounds. It is a thin wrapper around the [iximiuz Labs API](https://api.iximiuz.com).

**Always prefer using the provided skills over running labctl commands directly.** The skills encode the correct flags, sequencing, and conventions. The key workflows are:

### Content Management

- `create-content <kind> <name>` - scaffold new content locally and on the server
- `list-remote-content <kind>` - discover existing content on the server
- `pull-content-source <kind> <name>` - pull remote source files to the local project
- `push-content-source <kind> <name>` - push local source files to the server
- `edit-remote-content <kind> <name>` - push changed files (all or specific) to the server
- `detect-local-content-folder <kind> <name>` - resolve local folder path (used internally by other skills)

### Playground Management

- `list-available-playgrounds` - browse the playground catalog
- `start-playground <name>` - start a playground and get its ID
- `list-running-playgrounds` - list active playground sessions
- `stop-playground <id>` - stop a running playground
- `run-playground-command <id> [command]` - execute commands on a playground VM
- `ssh-into-playground <id>` - open an interactive SSH session (user-only)

### Challenge Lifecycle

- `start-challenge <name>` - start a challenge for testing
- `stop-challenge <name>` - stop a running challenge
- `debug-challenge <name>` - full debugging workflow: start, inspect tasks, troubleshoot, fix, push, and restart

### Task Inspection

- `list-playground-tasks <id>` - list all examiner tasks on a playground
- `get-playground-task <id> <task-name>` - get detailed task status and output
