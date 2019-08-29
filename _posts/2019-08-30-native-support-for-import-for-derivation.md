---
layout:     post
title:      Native support for import-from-derivation
date:       2019-08-29
summary:    Simplified day-to-day Nix development to remove the maintenance overhead
image:      ifd-attribute-error.png
author:     domenkozar
categories: sprints, nix, hercules-ci
---

Today we are releasing a new feature we've been working on the last couple of weeks.

# Generating Nix expressions

A developer might add a new dependency or bump a dependency version.

**Every time packaging metadata changes, we need to regenerate Nix expressions
that describe how the project is built.**

There are two ways to regenerate Nix expressions in that case:

1. Outside Nix domain, possibly with an automated script. This quickly becomes a
maintenance headache and your git repository grows in size due to generated artifacts, it requires special care when diffing, etc.

2. Let Nix generate Nix expressions during the build. Sounds simple, but it's quite subtle.

Additionally, [Nixpkgs](https://github.com/NixOS/nixpkgs.git) builds forbids option (2),
which leads to manual work.

As of today Hercules natively supports option (2), let's dig into the subtleties.

# Evaluation and realization

Nix language describes how software is built. It happens in two phases.

**The first phase is called evaluation:**

![Evaluation](/images/evaluation.png)

Evaluation takes a Nix expression and results into a dependency tree of derivations.

Derivation is a set of instructions how to build software.

**The second phase is called realization:**

![Evaluation](/images/realization.png)

Realizing a derivation is the process of building (builder is usually a shell script, although technically it's an executable).

Since a derivation describes all the necessary inputs, the result is guaranteed to be deterministic.

# Derivations

This begs the question, why have intermediate representation (derivations)? There are a couple of reasons:

- Evaluation is non-trivial, it can range from a couple of seconds, to typically minutes, or even an hour for huge projects.
  We want to evaluate only once and then distribute derivations to multiple machines for speedup and realize them as we traverse the graph of dependencies.

- Evaluation can produce derivations that are built on different platforms or require some specific hardware.
  In that case multiple builders are a requirement.

- In case of a build failure, it allows the machine to retry immediately instead of re-evaluating again.

**All in all, derivation files are a slight overhead we pay instead of evaluating more than once.**

# Interleaving evaluation and realization

Sometimes it's worth mixing the two phases (for more on why and when, ).

A build produces Nix expressions that we now
would like to evaluate, but we're already in the realization phase, so we have:

1. Evaluate to get the derivation that will output a Nix file
2. Realize that derivation
3. Continue evaluating by importing the derivation containing the Nix file
4. Realize the final derivation set

This is called Import-From-Derivation or shortly, IFD.

# A minimal example

```nix
let
  pkgs = import <nixpkgs> {};
  getHello = pkgs.runCommand "get-hello.nix" {} ''
    echo 'pkg: pkg.hello' > $out
  '';
in import getHello pkgs
```

In the last line we're importing from `getHello`,
which is a Nix derivation that we need to build
before evaluation can continue to use `pkg: pkg.hello` Nix expression
in the output.

# Haskell.nix example

[haskell.nix](https://input-output-hk.github.io/haskell.nix/) is an alternative Haskell infrastructure for Nixpkgs.

Given a Haskell project with a Cabal file (Haskell's package manager),
drop the following `default.nix` into root of your repository:

```nix
let
  pkgs = import <nixpkgs> {};
  haskell = import ((import ./nix/sources.nix)."haskell.nix") { inherit pkgs; };
  plan = haskell.callCabalProjectToNix
              { index-state = "2019-08-26T00:00:00Z"; src = pin.lib.cleanSource ./.;};

  pkgSet = haskell.mkCabalProjectPkgSet {
    plan-pkgs = import plan;
    pkg-def-extras = [];
    modules = [];
  };
in pkgSet.config.hsPkgs.mypackage.components.all
```

Once you replace `mypackage` with the from your Cabal file,
your whole dependency tree is deterministic by pinning package index to a timestamp
using `index-state` and hash of your local folder using `./.`.

Haskell.nix will generate all expressions how to build each package on the fly.

# Native support in CI

Using different platforms (typically Linux and macOS) during IFD is one of the reasons
why upstream forbids IFD, since evaluator is running on linux and it can't build macOS.

Our CI dispatches all builds during IFD back to our scheduler, so it's able to dispatch
those builds to either specific platform or specific hardware.

**IFD support is seamless, there's nothing extra to configure.**

In case of build errors during evaluation UI will show you all the details including build log:

![IFD attribute error](/images/ifd-attribute-error.png)

In order to use IFD support you will need to upgrade to [hercules-ci-agent-0.4.0](https://github.com/hercules-ci/hercules-ci-agent/releases/tag/hercules-ci-agent-0.4.0).

# Drawbacks

- Nix evaluation is currently single threaded. While evaluation is waiting for the
  build, it's blocking. It's future work to make evaluation concurrent.

- IFD creates some overhead, but it's paid only when dependencies change.

- There isn't a lot of Nix tooling that embraces IFD. Besides haskell.nix there is
  [pnpm2nix for Node.js](https://github.com/adisbladis/pnpm2nix).

We believe this is **a huge step forward simplified day-to-day Nix development** to remove the maintenance overhead.

## What we do

Automated hosted infrastructure for Nix, reliable and reproducible developer tooling, to speed up adoption and lower integration cost.
We offer [Continuous Integration](https://hercules-ci.com) and [Binary Caches](https://cachix.org).
