---
layout:     post
title:      Sprint &#35;2 development update
date:       2019-04-30
summary:    Hercules CI development progress report
categories: sprints, hercules-ci
---

# What's new in sprint #2?

## Precise derivations

Agent 0.2 will communicate the whole derivation tree to our service,
which allows us to traverse the derivation tree and dispatch each derivation to multiple agents.

Neither source or binary data used by Nix on the agent is ever sent to
the service.

Note that we haven't **yet** released [agent 0.2](https://github.com/hercules-ci/hercules-ci-agent/releases)
as we're still doing testing and UI improvements.

## Git-rich metadata

Each job now includesa a branch name, commit message and the committer:

![Job rich metadata](/images/sprint_2_git_rich.png)

## Job page information

The job page shows information that triggered the build and timing information:

![Job page](/images/sprint_2_job.png)

# Focus for sprint #3

## Cachix support

We've already made progress of parsing Cachix configuration, but
there's the actual pushing of derivations to be done.

## Darwin / Features support

Now that precise derivations are working, they need to get aware of platforms for Darwin support.
Same goes for infamous Nix "features" that allow per-derivation granuality of dispatching
derivations to a specific group of agents.

# Preview phase

You're still in time to [sign up for preview access](https://hercules-ci.com) or follow us on 
[Twitter](https://twitter.com/hercules_ci) as we will be expanding access in the following weeks.


