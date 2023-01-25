# Form submissions and the session cache

In the hotwired/turbo-ios demo app, [they call `session.clearSnapshotCache` after a form submission](https://github.com/hotwired/turbo-ios/blob/4b313588654acf62675b9870cf780b2300585cbf/Demo/SceneController.swift#L97-L101).

```swift
// When a form submission completes in the modal session, we need to
// manually clear the snapshot cache in the default session, since we
// don't want potentially stale cached snapshots to be used
func sessionDidFinishFormSubmission(_ session: Session) {
    if (session == modalSession) {
        self.session.clearSnapshotCache()
    }
}
```

When I tried this in my own app, I didn't understand why the page underneath the modal still displayed stale data despite calling `clearSnapshotCache`. In order to make it work, I had to use `exemptPageFromCache`.

```swift
if (session == modalSession) {
  self.session.webView.evaluateJavaScript(
    "Turbo.cache.exemptPageFromCache()"
  )
}
```

After a successful form submission:

1. the current page gets exempted from the cache.
2. The server responds with a redirect
3. The turbo session "advances" to the redirect URL which pushed a new view controller to the stack.
4. Pressing the native "back" button pops the latest view from the stack, we are now on the view from step 1 which was exempted from the cache, Turbo reloads the page, the latest data is displayed on the page.

What I noticed though, was that pages which were multiple steps further down the navigation stack still displayed stale data.

Example:


1. /home >
2. /home > /posts
3. /home > /posts > /posts/1
4. /home > /posts > /posts/1/edit
5. /home > /posts > /posts/1
6. /home > /posts (BACK)
7. /home > (BACK)

The home screen on step 7 contains stale data. The changes we made to Post/1 in step 4 are not showing until we reload the page.

This is where `clearSnapshotCache` comes into play. If we call both `clearSnapshotCache` and `exemptPageFromCache`, the page behind the modal and the pages higher up the navigation stack start behaving properly after we update some server state.
