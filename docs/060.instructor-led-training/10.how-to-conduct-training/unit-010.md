---
title: How to Conduct Training on iximiuz Labs

name: how-to-conduct-training
kind: unit
---

iximiuz Labs can host your instructor-led training sessions - university classes, corporate workshops,
conference trainings, bootcamps, and the like. The central concept is a **Training**:
an entity you create from the [instructor's dashboard](/instructor/dashboard) that gives your students
a single URL to enroll through, and gives you a roster with per-student progress tracking.

::remark-box
💡 To create trainings, upgrade your account to the [Tinkerer tier](/pricing/tinkerer)
(the historical Premium plan works, too) and head to the [instructor's dashboard](/instructor/dashboard).
::


## What a Training Actually Is

A training serves up to **three purposes** at once:

1. **A front page with an Enroll button** _(mandatory)_ - a landing page you share with your (future) students,
   e.g., [labs.iximiuz.com/trainings/harbour-space-devops-2025-59cc8c6f](https://labs.iximiuz.com/trainings/harbour-space-devops-2025-59cc8c6f).
   Every training has one - it's how students join.
2. **A program** _(optional)_ - a structured list of learning materials for students to work through,
   visually similar to a [Skill Path](/docs/learning-materials/skill-paths)
   ([format example](https://labs.iximiuz.com/skill-paths/docker-101-run-and-manage-containers#introduction)).
3. **An access control mechanism** _(optional)_ - every enrolled student is automatically granted the
   `student:<training-name>` role, which you can use to gate access to your tutorials, challenges,
   courses, and playgrounds. See [How to Restrict Training Materials to Your Students](/docs/instructor-led-training/training-access-control).

::highlight
I.e., a training is both a "container" for the content and an access control means.
::

The typical workflow looks like this:

1. Create a training in the [instructor's dashboard](/instructor/dashboard) and fill in its front page.
2. Optionally, add a training program.
3. Configure the training's access control (see [below](#training-access-control-rbac)) and other settings:
   start/end dates, whether enrollment requires your approval, whether students keep access after the end date,
   and whether to grant students [premium seats](#training-participation-is-free-premium-seats-are-optional) on enrollment.
4. Share the training's front page URL with the students so they can enroll.
5. Watch the enrolled students show up in your dashboard, where you can track their progress
   (which tutorials, challenges, and courses they started, which tasks they passed, etc.).


## Editing a Training Is Two-Fold

A training is configured in two different places, depending on what exactly you're changing:

- **Key attributes** - the RBAC settings, start/end dates, whether to grant students premium seats
  on enrollment, and the like - are configured on the training's **settings page** in the
  [instructor's dashboard](/instructor/dashboard).
- **The front page info** (title, short description, long markdown description) and the
  **training program** (the `program.md` and `unit-<N>.md` files) are edited the same way
  [any other content on iximiuz Labs is edited](/tutorials/sample-tutorial#how-to-edit-the-tutorial) -
  locally, in your favorite editor, using the [`labctl`](https://github.com/iximiuz/labctl) CLI:

```sh
labctl content pull training <training-name>
# ...edit the files locally...
labctl content push training <training-name>
```


## Training Participation Is Free (Premium Seats Are Optional)

Enrolling in and participating in a training is **free** for students - the only requirement is to be
signed in on the site. Unlike the instructor, who must always have an upgraded membership
([Tinkerer](/pricing/tinkerer) or the historical Premium plan), students can be on the free tier.

That said, free-tier accounts are subject to the platform's usage limits, which can get in the way
during an intensive hands-on session. It is therefore **recommended to purchase premium seats** for
your students for the duration of the training (from the [Seats section of the instructor's dashboard](/instructor/dashboard#seats))
and configure the training to **grant them automatically on enrollment**. This way, students won't be
impacted by the free-tier limits while the training lasts.


## Trainings With and Without a Program

The program is optional, and both flavors are useful in practice.

### Program-less trainings

A training **without a program** is the simplest option. Its only job is to get a group of students
enrolled - giving you a roster with progress tracking and, if you've purchased
[premium seats](#training-participation-is-free-premium-seats-are-optional) and enabled the automatic
grant, upgrading every student **for the duration of the training** so they can use the platform without
limits, including the playgrounds you've prepared for the workshop. This is a great fit when you deliver
the actual course material elsewhere (slides, a live session, your own website) and only need iximiuz Labs
as the hands-on environment.

### Trainings with a program

A training **with a program** additionally presents students with a training-shaped learning path -
a curated, ordered list of arbitrary learning materials: tutorials, challenges, courses, and more.
The idea and the format are similar to [Skill Paths](/docs/learning-materials/skill-paths),
but the list lives inside your training and can be gated so that only your students see it.


## Training Access Control (RBAC)

Like every other entity on iximiuz Labs, a training is governed by [role-based access control](/docs/content-authoring/access-control).
However, the set of access dimensions is training-specific:

| Field               | Controls                                                                  |
| ------------------- | ------------------------------------------------------------------------- |
| `canList`           | Whether the training may appear in listings. Currently, trainings aren't listed anywhere, so this dimension has no visible effect (yet). |
| `canRead`           | Who can see the training's **front page**.                                |
| `canEnroll`         | Who can **enroll** in the training.                                       |
| `canReadProgram`    | Who can read the **full program**.                                        |
| `canPreviewProgram` | Who can see a **preview of the program** - only its first unit (useful for marketing). |

::remark-box
---
kind: warning
---

⚠️ **Keep `canRead` and `canEnroll` set to `anyone`.** The whole point of the front page is that
anyone with the link can open it and enroll - if you lock these dimensions down, your students
won't be able to join the training.
::

The interesting decisions are all about the program dimensions:

- `canReadProgram: [anyone]` - everyone can read the training's program (but not necessarily the linked materials - see [below](#trainings-rbac-vs-the-materials-own-rbac)).
- `canReadProgram: [student:<training-name>]` - only enrolled students can read the program.
- `canReadProgram: [nobody]` - for program-less trainings (i.e., when no `program.md` file exists), there is nothing to show anyway.

`canPreviewProgram` follows the same logic but applies to the trimmed, first-unit-only view of the program.
A typical trick is to keep the full program students-only while making the preview public,
so that prospective students can get a taste of what's inside before enrolling.


## Common Training RBAC Recipes

### Program-less training (premium seats only)

You only need the enrollment flow: students join, get their premium seats, and work with the platform directly.

| Field               | Value      |
| ------------------- | ---------- |
| `canList`           | `[anyone]` |
| `canRead`           | `[anyone]` |
| `canEnroll`         | `[anyone]` |
| `canReadProgram`    | `[nobody]` |
| `canPreviewProgram` | `[nobody]` |

### Training with a public program

Anyone with the link can see both the front page and the full program - handy when the program itself
is your marketing, or when the training is run in an open community.

| Field               | Value      |
| ------------------- | ---------- |
| `canList`           | `[anyone]` |
| `canRead`           | `[anyone]` |
| `canEnroll`         | `[anyone]` |
| `canReadProgram`    | `[anyone]` |
| `canPreviewProgram` | `[anyone]` |

### Training with a students-only program (public preview)

The most common "paid workshop" setup: everyone can see the front page and the first unit of the program
(to understand what they're signing up for), but the full program is reserved for enrolled students.

| Field               | Value                              |
| ------------------- | ---------------------------------- |
| `canList`           | `[anyone]`                         |
| `canRead`           | `[anyone]`                         |
| `canEnroll`         | `[anyone]`                         |
| `canReadProgram`    | `[student:<training-name>]`        |
| `canPreviewProgram` | `[anyone]`                         |

### Training with a fully private program

Like the above, but even the preview is hidden from non-students.

| Field               | Value                              |
| ------------------- | ---------------------------------- |
| `canList`           | `[anyone]`                         |
| `canRead`           | `[anyone]`                         |
| `canEnroll`         | `[anyone]`                         |
| `canReadProgram`    | `[student:<training-name>]`        |
| `canPreviewProgram` | `[student:<training-name>]`        |


## Training's RBAC vs. the Materials' Own RBAC

An important subtlety: the training's access dimensions control **only the training itself** -
its front page and its program listing. Every tutorial, challenge, course, and playground linked
from the program is still governed by **its own access control**, and putting a material into a
program neither loosens nor tightens who can open it.

In other words, `canReadProgram` decides who can see the _table of contents_,
while each material's own `canRead`/`canStart` decide who can actually _use_ it. Two consistent setups:

- **Public materials** - the linked materials are public (or at least
  [unlisted](/docs/content-authoring/access-control#public-but-not-listed-unlisted)), and the training's
  program is just a convenient map over them. Nothing extra to configure.
- **Students-only materials** - each linked material grants `canRead`/`canStart` to
  `student:<training-name>`, so only enrolled students can use them. This has to be configured
  **on every material separately** - see
  [How to Restrict Training Materials to Your Students](/docs/instructor-led-training/training-access-control)
  for the step-by-step guide.

::remark-box
---
kind: warning
---

⚠️ Remember that a content's **playground** has its own access control, too. If you reserve a tutorial
for `student:<training-name>` but forget to grant the same role in the playground's `canStart`,
students will be able to read the tutorial but not start it.
::
