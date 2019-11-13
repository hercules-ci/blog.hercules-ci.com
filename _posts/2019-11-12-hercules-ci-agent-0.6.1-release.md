---
layout:     post
title:      Hercules CI Agent 0.6.1
date:       2019-11-12
summary:    Performance improvements, a bugfix to IFD and better onboarding experience.
image:      
author:     domenkozar
tags:       nix hercules-ci
---

We've released [hercules-ci-agent 0.6.1](https://github.com/hercules-ci/hercules-ci-agent/releases/tag/hercules-ci-agent-0.6.1), days after [0.6.0](https://github.com/hercules-ci/hercules-ci-agent/releases/tag/hercules-ci-agent-0.6.0) release.

Everyone is encouraged to upgrade, as it brings performance improvements, a bugfix to IFD and better onboarding experience.

### 0.6.1 - 2019-11-06

### Fixed

 - Fix token leak to system log when reporting an HTTP exception. This was introduced by a library upgrade.
   This was discovered after tagging 0.6.0 but before the release was
   announced and before moving of the `stable` branch.
   Only users of the `hercules-ci-agent` `master` branch and the unannounced
   tag were exposed to this leak.
   We recommend to follow the `stable` branch.

 - Temporarily revert a Nix GC configuration change that might cause problems
   until agent gc root behavior is improved.

### 0.6.0 - 2019-11-04

### Changed

 - Switch to Nix 2.3 and NixOS 19.09. *You should update your deployment to reflect the NixOS upgrade*, unless you're using terraform or nix-darwin, where it's automatic.
 - Increased parallellism during push to cachix
 - Switch to NixOS 19.09
 - Enable min-free/max-free Nix GC

### Fixed

 - Transient errors during source code fetching are now retried
 - Fixed a bug related to narinfo caching in the context of IFD
 - Fixed an exception when the root of ci.nix is a list, although lists are unsupported


## What we do

Automated hosted infrastructure for Nix, reliable and reproducible developer tooling,
to speed up adoption and lower integration cost. We offer
[Continuous Integration](https://hercules-ci.com) and [Binary Caches](https://cachix.org).
