---
title: How to Control Access to Your Content

name: access-control
kind: unit
---

An important part of publishing on iximiuz Labs is deciding **who can see and use your materials**.
This page is a practical guide to configuring access control (RBAC) for the content you create.

Every piece of content you author - a [tutorial](/docs/learning-materials/tutorials), [challenge](/docs/learning-materials/challenges),
[course](/docs/learning-materials/courses), [skill path](/docs/learning-materials/skill-paths), [roadmap](/docs/learning-materials/roadmaps), or [playground](/docs/playgrounds) -
is governed by the same access control model. However, the particular actions on content vary from one type to another.

::remark-box
💡 This page focuses on individual content access. If you want to gate materials behind a
**training** (so that only your enrolled students can use them), see the dedicated guide on
[access control for instructor-led training](/docs/instructor-led-training/access-control).
::


## The Access Dimensions

Access to a piece of content is controlled along several independent _dimensions_.
Each dimension is a list of [roles](#the-roles) that are allowed to perform the corresponding action:

| Field             | Controls                                                                 | Applies to |
| ----------------- | ------------------------------------------------------------------------ | ---------- |
| `canList`         | Whether the content is allowed to appear in the public [catalogs](/tutorials) and other listings | all kinds  |
| `canPreview`      | Who can see a limited _preview_ (e.g., the intro) without full access    | tutorials, skill paths |
| `canRead`         | Who can read the full content body                                       | all kinds  |
| `canStart`        | Who can start the accompanying playground (and mark the content complete) | all kinds  |
| `canReadSolution` | Who can read the challenge's solution                                    | challenges |

Because the dimensions are independent, you can mix and match them.
For example, you can let _anyone_ read a tutorial (`canRead: [anyone]`) while keeping it out of the catalogs
(`canList: [owner]`), or let _anyone_ read the description of a challenge (`canRead: [anyone]`)
but reserve the solution for a narrower audience (`canReadSolution: [...]`).

::remark-box
---
kind: warning
---

⚠️ **A content's playground is subject to its own access control.**
Make sure the playground you attach is at least as permissive as the content itself -
otherwise users who can _read_ the content won't be able to _start_ it.
::


## The Roles

A role is just a string you put into one of the access dimensions.
The most useful roles for content authors are:

| Role                     | Who it grants access to                                                            |
| ------------------------ | ---------------------------------------------------------------------------------- |
| `owner`                  | Only you, the author. This is the **default** for every dimension of new content.  |
| `anyone`                 | Everyone, including anonymous (non-logged-in) visitors, bots, and crawlers.        |
| `authenticated`          | Any logged-in iximiuz Labs user (but not anonymous visitors).                      |
| `github:<handle>`        | A specific GitHub account, identified by its login handle (e.g., `github:octocat`). |
| `student:<training-name>` | Everyone enrolled (and, optionally, approved) in the named training.               |

::details-box
---
:summary: A few more roles you'll rarely need
---

- `user:<userId>` - a single iximiuz Labs user identified by their internal user ID.
  In practice, `github:<handle>` is far more convenient for sharing with named people.
- `has-pack:<packName>` - users who own a particular content pack (primarily used by independent authors to monetize their content)
- `instructor` - the instructors of the trainings this content is attached to.
- `nobody` - an explicit "deny everyone" that overrides every other rule (including the owner's
  and even a superadmin's). Use only when you really want to fully lock a dimension.

::

You can list several roles in a single dimension - access is granted if the requester matches **any** of them.
For example, `canRead: [github:alice, github:bob]` grants read access to both Alice and Bob.


## Where to Configure Access

Access control is configured from the content's menu (no front matter or `labctl` changes required).
For a tutorial, open the access control settings as shown in the
[Sample Tutorial](/tutorials/sample-tutorial#how-to-control-tutorial-access), which walks through the same dialog with a screenshot.

The same dialog exists for challenges, courses, skill paths, roadmaps, and playgrounds.
Every piece of content starts as a **private draft** - all dimensions default to `[owner]`,
so only you can see it until you decide to share.


## Common Access Recipes

Below are the most frequently used configurations. Adjust the role lists to taste.

### Private (the default)

Only you can see and use the content. Nothing to do - this is how every draft starts.

| Field        | Value     |
| ------------ | --------- |
| `canList`    | `[owner]` |
| `canPreview` | `[owner]` |
| `canRead`    | `[owner]` |
| `canStart`   | `[owner]` |

### Public and listed

Anyone can find, read, and start the content, and you're signalling that you'd like it featured in a catalog.

| Field        | Value      |
| ------------ | ---------- |
| `canList`    | `[anyone]` |
| `canPreview` | `[anyone]` |
| `canRead`    | `[anyone]` |
| `canStart`   | `[anyone]` |

::remark-box
---
kind: warning
---

Setting `canList` to `[anyone]` is only an **indicator of your willingness** to have the content listed.
The iximiuz Labs team curates which content actually appears in the main catalogs like [Tutorials](/tutorials), [Challenges](/challenges), [Courses](/courses), [Skill Paths](/skill-paths), and [Roadmaps](/roadmaps).

Also note that **non-English materials are not listed in the main catalogs (yet)**,
even if you're an English speaker publishing in another language. They still work perfectly via a direct link.
::

### Public but not listed ("unlisted")

Anyone who has the link can read and start the content, but it never appears in any catalog or listing.
This is the easiest way to share broadly without cluttering the public catalogs - perfect, for example,
for materials you only want to hand out to a specific audience by sharing the URL.

| Field        | Value      |
| ------------ | ---------- |
| `canList`    | `[owner]`  |
| `canPreview` | `[anyone]` |
| `canRead`    | `[anyone]` |
| `canStart`   | `[anyone]` |

### Accessible to a limited set of named users

When you know exactly who should have access, list them by their GitHub handles.
Only those accounts (once logged in via GitHub) will be able to read and start the content,
and it stays out of all listings.

| Field        | Value                                  |
| ------------ | -------------------------------------- |
| `canList`    | `[owner]`                              |
| `canRead`    | `[github:alice, github:bob, github:carol]` |
| `canStart`   | `[github:alice, github:bob, github:carol]` |

This is great for a small, fixed group, but it does require you to **collect everyone's GitHub handle**
in advance and to update the list whenever the group changes.

### Any logged-in user

Hide the content from anonymous visitors but allow every authenticated iximiuz Labs user.

| Field        | Value             |
| ------------ | ----------------- |
| `canList`    | `[owner]`         |
| `canRead`    | `[authenticated]` |
| `canStart`   | `[authenticated]` |

### Accessible only to training students

When you don't want to maintain a list of individual accounts, gate the content behind a **training** instead.
Set the relevant dimensions to `student:<training-name>`, and access is granted automatically to everyone
who enrolls in (and is optionally approved for) that training.

| Field        | Value                          |
| ------------ | ------------------------------ |
| `canList`    | `[owner]`                      |
| `canRead`    | `[student:my-awesome-course-2026]` |
| `canStart`   | `[student:my-awesome-course-2026]` |

This is the most powerful and flexible option, since enrollment (and revocation) is managed for you.
It's covered in detail in the [instructor-led training access guide](/docs/instructor-led-training/access-control).


## A Note on Unprotected Static Assets

Access control protects the content **body**, but the files in a content's `__static__` folder are served
via a CDN and are **not** subject to authorization checks. With some URL guessing they can be fetched by
anyone, including anonymous users and crawlers.

::remark-box
---
kind: error
---

⚠️ Do not put sensitive or student-only files in `__static__`. Keep private materials out of that folder.
See [_WARNING - UNPROTECTED ASSETS_](/tutorials/sample-tutorial#content-folder-structure) in the Sample Tutorial for details.
::
