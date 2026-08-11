# CLAUDE.md

Be brief. Update the specs under spec/*.md when change code.

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Developemt process

Never implement anything unless you wrote a plan in an issue.

When the user ask for a new feature create an issue in the main repo (trustable-app) and store the plan in it. Then stop — do not create any branch and do not write any code.

Always save the plan in the issue as soon as the plan is finished — never leave a plan only in the chat. If the plan changes while planning, update the issue body so it stays the current plan.

Wait for an express request from the user to implement (for example "implement issue N"). Only then create the branch issue-<issuenr> and start implementing.

Implement only the plan written in the issue.

Once implemented, update the issue with what was actually done (deviations from the plan included),  and create a pull request to main.

When creating a PR always add a comment listing all the open PR related to the implemented issue.

When I ask to complete, create the PR, merge in the main and switch to the updated main.


