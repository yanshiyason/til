# Launching a daemon on mac

I am familiar with `brew services` and the `list|stop|start` which I use to
keep my local postgres and redis instances running but I didn't know it used
`launchctl` under the hood.

When I develop, I usually have a `notes.md` file in every project that I use
as a scratchpad. These `notes.md` file are not checked into git and I thought
it would be better to have a `~/notes` repository in my root folder tracked in
git that I could access at the touch of a key using the amazing nvim telescope
file finder. It would also be nice if it was automatically synced to github so
I don't have to remember to go in there and push every once in a while.

I was looking for automated git syncing tools, and I found one which seems to
work pretty well. It's called [gitwatch](https://github.com/gitwatch/gitwatch).

In order to have the process launch automatically, this is what I had to do:

1. Create a plist file inside the user's LaunchAgent directory:
	
	~/Library/LaunchAgents/com.shiyason.gitwatch.notes.plist

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
	<dict>
		<key>KeepAlive</key>
		<true/>
		<key>Label</key>
		<string>com.shiyason.gitwatch.notes.plist</string>
		<key>ProgramArguments</key>
		<array>
			<string>/bin/zsh</string>
			<string>-c</string>
			<string>-l</string>
			<string>/opt/homebrew/bin/gitwatch -r git@github.com:yanshiyason/notes.git .</string>
		</array>
		<key>RunAtLoad</key>
		<true/>
		<key>StandardErrorPath</key>
		<string>/opt/homebrew/var/log/com.shiyason.gitwatch.notes.log</string>
		<key>StandardOutPath</key>
		<string>/opt/homebrew/var/log/com.shiyason.gitwatch.notes.log</string>
		<key>WorkingDirectory</key>
		<string>/Users/yannickchiasson/yanshiyason/notes</string>
	</dict>
</plist>
```

Make sure the label is unique.
Using `/bin/zsh -c -l` launches the command after loading the .zshrc file which
might be necessary (if the command requires your environment loaded)

2. Use the `launchctl` commands the make sure the thing is working

```bash
# turn it on/off
launchctl stop com.shiyason.gitwatch.notes.plist
launchctl unload ~/Library/LaunchAgents/com.shiyason.gitwatch.notes.plist
launchctl load ~/Library/LaunchAgents/com.shiyason.gitwatch.notes.plist
launchctl start com.shiyason.gitwatch.notes.plist

# check the logs
tail -f /Users/yannickchiasson/yanshiyason/notes 
```

NOTES:
- https://apple.stackexchange.com/questions/110644/getting-launchd-to-read-program-arguments-correctly
