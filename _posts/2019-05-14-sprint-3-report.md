---
layout:     post
title:      Hercules CI &#35;3 development update
date:       2019-05-14
summary:    Precise derivations and new agent release
image:      dependency-failure-tree.png
author:     domenkozar
categories: sprints, hercules-ci
---

# What's new in sprint #3?

## Precise derivations improvements

![Dependency failure tree](/images/dependency-failure-tree.png)

If a **dependency failed for an attribute**, you can now explore the
dependency stack until the actual build failure.

There's also a **rebuild button** to re-retry build for whole stack.
We've addressed some of the styling issues visible on smaller screens.

## Fixed an issue where users would [end up being logged out](https://github.com/hercules-ci/support/issues/13)

## [hercules-ci-agent 0.2](https://github.com/hercules-ci/hercules-ci-agent/releases/tag/hercules-ci-agent-0.2)

- use [gitignore] instead of [nix-gitignore]
- fix build on Darwin
- limit internal concurrency to max eight OS threads for beefier machines
- show version on `--help`
- build against NixOS 19.03 as default
- propagate agent information to agent view: Nix version, substituters,
  platform and Nix features

[nix-gitignore]: https://github.com/siers/nix-gitignore
[gitignore]: https://github.com/hercules-ci/gitignore

# Focus for sprint #3

## Cachix and thus Darwin support

Last bits missing (besides testing) is sharing derivations and artifacts between agents using
[cachix](https://github.com/hercules-ci/hercules-ci-agent/pull/52) and the ease of
Darwin agent deployment with accompanying documentation.

## Stuck jobs when restarting the agent

Currently jobs claimed by agent that don't finish while agent is being restarted
will appear stuck in queue. This sprint is [planned](https://github.com/hercules-ci/support/issues/19)
to ship a way to remedy the issue manually via UI, later on it will be automatically
handled by agent ping-alive.

# Preview phase

Once we're done with Darwin and Cachix support we'll hand out preview access
to everyone that will [sign up for preview access](https://hercules-ci.com) until then.

You can also [receive latest updates via Twitter](https://twitter.com/hercules_ci) or
read [previous development update](https://blog.hercules-ci.com/sprints,/hercules-ci/2019/04/30/sprint-2-report/).
