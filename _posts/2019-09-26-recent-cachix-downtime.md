---
layout:     post
title:      Post-mortem on recent Cachix downtime
date:       2019-09-27
summary:    Analysis of events that took place and how we've improved our infrastructure
image:      cachix-downtime-unsplash.jpg
author:     domenkozar
tags:       nix cachix
---

On 6th of September, [Cachix](https://cachix.org) experienced 3 hours of downtime.

We'd like to let you know exactly what happened and what measures we haven taken to prevent such an event from happening in the future.

## Timeline (UTC)

- 2019-09-06 17:15:05: cachix.org down alert triggered
- 2019-09-06 20:06:00: Domen gets out of [MuniHac](https://munihac.de/2019.html) dinner in the basement and receives the alert
- 2019-09-06 20:19:00: Domen restarts server process
- 2019-09-06 20:19:38: cachix.org is back up

## Observations

The backend logs were full of:

```log
Sep 06 17:02:34 cachix-production.cachix cachix-server[6488]: Network.Socket.recvBuf: resource vanished (Connection reset by peer)
```

And:

```log
(ConnectionFailure Network.BSD.getProtocolByName: does not exist (no such protocol name: tcp)))
```

Most importantly, there were no logs after we downtime was triggered and until the restart:

```log
Sep 06 17:15:48 cachix-production.cachix cachix-server[6488]: Network.Socket.recvBuf: resource vanished (Connection reset by peer)
Sep 06 20:19:26 cachix-production.cachix systemd[1]: Stopping cachix server service...
```

Our monitoring revealed an increased number of nginx connections and file handles (the time are in CEST - UTC+2):

![File handles and nginx connections](/images/cachix-downtime-monitoring.png)

## Conclusions

- The main cause for downtime was hanged backend. The underlying cause was not identified
  due to lack of information.

- The backend was failing some requests due to reaching the limit of 1024 file descriptors.

- The duration of the downtime was due to the absence of a telephone signal.

## What we've already done

- To avoid any hangs in the future, we have configured [systemd watchdog](http://0pointer.de/blog/projects/watchdog.html)
  which automatically restarts the service if the backend doesn't respond for 3 seconds.
  Doing so we released [warp-systemd](https://github.com/hercules-ci/warp-systemd) Haskell library to integrate Warp (Haskell web server)
  with systemd, such as socket activation and watchdog features.

- We've increased file descriptors limit to 8192.

- We've set up [Cachix status page](https://status.cachix.org/) so that you always check the state of the service.

- For a better visibility into errors like file handles, we've configured [sentry.io](https://sentry.io)
  error reporting.
  Doing so we released [katip-raven](https://github.com/hercules-ci/katip-raven) for seamless Sentry integration
  of structured logging which we also use to log Warp (Haskell web server) exceptions.

- Robert is now fully onboarded to be able to resolve any Cachix issues

## Future work

- Enable debugging builds for production. This would allow systemd watchdog to [send signal SIGQUIT](https://mpickering.github.io/ghc-docs/build-html/users_guide/debug-info.html#requesting-a-stack-trace-with-sigquit) and get an execution stack in which program hanged.

  We opened [nixpkgs pull request](https://github.com/NixOS/nixpkgs/pull/69552) to lay the ground work
  to be able to compile debugging builds.

  However there's a GHC bug opened showing [debugging builds alter the performance of programs](https://gitlab.haskell.org/ghc/ghc/issues/15960), so we need to asset our impact first.

- Upgrade [network](https://github.com/haskell/network) library to 3.0 fixing [unneeded file handle usage](https://github.com/snoyberg/http-client/issues/374#issuecomment-535919090) and [a possible candidate for a deadlock](https://github.com/haskell/network-bsd/commit/2167eca412fa488f7b2622fcd61af1238153dae7).

  There's [an old issue in Stackage](https://github.com/commercialhaskell/stackage/issues/4528), but we're confident it will be resolved soon.

- Improve load testing tooling to be able to catch these issues early.

## Summary

We're confident such issues shouldn't affect the production anymore and since availability of
Cachix is our utmost priority, we are going to make sure to complete the rest of the work in a timely manner.

---

## What we do

Automated hosted infrastructure for Nix, reliable and reproducible developer tooling,
to speed up adoption and lower integration cost. We offer
[Continuous Integration](https://hercules-ci.com) and [Binary Caches](https://cachix.org).
