---
title: How to Restrict Training Materials to Your Students

name: training-access-control
kind: unit
---

A **training** on iximiuz Labs is two things at once: a landing page that ties your materials together,
_and_ an access control mechanism. By enrolling in a training, a student is automatically granted a special
role - `student:<training-name>` - that you can use to gate access to your tutorials, challenges, courses,
and playgrounds. This page explains how to make materials available **only to your students**.

::remark-box
💡 This page assumes you're already familiar with the general
[content access control model](/docs/content-authoring/access-control) (the access dimensions and roles).
If not, start there and come back - the training workflow builds directly on top of it.
::


## Why Gate Materials Behind a Training?

You can already restrict content to a fixed set of named accounts using `github:<handle>` roles
(see [_Accessible to a limited set of named users_](/docs/content-authoring/access-control#common-access-recipes)).
That works well for a handful of people you know in advance, but it has two downsides:

- You must **collect every student's GitHub handle** before the training starts.
- You must **manually edit the access lists** of every piece of content whenever the roster changes.

A training removes both pains. Students enroll themselves via the training's landing page,
and the `student:<training-name>` role is granted (and revoked) automatically -
so you set the access list **once** and never touch it again as people come and go.


## How the `student:<training-name>` Role Works

The lifecycle is straightforward:

1. **You create a training** from the [instructor's dashboard](/instructor/dashboard).
   The training has a unique name (the last segment of its URL, e.g.
   `harbour-space-devops-2025-59cc8c6f` for `labs.iximiuz.com/trainings/harbour-space-devops-2025-59cc8c6f`).
2. **You share the training's landing page** with your (future) students.
3. **A student enrolls** from that page. Depending on your settings, enrollment may require your
   **approval** before it becomes active.
4. Once a student is enrolled (and approved, if required) **and** the training's access window is open,
   they hold the `student:<training-name>` role and can access any material that grants it.

::remark-box
---
kind: warning
---

⚠️ The `student:<training-name>` role is only active while the training itself is active.
If you've configured a start and/or end date, students gain access when the training **starts** and
lose it when it **ends** (unless you've explicitly allowed access after the end date).
::


## Making Materials Available Only to Students

For each piece of content you want to reserve for the training, open its access control dialog
(see [_Where to Configure Access_](/docs/content-authoring/access-control#where-to-configure-access)) and set the
relevant dimensions to `student:<training-name>`:

| Field        | Value                                            |
| ------------ | ------------------------------------------------ |
| `canList`    | `[owner]`                                        |
| `canRead`    | `[student:harbour-space-devops-2025-59cc8c6f]`   |
| `canStart`   | `[student:harbour-space-devops-2025-59cc8c6f]`   |

With this configuration:

- The material **stays out of all public catalogs** (`canList: [owner]`), so only people who reach it
  through your training program will find it.
- Only **enrolled students** can read it and start its playground. Everyone else - including logged-in
  users who simply have the link - is denied.

Repeat this for every tutorial, challenge, course, skill path, and playground that should be part of the training.

::remark-box
💡 Remember that a content's **playground** has its own access control. If you reserve a tutorial for
`student:<training-name>`, make sure its playground grants `canStart` to the same role - otherwise students
will be able to read the tutorial but not start it. See the
[note on playgrounds](/docs/content-authoring/access-control#the-access-dimensions) in the content access guide.
::


## Other Ways to Restrict Access

Gating behind a training is the most flexible option, but it isn't the only one.
Depending on your needs, you might prefer one of the lighter-weight recipes from the
[content access control guide](/docs/content-authoring/access-control#common-access-recipes):

- **Public but not listed** - anyone with the link can use the materials, but they never appear in a catalog.
  The simplest option when you don't need to restrict _who_ can access, only to keep things out of listings.
- **A limited set of named users** - grant `github:<handle>` to a known, fixed group of accounts.
- **Any logged-in user** - grant `authenticated` to allow every iximiuz Labs account but no anonymous visitors.
