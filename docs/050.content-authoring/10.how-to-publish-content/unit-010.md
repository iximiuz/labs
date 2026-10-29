---
title: How to Publish Content on iximiuz Labs

name: how-to-publish-content
kind: unit
---

::remark-box
More detailed docs are coming soon...
::

## Who can publish content on iximiuz Labs?

[Anyone with a Premium or Tinkerer account can create content on iximiuz Labs](/for-creators).
This includes:

- [Challenges](/new/challenge)
- [Tutorials](/new/tutorial)
- [Courses](/new/course)
- [Skill Paths](/new/skill-path)
- [Playgrounds](/new/playground)

Once created, the content can be shared either publicly or with a limited set of users via [access control settings](/docs/content-authoring/access-control).

::remark-box
---
kind: warning
---
While publication via a direct link is always possible,
the iximiuz Labs team reserves the right to choose which content will be listed in the Community and Independent Authors catalogs.

**Setting `canList` to `["anyone"]` is treated only as an indicator of the author's willingness to list the content in one of the platform's catalogs.**
::

## How to monetize content published on iximiuz Labs?

[Content monetization](/author/dashboard#monetization) is supported via the **Independent Authors** program.
To qualify, you need to publish at least 3 content items as a Community Author that pass a quality review by the iximiuz Labs team.

## How to get started authoring content on iximiuz Labs?

Check out the following resources for more information:

- [Sample Tutorial](/tutorials/sample-tutorial) - a self-documenting sample tutorial
- [Sample Challenge](/challenges/sample-challenge) - a self-documenting sample challenge
- [Sample Skill Path](/skill-paths/sample-skill-path) - a self-documenting sample skill path
- [iximiuz Labs Content Samples (Markdown + YAML)](https://github.com/iximiuz/labs/tree/main/content-samples)

## How to author content with an AI agent?

[`labctl`](https://github.com/iximiuz/labctl) ships skills and rules that teach AI agents
the content formats, the authoring conventions, and the `labctl` workflows for creating, pushing, and testing content on real playgrounds.
Install them in the root of your content repository (the folder with the `challenges/`, `tutorials/`, `courses/`, `skill-paths/`, and `shell-gyms/` subfolders)
for the agents you use - Claude Code, Codex, Cursor, GitHub Copilot, OpenCode, Gemini CLI, Antigravity, Devin, Warp, or Zed:

```sh
labctl skills install --agent claude
```

Then ask the agent to, for example, create a challenge on a topic of your choice and test it on a playground.

::remark-box
---
kind: tip
---
Before submitting a challenge or a Shell Gym, ask the agent to review it.
::
