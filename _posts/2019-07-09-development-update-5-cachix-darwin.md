---
layout:     post
title:      Hercules CI &#35;5 update requiredSystemFeatures, Cachix and Darwin support
date:       2019-07-09
summary:    Cachix and Darwin
image:      
author:     domenkozar
categories: sprints, hercules-ci
---

# What's new?

We've released [hercules-ci-agent 0.3](https://github.com/hercules-ci/hercules-ci-agent/blob/master/hercules-ci-agent/CHANGELOG.md#030---2019-07-05)
, which brings in [Cachix](http://cachix.org/) and Darwin (macOS) support alongside with
[requiredSystemFeatures]((https://nixos.org/nix/manual/#conf-system-features)).

## hercules-agent-0.3.0

### TOML configuration

Previously agent was configured via CLI options. Those are now all part of [configuration file formatted using TOML](https://docs.hercules-ci.com/#agent-configuration-file).

### Support for binary caches

[Added support for Cachix](https://docs.hercules-ci.com/#binarycachespath) binary caches
to share resulting binaries either with the public and/or between developers and/or just multiple agents.

### Multi-agent and Darwin support

With binary caches to share derivations and binaries between machines,
you're now able to have N agents running.

Sharing binaries between machines takes time (bandwidth) so we
recommend upgrading agent hardware over adding more agents.

In addition to Linux, Darwin (macOS) also became a supported deployment platform for the agent.

### `requiredSystemFeatures` support

Derivations are now dispatched also based on [requiredSystemFeatures derivation attribute](https://nixos.org/nix/manual/#conf-system-features)
that allows dispatching specific derivations to specific agents.

## Cachix 0.2.1

Upgrade via the usual:

    $ nix-env -iA cachix -f https://cachix.org/api/v1/install  

Most notable improvement is default compression has been lowered to increase bandwidth throughput and it's overridable via ``--compression-level`.

See [Changelog](https://github.com/cachix/cachix/blob/master/cachix/CHANGELOG.md#021---2019-07-05) for more details.

# What's next?

Known issues we're resolving:

- Builds that are in-progress while agent is restarted won't be re-queued. We're prioritizing this one, expect a bugfix in next deployment.
- Evaluation and building is slower with Cachix, we're going to add [bulk query support](https://github.com/cachix/cachix/issues/201) 
  and [upstream caches](https://github.com/cachix/cachix/issues/16) to mitigate that.
- Having a lot of failed derivations (>10k) will get frontend unresponsive.
- Cachix auth tokens for private binary caches are personal. We'll add support to create tokens specific to a cache.

If you notice any other bugs or annoyances please [let us know](help@hercules-ci.com).

# Preview phase

Preview phase will now extend to all subscribers, which is the final phase before we're launching publicly.

You can also [receive our latest updates via Twitter](https://twitter.com/hercules_ci) or
read [the previous development update](https://blog.hercules-ci.com/sprints,/hercules-ci/2019/05/14/sprint-3-report/).
