---
layout:     post
title:      CI Development Update
date:       2021-12-02
summary:    Development has continued but the blog hasn't. Let's fix that!
image:      hercules-ci.jpg
author:     roberth
tags:       hercules-ci
---


Blogging has been a while and lot has happened.

### Hercules CI Effects

The Hercules CI Effects beta was introduced: a principled way for running code after build success, with access to network and secrets. See [the docs](https://docs.hercules-ci.com/hercules-ci/effects/).

### Other improvements

Some highlights:

 - Streaming build and evaluation logs (as I've said, it's been a while since the last update!)
 - Builds on `aarch64-linux`
 - Support for arbitrary Nix caches as supported by the Nix `--store` flag
 - Builds on `aarch64-darwin` (hercules-ci-agent 0.8.4)
 - Various improvements to the [dashboard](https://hercules-ci.com/dashboard)
 - Build failure [notification emails](https://hercules-ci.com/settings/notifications)
 - The `hci` command line interface
 - Remote state file plugin for NixOps 2

### Upcoming Release

Meanwhile, the upcoming agent 0.9 release is going to be another exciting one, with Flakes support and multi-input jobs; a way to make continuous integration more continuous, by including the latest builds of dependency repositories.

So, stay tuned!
