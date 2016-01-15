Picycle
=======

Picycle runs on a Raspberry Pi and powers the rider's deploy experience.


### Development

#### Dependencies
- A ruby environment with `bundler`
- `dialog` unix tool. `brew install dialog` in OSX, should be installed on most unixen.

#### Usage
```
bundle install --without piface
bundle exec bin/picycle
```

Create a config file at `~/.picycle.yml` containing keys:
```yaml
---
github_repo: myorg/myapp             # GitHub repo in which we will merge develop to master
github_access_token: vn5o784vgo48v   # GitHub API access token
imgur_api_client_id: b38967d8200     # Imgur Client ID for anonymous uploads
slack_webhook_url: https://hooks.slack.com/services/BLAH  # Slack webhook URL
slack_channel: '#general'            # Slack channel
```

### Production

- Runs on a Raspberry Pi with the Piface I/O board.
- Green LED on relay output 0
- Yellow LED on relay output 1
- Momentary magnetic proximity switch on input 0
- [Enable SPI Pins](http://www.piface.org.uk/guides/Install_PiFace_Software/Enabling_SPI/)

