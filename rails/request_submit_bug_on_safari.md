# requestSubmit bug on Safari

`requestSubmit` is known to need a polyfill on safari. The turbo team included a fix for it by default inside turbo [here](https://github.com/hotwired/turbo/pull/439)

We have a Stimulus controller which automatically submits form for image uploads which looks like this:

```js
export default class extends Controller {
  connect() {
    this.element.querySelector('[type="submit"]').hidden = true

    // When a new file is selected, call requestSubmit to kick off the direct upload.
    this.element.addEventListener('change', () => {
      this.element.requestSubmit()
    })

    /// [...]
  }
}
```

The above implementation worked on Chrome, but we got a bug report for a Safari user.
It turns out that we had to pass in the `submitted` in order for it to work:

```js
const submitButton = this.element.querySelector('[type="submit"]')
submitButton.hidden = true

this.element.addEventListener('change', () => {
  this.element.requestSubmit(submitButton)
})
```
