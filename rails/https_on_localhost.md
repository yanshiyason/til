# Https on localhost

Using this amazing tool for generating self signed certificates: https://github.com/FiloSottile/mkcert

Initialize mkcert with:

```bash
# You just need to run this once
$ mkcert -install
```

Make a certificate for any domain you want. (Anything other than localhost must be configured in you /etc/hosts file)

```bash
$ mkcert your-app.local.com "*.local.com" local.test localhost 127.0.0.1 ::1
```

The tool will print the path of the `key` and `cert` files.

```
Created a new certificate valid for the following names 📜
 - "your-app.local.com"
 - "*.local.com"
 - "local.test"
 - "localhost"
 - "127.0.0.1"
 - "::1"

Reminder: X.509 wildcards only go one level deep, so this won't match a.b.local.com ℹ️

The certificate is at "./your-app.local.com+5.pem" and the key at "./your-app.local.com+5-key.pem" ✅

It will expire on 17 September 2024 🗓
```

Now start rails using the following command, and pass the url encoded paths as parameters:

```bash
$ rails s -b 'ssl://localhost:3000?key=your-app.local.com%2B5-key.pem&cert=your-app.local.com%2B5.pem'
```

Then visit: https://localhost:3000/
