# Running unpublished actions

Today I made opened a PR to a public github action that I am using in a little pet project:

https://github.com/ksivamuthu/aws-copilot-github-action/pull/158

I had to run the action in an actual CI environment to confirm if it was working. I clicked on the "publish to marketplace" button from the github UI so I can use it in my CI setup, but the review process is so long.. and it might be refused since it's just a clone of another action with some tweaks.

TIL: It's actually possible to run unpublished actions:

Just specify it in this format: {owner}/{repo}@sha

https://docs.github.com/en/actions/creating-actions/creating-a-javascript-action#example-using-a-public-action
