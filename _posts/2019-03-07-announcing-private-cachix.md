---
layout:     post
title:      Announcing Cachix private binary caches and 0.2.0 release
date:       2019-03-07
summary:    You can now have unlimited number of binary caches shared between a group of developers, protected from public use with just a few clicks.
categories: cachix nix
---

In March 2018 I've set myself on a mission to streamline Nix usage in teams.

Today we are shipping Nix private binary cache support to [Cachix](https://cachix.org).
You can now have unlimited number of binary caches shared between a group of developers,
protected from public use with just a few clicks.

Authorization is based on GitHub organizations/teams (if this is a blocker for you,
[let us know what you need](https://github.com/cachix/cachix/issues/181)).

To get started, head over to [https://cachix.org](https://cachix.org) and choose a plan that suits your
private binary cache needs:

![Create Nix private binary cache](/images/cachix-nix-create-private-cache.png)

At the same time [cachix 0.2.0](https://github.com/cachix/cachix/blob/master/cachix/CHANGELOG.md#020---2019-03-04)
cli is out with major improvements to NixOS usage.
If you run the following as root you'll get:

```bash
$ cachix use hie-nix
Cachix configuration written to /etc/nixos/cachix.nix.
Binary cache hie-nix configuration written to /etc/nixos/cachix/hie-nix.nix.

To start using cachix add the following to your /etc/nixos/configuration.nix:

    imports = [ ./cachix.nix ];

Then run:

    $ nixos-rebuild switch
```

Thank you for your feedback in the poll answers. It's clear what we should do next:

1. [Multiple signing keys (key rotation, multiple trusted users, ...)](https://github.com/cachix/cachix/issues/146)

2. [Search over binary cache contents](https://github.com/cachix/cachix/issues/182)

3. [Documentation](https://github.com/cachix/cachix/issues/19)

Happy cache sharing!

-- Domen
