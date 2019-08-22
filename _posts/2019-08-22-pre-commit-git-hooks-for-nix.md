---
layout:     post
title:      Pre-commit git hooks with Nix
date:       2019-08-22
summary:    Pre-commit linting and formatting that agrees with your CI
image:      nix-pre-commit.png
author:     domenkozar
categories: nix
---

[pre-commit](https://pre-commit.com/) manages a set of hooks that are executed by git before committing code:

![pre-commit.png](/images/nix-pre-commit.png)

Common hooks include static analysis like source formatting, linting, etc.

Since we're managing quite a couple of repositories, decentralized maintaining of
the hooks became a development burden.

Hence we created:

# [nix-pre-commit-hooks](https://github.com/hercules-ci/nix-pre-commit-hooks)

The goal is to manage these hooks with Nix and solve the following:

- Simpler integration for Nix projects (wires up a few things behind the scenes)

- Provide a low-overhead build of all the tooling available for the hooks to use
   (naive implementation of calling nix-shell does bring some latency when committing)

- Common package set of hooks for popular languages like Haskell, Elm, etc.

- Two trivial Nix functions to run hooks as part of development and on your CI

Currently the following hooks are provided:


## Nix

- [canonix](https://github.com/hercules-ci/canonix/)

## Haskell

- [ormolu](https://github.com/tweag/ormolu)
- [hlint](https://github.com/ndmitchell/hlint)
- [cabal-fmt](https://github.com/phadej/cabal-fmt)

## Elm

- [elm-format](https://github.com/avh4/elm-format)

## Shell

- [shellcheck](https://github.com/koalaman/shellcheck)

We encourage everyone to contribute additional hooks.

## Installation

See project's [README](https://github.com/hercules-ci/nix-pre-commit-hooks#installation--usage)
for latest up-to-date installation steps.


---

## What do we do?

Automated hosted infrastructure for Nix, reliable and reproducible developer tooling, to speed up adoption and lower integration cost.
We offer [Continuous Integration](https://hercules-ci.com) and [binary caches](https://cachix.org).
