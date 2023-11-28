# Getting core.info output in the logs

You have to set `ACTIONS_RUNNER_DEBUG: true` in the `env` section for `core.info()` calls inside `aws-copilot-github-action` to print anything in the logs.

```yaml
- name: Deploy to AWS
  uses: yanshiyason/aws-copilot-github-action@73aa2cf291ec45ccb6edc4070145c8f57bda3d47
  with:
    command: deploy
  env:
    ACTIONS_RUNNER_DEBUG: true
```
