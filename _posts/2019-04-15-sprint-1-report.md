---
layout:     post
title:      Sprint &#35;1 development update
date:       2019-04-12
summary:    Hercules CI development progress report
categories: sprints, hercules-ci
---

Two weeks ago we launched preview access of [our CI](https://hercules-ci.com) for the [Nix](https://nixos.org/nix/) ecosystem.
Thank you all for giving us the feedback through the poll and individually.
We are overwhelmed with the support we got.

Focus of the preview launch was to build a fast, reliable, easy to use CI.
Today you can connect your github repository in a few clicks, deploy an agent and all your commits
are being tested with their status reported to GitHub.

In our latest sprint we have fixed a few issues, mainly centered around usability and clarity
of what's going on with your projects.

The following features were shipped:

- [The status page](https://status.hercules-ci.com)
  for insight into the availability of the service

- Agent support for [building `nix/ci.nix`, `ci.nix` or `default.nix`](https://github.com/hercules-ci/hercules-ci-agent/pull/36)
  from your repository

- Agent support for [reporting non-attribute evaluation errors](https://github.com/hercules-ci/hercules-ci-agent/pull/37)

- [Documentation](https://docs.hercules-ci.com) about
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

In our upcoming spring, #2 we will focus on:

- Fine-grained dispatch of individual derivations (instead of just top-level derivation closures from
  attributes as we shipped in the preview) - what follows is testing and
  presenting derivations in the UI

- Currently we only store the git revision for each job, which will be expanded to include more metadata like
  branch name, commit message, author, etc

- If time allows, preliminary [cachix support](https://github.com/hercules-ci/support/issues/2)

You're still in time to [sign up for preview access](https://hercules-ci.com) as we
will be expanding access in the following weeks.
