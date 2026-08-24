---
title: Learning and Account Tools

name: learning-and-account-tools
kind: unit
---

## Learning

The tools behind the [personalized tutor](/docs/labs-mcp/what-is-labs-mcp#four-reasons) use case:
coaching you through content and tracking your progress.

**Read** (`learning:read`):

| Tool | What it does |
| --- | --- |
| `assist_with_content` | Coach you through a running challenge or lesson - checks your tasks, explains the next step, spoiler-free. |

**Write** (`learning:write`):

| Tool | What it does |
| --- | --- |
| `start_content` | Start a challenge, tutorial, course lesson, skill path, or roadmap for you. |
| `complete_content` | Mark a tutorial, lesson, skill path, or roadmap complete (challenges are excluded - their completion is verified server-side). |

::remark-box
Challenge completion is recorded server-side and is authoritative:
your assistant can check whether a task actually flipped to *solved* (via `get_play_tasks`),
but it cannot declare a challenge done on its own say-so.
::

```
› Start the 'Set Up NAT for a Container' challenge.

› I'm on task 2 of the NAT challenge and iptables looks right to me - what am I missing?
```

## Account

Your profile, streaks, daily practice, and email settings.

**Read** (`account:read`):

| Tool | What it does |
| --- | --- |
| `get_my_profile` | Your plan, join date, lifetime stats, GitHub identity, and notification settings. |
| `get_my_progress` | Your learning activity - active days and streaks. |
| `get_daily_practice` | Today's daily-practice challenge suggestions and whether each is solved. |

**Write** (`account:write`):

| Tool | What it does |
| --- | --- |
| `manage_daily_practice` | Enable, disable, or reshuffle your daily practice. |
| `manage_notifications` | Toggle newsletter and digest emails and their cadence. |

```
› Did I keep my streak alive this week?

› Today's challenge is too hard - reshuffle my daily practice.
```
