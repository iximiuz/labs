---
title: How to Conduct Training on iximiuz Labs

name: how-to-conduct-training
kind: unit
---

A proper documentation is coming soon, but here is the top-level idea:

- An instructor upgrades their own account to the [Tinkerer tier](/pricing/tinkerer) (the historical Premium plan will work, too) and goes to the [instructor's dashboard](/instructor/dashboard).
- In the dashboard, the instructor creates a Training - which is basically just a landing page (e.g., [labs.iximiuz.com/trainings/harbour-space-devops-2025-59cc8c6f](https://labs.iximiuz.com/trainings/harbour-space-devops-2025-59cc8c6f)).
- Optionally, the instructor can also fill in the training program - which visually looks like a skill path ([format example](https://labs.iximiuz.com/skill-paths/docker-101-run-and-manage-containers#introduction)).
- Then the instructor configures the RBAC and the training duration and sends its landing page to the (future) students so that they can enrol.
- Once enrolled, students show up in the instructor's dashboard where the instructor can see their progress (what tutorials, challenges, courses started, which tasks passed, etc.).
- The fact of training enrolment assigns a special role to each enrolled user `student:<training-name>`,
which then can be used in instructor's "private" learning materials (like in the above Harbour Space university example -
it's possible to see the training's landing page but not its program and the linked materials).

::highlight
I.e., a training serves as both a "container" for the content and an access control means.
::