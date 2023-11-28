# Find records with or without associations

``ruby
@journals = @journals.where.associated(:receipt)
@journals = @journals.where.missing(:receipt)
@journals = @journals.where.not(a: 1)
```
