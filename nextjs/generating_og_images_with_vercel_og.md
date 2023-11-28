# Generating OG images with vercel/og

Good:

- Very fast (Images can be dynamically generated in a few milliseconds)
- Good enough CSS support (similar to React Native)
- caching headers are automatically set
- You can use their online editor to have immediate feedback
- You can use the `debug: true` option to see the bounding boxes of each element. Very useful.
- You can use encrypted parameters to make sure people can't generate an image with arbitrary values (especially useful if the image contains your company logo): https://vercel.com/docs/concepts/functions/edge-functions/og-image-generation/og-image-examples#encrypting-parameters


Bad:
- Crashes often during development and requires restarting the process.
- Can only handle stateless React components. (You can't just import any component from a shared library and use it. The component has to comply with the limitations of vercel/og)
- no support CSS in js libraries (ie: emotion css)

Gotchas:
- When setting the API route configuration `{ runtime: 'edge' }`, the way of getting the request parameters is different. (`new URL(req.url).searchParams` instead of `req.query`)
