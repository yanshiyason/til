
# Analyzing production bundles

In order to know which javascript library is using up all your bandwidth, you can do the following.

Install the [`webpack-bundle-analyzer`](https://github.com/webpack-contrib/webpack-bundle-analyzer) package.

```json
yarn add -D webpack-bundle-analyzer
```

Then run it:

```bash
mkdir -p public/packs && \
 NODE_ENV=production npx webpack --config config/webpack/production.js --profile --json > tmp/stats.json && \
 npx webpack-bundle-analyzer tmp/stats.json
```
