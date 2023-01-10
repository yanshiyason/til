# Installing a specific version under an alias

Error:

```
../../packages/api_client/src/shared/responseRuntimeValidation.ts:8:8
Type error: Cannot use namespace 'Ajv' as a type.
```

Building locally, everything is fine, but when trying to build in docker, the import stops working..

After a bit of research, it's possible that there is a version conflict.

```bash
$ yarn why ajv
├─ @eslint/eslintrc@npm:1.4.0
│  └─ ajv@npm:6.12.6 (via npm:^6.12.4)  # <========= WRONG VERSION
│
├─ @company/api_client@workspace:packages/api_client
│  └─ ajv@npm:8.11.2 (via npm:8.11.2)
```

Looks like version 6.12.6 got added to the `node_modules`, but my code was expecting version 8.11.2.

You can install a specific version of a package under an alias to make sure your code is requiring the correct version:

[`yarn add <alias-package>@npm:<package>`](https://classic.yarnpkg.com/lang/en/docs/cli/add/#toc-yarn-add-alias)

```
$ yarn add ajv-v8@npm:ajv@8.11.2
```
