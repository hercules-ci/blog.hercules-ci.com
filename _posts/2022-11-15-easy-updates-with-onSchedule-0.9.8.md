---
layout:     post
title:      Easy updates with onSchedule in agent 0.9.8
date:       2022-11-15
summary:    Introducing scheduled jobs in the latest agent updates, as well as an easy flake updater and temporary git token distribution.
image:      hercules-ci.jpg
author:     roberth
tags:       hercules-ci
---

_Do your flake dependencies go out of date? Don’t like to wait for updates?_

We’ve just released our latest automation feature: scheduled builds. Think `cron`, but readable.

After updating your agent, you can define jobs in the new `herculesCI.onSchedule` attribute.

This is similar to the `herculesCI.onPush` attribute that powers the automatic flake builds, but jobs are created as time passes instead.

Here’s a flake based example:

```nix
outputs = { ... }: {
  herculesCI.onSchedule.update = {
    when = {
      hour = [ 12 ];
      dayOfWeek = ["Mon" "Thu"];
    };
    outputs.effects.update = ...;
  };
}
```

This will create a job for the `herculesCI.onSchedule.update.outputs` on Mondays and Thursdays at 12:xx UTC.

Hercules CI will pick an arbitrary minute number for you once, but if you prefer, you can control this with the `minute` attribute. `dayOfMonth` is also supported. Combined with `dayOfWeek` you can define a constraint like *every first and third Tuesday of the month*.

You can find reference documentation for onSchedule [here](https://docs.hercules-ci.com/hercules-ci-agent/evaluation/#attributes-onSchedule). More step by step documentation will be provided later. Let’s first see how this can be turned into simple options.

## Easy flake update

You probably don’t want to write your own flake update script, so this is where `hercules-ci-effects` comes in. It offers a library of configurable effects; think of it as a little Nixpkgs for effects, and it already has a flake updater.

Let's wire it up. You could call the `updateFlake` function in the `...` of snippet above, but that would get repetitive across your repositories. So this is where [flake.parts](https://flake.parts) comes in. It’s like NixOS options, but for flakes, and just a core library instead of a monorepo. It's designed so that there’s no excuse not to use it. And `hercules-ci-effects` provides a module.

With flake-parts, all you need is:

```nix
imports = [ inputs.hercules-ci-effects.flakeModule ];
hercules-ci.flake-updater.enable = true;
```

This will automatically create a branch that will start building once a day.

You will be able to configure it to create a PR or to run [at different times](https://flake.parts/options/hercules-ci-effects.html#opt-hercules-ci.flake-update.when).

## Secure tokens

Flakes and flake parts make this easy to integrate, but without another feature, setting up the updater was still a bit cumbersome for two reasons: repeating the repository URL, but worse was configuring access tokens in `secrets.json`. Not only was it repetitive, but potentially unsafe. While a single personal access token could serve all the repositories in an organization, reducing the hassle a bit, but it’s not a good practice, because it violates the principle of least power. If it would leak, an attacker could affect the whole GitHub organization!

This is an area where Hercules CI can help out, by providing temporary repository-specific tokens.

In the unlikely event that a buggy event spills the token, it will only provide access to a single repository, and only if the attacker finds the token shortly after the leak.

An effect may retrieve this token with `secretsMap.<name-inside-effect> = { type = "GitToken"; };`.

All these improvements combined reduce the updater configuration to a minimum.

### Granting permissions

To let Hercules CI distribute these tokens, it needs permission to do so.

NOTE: If you read this early, the permissions request may not be available yet.

If you got the email from GitHub, you can take it from there.

Otherwise, if you are an admin of the GitHub organization, or if you use it on your personal account, follow the steps:

 - Go to the [app page on GitHub](https://github.com/apps/hercules-ci).

 - Click **[Configure]**, and again for the account you want to update.

 - Near the top of the page, you’ll see a note that says _Hercules CI is requesting an update to its permissions._ Click **[Review request]**.

 - The page will ask you to confirm write access for _Contents_ and _Pull requests_. Click **[Accept new permissions]**.

## The Future

Hercules CI is now improving workflow automation.

The updater will improve and evolve. For instance, the `git clone` logic could
be factored out for other deployment and automation tasks to use.

[flake.parts](https://flake.parts) has started to gain traction.
Its site now aggregates the options documentation, and I'm excited to see what comes next!
