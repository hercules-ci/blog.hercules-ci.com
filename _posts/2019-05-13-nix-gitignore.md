---
layout:     post
title:      gitignore for Nix
date:       2019-05-13
summary:    Using local sources in Nix, respecting your gitignores
categories: nix
image:      gitignore-for-nix.jpg
---

### Abstract

[Nix](https://nixos.org/nix), when [used](https://builtwithnix.org/) as a development build tool, needs to solve the same problem that git does: ignore some files.
We've [extended](https://github.com/hercules-ci/gitignore/) `nix-gitignore` so that Nix can more reliably use the configuration that you've already written for git.

# Introduction

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
because a temporary, hidden file has changed. One of those files you filtered
out of your git tree with a 'gitignore' file...

Nix, as a build tool or package manager, was not designed with any specific version
control system in mind. In fact it predates any dominance of git, because Nix's
general solution to the file ignoring problem, [filterSource](https://nixos.org/nix/manual/#builtin-filterSource), was already
implemented in 2007.

Over the last two to three years, various people have written functions to reuse these gitignore files.
We have been using an [implementation](https://github.com/siers/nix-gitignore) by [@siers](https://github.com/siers)
over the last couple of months and it has served us well, until we had a gitignore
file that wasn't detected because it was in a parent directory of the source directory we wanted to use.

I was [nerd sniped](https://xkcd.com/356/).

Two months later, I finally got around to the implementation and I'm happy to announce
that it solves some other problems as well. It reuses the tested rules by siers,
uses no more [import from derivation](https://nixos.wiki/wiki/Import_From_Derivation) and can read all the files that it needs to.

# Usage

You can import the `gitignoreSource` function [from the repo](https://github.com/hercules-ci/gitignore#README) like below, or use your [favorite](https://github.com/nmattia/niv) 
[pinning](https://nixos.wiki/wiki/FAQ/Pinning_Nixpkgs) method.

```nix
{ pkgs ? import <nixpkgs> {} }
let
  inherit (pkgs.stdenv) mkDerivation;
  inherit (import (builtins.fetchTarball "https://github.com/hercules-ci/gitignore/archive/master.tar.gz") { }) gitignoreSource;
in
mkDerivation {
  name = "hello";
  src = gitignoreSource ./vendored/hello;
}
```

That's all there is to it.

It also composes with `cleanSourceWith` if you like to filter out some other files as well.

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

I am happy to contribute to the friendly and inventive Nix community. Even though this gitignore project is just a small contribution, it wouldn't have been possible without the ideas and work of siers, icetan, and everyone behind Nix and Nixpkgs in general.

-- Robert
