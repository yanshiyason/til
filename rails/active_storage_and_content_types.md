# Active storage and file content types

### TLDR

1. ActiveStorage uploads the blob to S3, and infers the content type from the file extension
2. Upon associating the blob to a model, the blob analyzers run
3. If they detect a different content type, they update the content type
4. The model validations kick in, and see the "new" content type, not the one stored in the blobs table.

Today, someone played a trick on us.

Someone uploaded a file called `"receipt.png"`, but the content of the file, was
actually some HTML. When ActiveStorage performs a direct upload, the file gets
stored to S3, and a row gets added to the `active_storage_blobs` table. This row
contains metadata about the file including it's `filename` and the inferred
`content_type`, which was `image/png` in this case.

Our model, had a validation like this:

```ruby
class Receipt < ApplicationRecord
  validates :file, presence: true, blob: { content_type: %r{(^image/|application/pdf)} }
end
```

Our controller looked like this:

```ruby
def create
  receipt = Receipt.new(file: params[:file])
  receipt.save!
  redirect_to '/foo'
end
```

We used `save!` and did not prepare a sad path because we didn't expect the
frontend to send files with content types other than what we specified in the
`accept` attribute of the input tag. Our input had the following markup:

`<input type="file" accept="image/*, application/pdf">`.

The `accept` attribute of HTML inputs restrict which kinds of files can be
uploaded but it only looks at the file extensions, so you can rename any file
you want to `.png` or `.pdf`, and the picker will allow you to select it.

ActiveStorage also uses the extension of the file infer the initial content_type
of the blob. The interesting part is here:

```ruby
blob = ActiveStorage::Blob.find(42) # I queried the staging DB for the blob causing the issue
blob.filename
#=> receipt.png
blob.content_type
#=> image/png

# Then I tried to instantiate a Receipt object to call the validations
receipt = Receipt.new(file: blob)
receipt.valid?
#=> false

receipt.errors.full_messages_for(:file)
#=> content_type is invalid

blob.content_type
#=> text/html
```

What?! Why did the content_type of the blob suddenly change?! Let me try that again..

```ruby
blob = ActiveStorage::Blob.find(42)
blob.content_type
#=> image/png

Receipt.new(file: blob)

blob.content_type
#=> text/html
```

Simply assigning the blob to the receipt, is changing it's content_type from `image` to `html`... what can possibly be causing this..?

After more pocking around, my coworker asks me to download the file, and this is what we find:

```ruby
blob.download
#=>=> "<!DOCTYPE html><html lang=\"ja\"><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\n<meta name=\"google-site-verification\" content=\"LQGO3Ew44bH2Uyp5ZaVgdYla-4j76K7SprzYb...
```

We are greeted with... html... so somebody uploaded a file called `receipt.png`
but it was actually an HTML file.

But why did the content type change upon assigning to blob to the receipt model?

The answer was found in the documentation of this module: [ActiveStorage::Blob::Analyzable](https://api.rubyonrails.org/classes/ActiveStorage/Blob/Analyzable.html).

From the docs:

> **analyze_later()**:
>   ... This method is automatically called for a blob when it's attached for
>   the first time ...

To confirm if this reproduces what happens when calling `Receipt.new(file: blob)`,
we can call `analyze` directly:

```ruby
blob.content_type
#=> image/png

blob.analyzed?
#=> false

blob.analyze

blob.content_type
#=> text/html

blob.analyzed?
#=> true
```

So this explains why the content type changed and it is also a reminder that the content type seen in the `active_storage_blobs` table, is not final content type that your model will see during validation.
