---
title: A playground run is gone
name: gone
kind: unit
---

Symptoms: the play page says "It's gone...", or the play simply isn't in `labctl playground list` anymore.

1. `labctl playground list -a` lists all your recent plays including the stopped and the recently terminated ones - find the play by its ID or title,
   and look at the `CREATED` and `STATUS` columns. `labctl playground status <play-id>` works for a gone play too and adds the page URL.
2. Compare the play's age with its limits. Ephemeral plays are destroyed when their lifetime runs out or after being idle for too long
   (both limits are in the Play Spec - `maxPlayTime`/`expiresIn` and `maxIdleTime` - and depend on the playground and your tier);
   persistent plays are stopped instead. A play that is much younger than its lifetime didn't expire - it failed.
3. Open the play page (`/playgrounds/<playground-name>/<play-id>`, or the `Page URL` from `labctl playground status`): the "It's gone..." page shows the Play Debug Console,
   and the `stateEvents` and the **Boot Logs** are the post-mortem - "The play failed while running" means the platform lost the machines mid-flight
   (the serial console of the machine usually shows why), "The play failed to start" sends you back to the [boot scenario](/docs/debugging-playgrounds/debugging-scenarios#not-booting).
   The boot logs stay readable for a while after the play is gone, from the UI and via `labctl playground machine console`.

To not lose work in the future, make the play persistent (`labctl playground persist <play-id>`, or the persistence toggle in the play page header) -
a persistent play is stopped rather than destroyed when its time is up, and can be [restarted later](/docs/playgrounds/persistent-playgrounds).
