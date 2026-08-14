# CLAUDE.md

Be brief. Update the specs under spec/*.md when change code.

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Developemt process

Never implement anything unless you wrote a plan in a spec markdown. The spec can also be created by the user.

Create if not there a spec documents under spec/<n>-<description> where <n> is incremental.

Always do a plan and add it to the spec file before implementing and create a branch spec-<n> when  implementing.

Implement only the plan written in the spec <n>, keep updating the plan if the user asks.

When the user ask to complete, bun build, create a PR, merge it in the main  switch to the updated main and push to github to update the site.





