---
layout:     post
title:      Sprint &#35;1 development update
date:       2019-04-12
summary:    Hercules CI development progress report
categories: sprints, hercules-ci
---

Two weeks ago we launched preview access of [our CI](https://hercules-ci.com) for the [Nix](https://nixos.org/nix/) ecosystem.
Thank you all for giving us the feedback through the poll and individually,
we are overwhelmed with the support we got.

Focus of the preview launch was to build a fast, reliable, easy to use CI.
Today you can connect your github repository in a few clicks, deploy an agent and all your commits
are being tested with their status reported to GitHub.

In the last sprint we fixed a few issues, mainly focusing on usability and clarity
of what's going on with your projects.

The following features were shipped:

- [Status page](https://status.hercules-ci.com)
  for insight into the CI availability

- Agent support for [building `nix/ci.nix`, `ci.nix` or `default.nix`](https://github.com/hercules-ci/hercules-ci-agent/pull/36)
  from your repository

- Agent support for [reporting non-attribute evaluation errors](https://github.com/hercules-ci/hercules-ci-agent/pull/37)

- [Documentation](https://docs.hercules-ci.com) has gotten a new section on
  how evaluation is performed

The following bugs fixes were shipped:

- When there is no agent available, enqueued jobs will show instructions to setup one

- To prevent CSRF we've tightened `SameSite` cookie from `Lax` to `Strict`

- [CDN used to serve stale assets due to caching misconfiguration](https://github.com/hercules-ci/support/issues/11)

- Numerous fixes to the UI:
  * breadcrumbs now allow user to switch account or just navigate to it
  * no more flickering when switching pages
  * some jobs used to be stuck in Building phase
  * more minor improvements

In #2 sprint the plan is to focus on:

- We have preliminary support to dispatch derivations (instead of just top-level
  attributes as we shipped in the preview) - what follows is testing and
  presenting derivations in the UI

- Currently we only store git revision, expand commit metadata to include
  branch name, commit message, author, etc

- If time persists, preliminary [cachix support](https://github.com/hercules-ci/support/issues/2)

It's not too late to [sign up for preview access](https://hercules-ci.com) as we
will be expanding access in the following weeks.
