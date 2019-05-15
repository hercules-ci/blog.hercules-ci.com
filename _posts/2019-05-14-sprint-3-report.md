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

There's also a **rebuild button** to retry the build for the whole stack, from the failed dependency down up to and including the build you clicked.
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

The last bits missing (besides testing) are sharing derivations and artifacts between agents using
[cachix](https://github.com/hercules-ci/hercules-ci-agent/pull/52) and the ease of
Darwin agent deployment with accompanying documentation.

## Stuck jobs when restarting the agent

Currently when you restart an agent that is doing work, jobs claimed by the agent
will appear stuck in the queue. This sprint is [planned](https://github.com/hercules-ci/support/issues/19)
to ship a way to remedy the issue manually via the UI. Later on it will be automatically
handled by agent ping-alive.

# Preview phase

Once we're done with Darwin and Cachix support, we'll hand out preview access
to everyone who will have [signed up for preview access](https://hercules-ci.com).

You can also [receive our latest updates via Twitter](https://twitter.com/hercules_ci) or
read [the previous development update](https://blog.hercules-ci.com/sprints,/hercules-ci/2019/04/30/sprint-2-report/).
