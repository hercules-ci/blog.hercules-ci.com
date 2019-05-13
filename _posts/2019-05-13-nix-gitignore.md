---
layout:     post
title:      gitignore for Nix
date:       2019-05-13
summary:    Using local sources in Nix, respecting your gitignores
categories: nix
---

# Summary

Nix, when used as a build tool, needs to solve the same problem git has to solve: ignore some files.
We've [adapted](https://github.com/hercules-ci/gitignore/) an existing project so that Nix can more reliably use all of the configuration that you already wrote for git.

# Introduction

Our applications are [built](https://builtwithnix.org/) and deployed with Nix.
When you tell Nix to build your project, you need to tell it which source files
to build. This is done by using path syntax in a derivation or string interpolation.

```nix
mkDerivation {
  src = ./vendor/cowsay;
  patches = [ ./cowsay-add-alpaca.patch ];
  # ...
}
```

This works well, until you find that Nix unexpectedly rebuilds your derivation
because a temporary, hidden file has changed. One of those file you filtered
out of your git tree with a 'gitignore' file...

Nix, as a build tool or package manager, was not designed with any specific version
control system in mind. In fact it predates any dominance of git, because Nix's
general solution to the file ignoring problem, `filterSource`, was already
implemented in 2007.

Over the last two to three years a couple of solutions have been written by various
people to reuse these gitignore files in automatic source filtering functions.
We have been using an [implementation](https://github.com/siers/nix-gitignore) by [@siers](https://github.com/siers)
over the last couple of months and it has served use well, until we had a gitignore
file that wasn't in the source directory we wanted to use.

I was [nerd sniped](https://xkcd.com/356/).

Two months later, I finally got around to the implementation and I'm happy to announce
that it solves some other problems as well. It reuses the tested rules by siers,
uses no more import from derivation and can read all the files that it needs to.

# How to use it

Simply import the `gitignoreSource` function [from the repo](https://github.com/hercules-ci/gitignore#README)
and call it like so

```nix
mkDerivation {
  name = "hello";
  src = gitignoreSource ./vendored/hello;
}
```

It composes with `cleanSourceWith` if you like to filter out some other files as well.

# Comparison

Here's a comparison with the pre-existing implementation I could find.

The latest [up to date comparison table](https://github.com/hercules-ci/gitignore#comparison) is available on the repo.

| Feature \ Implementation | cleanSource | [siers](https://github.com/siers/nix-gitignore) | [siers recursive](https://github.com/siers/nix-gitignore) | [icetan](https://github.com/icetan/nix-git-ignore-source) | [Profpatsch](https://github.com/Profpatsch/nixperiments/blob/master/filterSourceGitignore.nix) | [numtide](https://github.com/numtide/nix-gitignore) | this project
|-|-|-|-|-|-|-|-|
|Ignores .git                             | ✔️ | ✔️ | ✔️ | ✔️ | ✔️ | ✔️ | ✔️ 
|No special Nix configuration             | ✔️ | ✔️ | ✔️ | ✔️ | ✔️ |   | ✔️ 
|No import from derivation                | ✔️ | ✔️ |   | ✔️ | ✔️ | ✔️ | ✔️ 
|Uses subdirectory gitignores             |   |   | ✔️ |   |   | ✔️ | ✔️ 
|Uses parent gitignores                   |   |   |   |   |   |✔️ ?| ✔️ 
|Uses user gitignores                     |   |   |   |   |   | ✔️ | ✔️ 
|Works with `restrict-eval` / Hydra       | ✔️ | ✔️ |   | ✔️ | ✔️ |   | ✔️
|Included in nixpkgs                      | ✔️ | ✔️ | ✔️ |   |   |   |

|   | Legend |
|---|-------------------------------------|
|✔️  | Supported
|✔️ ?| Probably supported
|   | Probably not supported
|?  | Probably not supported
|-  | Not applicable or depends

# Closing thoughts

I am happy to contribute to the friendly and inventive community that is the Nix community. Even though this gitignore project is just a small contribution, it wouldn't have been possible without the ideas and work of siers, icetan, and everyone behind Nix and Nixpkgs in general.

-- Robert
