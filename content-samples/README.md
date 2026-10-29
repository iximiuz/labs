# iximiuz Labs Content Samples

A collection of self-documenting sample tutorials, challenges, skill paths and other forms of iximiuz Labs content:

- [Tutorial](/content-samples/sample-tutorial) - [labs.iximiuz.com/tutorial/sample-tutorial](https://labs.iximiuz.com/tutorials/sample-tutorial)
- [Challenge](/content-samples/sample-challenge) - [labs.iximiuz.com/challenge/sample-challenge](https://labs.iximiuz.com/challenges/sample-challenge)
- [Skill Path](/content-samples/sample-skill-path) - [labs.iximiuz.com/skill-path/sample-skill-path](https://labs.iximiuz.com/skill-paths/sample-skill-path)

## Skills and Rules for AI Agents

Authoring with an AI agent? Run `labctl skills install` in the root of your content collection (the folder with the `challenges/`, `tutorials/`, `courses/`, `skill-paths/`, and `shell-gyms/` subfolders).
It installs the content authoring rules and the skills to use `labctl`, which, together with the samples above, make Claude Code, Codex, or a similar CLI agent a way more efficient partner.

```sh
labctl skills install --agent claude
```

The skills teach the agent the `labctl` workflows: creating, pulling, and pushing content, starting and destroying playgrounds, inspecting their tasks, debugging challenges and Shell Gyms, and reviewing challenges and Shell Gyms before publication. The rules cover the content formats, the authoring conventions, and the style guides.

Other useful commands:

```sh
labctl skills list                          # available skills and rules and their install status
labctl skills show labs-content             # print a skill or a rule
labctl skills install playgrounds --user    # only the playground skills, for all your projects
labctl skills uninstall --agent codex       # remove the skills for one agent
labctl skills uninstall                     # remove everything labctl installed
```

The source of the skills and rules is in the [labctl repository](https://github.com/iximiuz/labctl/tree/main/skills).
