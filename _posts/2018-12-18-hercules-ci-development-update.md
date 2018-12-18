---
layout:     post
title:      Hercules CI Development Update
date:       2018-12-18
summary:    Progress, features and more about the Early Access. We need your input!
categories: hercules-ci
---

We've been making good progress since our [October 25th NixCon demo](https://www.youtube.com/watch?v=py26iM26Qg4).

Some of the things we've built and worked on since NixCon:

 - Realise the derivations and show their status
 - Minimal build logs
 - Keeping track of agent state
 - GitHub build statuses
 - Improved agent logging
 - Work on Cachix private caches
 - Incorporating
 - Plenty of small fixes, improvements and some open source work

Here you can see attributes being streamed as they are evaluated
and CI immediately starts to build each attribute and shows cached derivation statuses:

![evaluating](images/evaluating.gif)

Since we've started dogfooding a few weeks ago, we've been getting valuable insight. There's plenty of things to do and bugs to fix. 
Once we're happy with the user experience for the minimal workflow, we'll contact email subscribers and start handing out early access.

If you'd like to be part of early adopters or just be notified of development, make sure to subscribe to [Hercules CI](https://hercules-ci.com).

-- Robert
