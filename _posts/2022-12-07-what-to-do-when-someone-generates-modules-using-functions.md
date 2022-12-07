---
layout:     post
title:      What to do when someone generates modules using functions
date:       2022-12-07
summary:    The module system can express any function, and functions cause messy configurations. What to do instead?
image:      math.jpg
author:     roberth
tags:       nix modules arion flake-parts
---


Today I got a question about an arion error message, and the cause was obscured because they were generating services (modules) using a function. This is a natural solution: modules are attribute sets, and functions can generate those for us. However, this skips over the fact that modules already allow composition, and allow functions to be expressed, nicely within a single paradigm: modules, not arbitrary functions.

## Module System

To recap, modules are a way to define attribute sets with extensible behavior.

While the end result is an attribute set, modules themselves are defined using functions of a specific shape, for example:

```nix
# parameters:
{ config, lib, ... }:

# module attributes
{
  config = some expression that may reference config;
  options = {
    foo = /* ... */;
  };
}
```

When the module system computes the value, it gathers up all modules from the `imports` list (or `modules`), merges the `config` values according to `options`, and passes the merged `config` as a parameter to the modules.

That last step wouldn't be possible in a strict language. Good thing Nix is lazy!

The syntax for modules allows some simplifications that will be used in this post:
It's possible to write just the attribute set containing the `config` and/or `options` attributes, or even just the value of `config`.
The module system does a decent job figuring out what we mean; if it doesn't, choose a more explicit syntax.

## What to do about functions?

(First, be nice. It was a perfectly reasonable thing to do. Let's make it even better!)

Let's use arion as our example. I'll explain just enough, so you don't need to know arion.

An arion `service` is a submodule: a module inside another module.

Submodules behave just like any other module, except in some cases you may have to define them as a function, instead of using the shorthand syntax, which is just to write an attrset.

Arion defines a couple of options, like

```
options = {

  service.environment = mkOption {
    type = attrsOf str;
  };

  service.labels = mkOption {
    type = attrsOf str;
  };

}
```

The arion user's `arion-compose.nix` file defined some services using a function.

`arion-compose.nix`
```nix
let 
  /* Goal: remove this function */
  composedService = { command, environment, status ? "dev" }: {
    config = {
      service.command = command;
      service.environment = environment // { STATUS = status; };
      service.labels."com.companyname.tool" = "arion";
      service.labels."com.companyname.status" = status;
    };
  }
in
{
  /* ... */

  services.initdb = composedService { command = "initdb"; environment.FOO = "bar"; };
  services.initusers = composedService { command = "initdbusers"; };
}
```

Now we're facing a bit of a challenge. `initusers` depends on `initdb`, but that's become a bit hard to express now, because the `services.initdb` and `services.initusers` submodules are defined through a function indirection rather than a submodule. Neither service is complete, as `service.healthcheck` and `service.depends_on` need to be added to implement and express the service dependency.

What do we do? Add another parameter to `composedService`? We may well have to add everything at some point. Modify the result with `//`? Not pretty either; to make that work we need a `let` binding for the return value and we need to do merge attributes manually, like `service = composed.service // { environment = composed.service.environment // { EXTRA_ENV = "x"; } }`.

Wait, isn't this what the module system is for?

Here's a good first step: let the module system do the merging.

`arion-compose.nix`
```nix
  /* ... */

  services.initdb = {
    imports = [
      (composedService { command = "initdb"; environment.FOO = "bar"; })
    ];
    service.healthcheck = /* ... */;
  };
  services.initusers = {
    imports = [
      (composedService { command = "initdbusers"; });
    ];
    service.depends_on = [ "initdb" ];
  };
```

Now let's rewrite `composedService` as a module, as promised. We'll define it in a file. Perhaps `company-service.nix` is a good name.

Let's start with the easiest bits. `command` was passed through unmodified, so we can ignore that and let our "callers" set `service.command` directly.

Unlike `command`, `environment` was modified, but only in the way that the type `attrsOf str` would merge values.

`company-service.nix`
```nix
{
  service.environment.STATUS = /* ??? */;
}
```

How do we represent function parameters? Turns out options can do the job just fine:

`company-service.nix`
```nix
{ lib, config, ... }:
let inherit (lib) mkOption types;
in
{
  options = {
    status = mkOption {
      description = ''
        What kind of deployment this is. `dev` deployments on common infrastructure will be removed periodically; see https://docs.company.lan/common-infra/dev-deploys.html.
      '';
      type = types.enum ["dev" "test" "prod"];
    };
  };
  config = {
    service.environment.STATUS = config.status;
    service.labels."com.companyname.status" = config.status;
    service.labels."com.companyname.tool" = "arion";
  };
}
```

Granted, modules are a bit more verbose than functions, but now we got rid of the complexity at the call sites and the desire to extend the function indefinitely.

Here's what its usage now looks like:

`arion-compose.nix`
```nix
  /* ... */

  services.initdb = {
    imports = [ ./company-service.nix ];
    service.command = "initdb";
    service.environment.FOO = "bar";
    service.healthcheck = /* ... */;
  };
  services.initusers = {
    imports = [ ./company-service.nix ];
    service.command = "initdbusers";
    service.depends_on = [ "initdb" ];
  };
```

Now it's more declarative, we're taking advantage of module composition, there's less duplication, and we've written some documentation in the process. Most importantly - our motivation for this story: errors in the option path syntax will be easier to understand.

## But what if...

The refactoring technique above doesn't always apply cleanly. For example, you may want to use the function as a function elsewhere.

This is still possible, but I'll save that for another blog post. `lib.evalModules` will be involved...
