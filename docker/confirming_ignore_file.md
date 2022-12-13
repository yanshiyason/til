# Confirming Ignore File

You added a .dockerignore file but you want quick feedback if the correct files are getting ignored..

```bash
rsync -avn . /dev/shm --exclude-from .dockerignore
```

source: https://stackoverflow.com/a/71751097/4573574
