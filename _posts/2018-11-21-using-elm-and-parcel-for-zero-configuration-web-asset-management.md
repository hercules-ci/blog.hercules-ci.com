---
layout:     post
title:      Using Elm and Parcel for zero configuration web asset management
date:       2018-11-21
summary:    Tired of configuring webpack? A simple getting started guide to drop your 400 lines of javascript
categories: elm
---

At some point our frontend had ~200 lines of Webpack configuration and
it was going to grow by at least another 200 lines for a simple change of having
two top-level html outptus. My mind went
"what happened to [convention over configuration](https://en.wikipedia.org/wiki/Convention_over_configuration)
 in the frontend sphere"? I discovered Parcel.

In this short post I'll show you how to get started with [Parcel](https://parceljs.org)
and [Elm](https://elm-lang.org/) to achieve zero configuration for managing your assets.

With very little configuration you get:

- live Elm reloading
- ~100ms rebuilds with a warm cache (measured using ~1500 loc)
- `--debug` when using a server (this change hasn't been released yet)
- `--optimize` when using a build
- importing an asset (from `node_modules` or relatively) just does the right thing
- bundling and minification of assets

## Bootstrapping

Using **yarn** or **npm** (btw, [pnpm](https://pnpm.js.org/) is currently the
most sane Node package manager):

```bash
mkdir parcel-elm-demo && cd parcel-elm-demo
yarn add parcel-bundler elm
yarn run elm init
```

We'll create a minimal Elm program to start with in **src/Main.elm**:

```elm
import Html exposing (..)

main = text "Hello world"
```

Next we create a top-level asset that Parcel will build, **index.html**:

```html  
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
  </head>
  <body>
    <div id="main"></div>
    <script src="./index.js"></script>
  </body>
</html>
```

Note how we're including `src` as relative path to a JavaScript file. The general idea
in Parcel is that you import files of any asset type, and Parcel will
know how to process and bundle it.

The gist of glueing Elm and Parcel together is in **index.js**:

```javascript
import { Elm } from './src/Main.elm'

Elm.Main.init({
  node: document.getElementById('main'),
});
```

At the `import` Parcel will detect that it's an Elm asset,
so it will use Elm to compile it and then exports the `Elm` Javascript object as we use it
to initialize Elm in the DOM.

## Running Parcel

There are two main operations in Parcel. First, you have a development mode via
live-reloading server:

```
$ yarn run parcel index.html
yarn run v1.9.4
$ /home/ielectric/dev/parcel-demo/node_modules/.bin/parcel index.html
Server running at http://localhost:1234
✨  Built in 456ms.
```

Open http://localhost:1234 and modify **src/Main.elm**. You should see on the terminal

```
✨  Built in 123ms.
```

and your page will be refreshed automatically.

To produce a final bundle for production, you use parcel with a command, `build`:

```
$ yarn run parcel build index.html
yarn run v1.9.4
$ /home/ielectric/dev/parcel-demo/node_modules/.bin/parcel build index.html
✨  Built in 2.07s.

dist/parcel-demo.bc110dbc.js     7.93 KB    1.55s
dist/parcel-demo.4f74f229.map      373 B      3ms
dist/index.html                    288 B    442ms
Done in 2.87s.
```

Your minified, bundled Elm project is now ready to be deployed.

## Parcel isn't perfect (yet!)

There are a few issues still around.

- Sometimes (I haven't been able to figure out when exactly, not often)
  [live reloading doesn't work](https://github.com/parcel-bundler/parcel/issues/2147).
  The good news is Matt recently figured out what is going on so I'm confident
  the fix is imminent.

- There is [no support for proxying request to your backend](https://github.com/parcel-bundler/parcel/issues/1562)
  and it's not planned. I actually like that Parcel is focusing on one thing, but
  you'll have to figure out how to glue frontend and backend on your own. We run
  a reverse proxy in front of the live reloading server, which closely resembles
  a production deployment.

- [Documentation](https://parceljs.org/getting_started.html) is quite succinct,
  mostly because you just keep importing assets and adding post-processing configuration
  like `.postcssrc` and Parcel will use that when processing CSS. However, getting the
  mental model how to assemble everything or when things break, your best luck is
  [the issue tracker](https://github.com/parcel-bundler/parcel/issues).

That's it. Last but not least, we're building next-generation CI and binary
caching services, take a look at [Hercules CI](https://hercules-ci.com) and
[Cachix](https://cachix.org).

-- Domen
