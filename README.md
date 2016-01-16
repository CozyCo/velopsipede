Velopsipede/Picycle
===================

This is the code that powers the Velopsipede. The Velopsipede is a bicycle connected to a Raspberry Pi. It was born as a hack day project at Cozy.

The Velopsipede powers the deploy process for [Cozy's marketing website](https://cozy.co). When someone has changed the content on the QA/development branch of our site, and they wish to deploy those changes to the live production site, they can do so by riding the Velopsipede.

A successful ride of the Velopsipede triggers a merge of the `develop` branch to the `master` branch of the configured `github_repo`. It takes a picture of the rider and uploads it to Imgur. Finally, it posts a message to Slack with the details of the merged changes along with the rider photo.


### Development

#### Dependencies
- A ruby environment with `bundler`
- `dialog` unix tool. `brew install dialog` in OSX, should be installed on most unixen.

#### Usage

Create a config file at `~/.picycle.yml` containing keys:
```yaml
---
github_repo: myorg/myapp             # GitHub repo in which we will merge develop to master
github_access_token: vn5o784vgo48v   # GitHub API access token
imgur_api_client_id: b38967d8200     # Imgur Client ID for anonymous uploads
slack_webhook_url: https://hooks.slack.com/services/BLAH  # Slack webhook URL
slack_channel: '#general'            # Slack channel
```

```
bundle install --without piface # (for local development, obviously we need piface on the Pi)
bundle exec bin/picycle
```

### Production

- Runs on a Raspberry Pi with the Piface I/O board.
- Green LED on relay output 0
- Yellow LED on relay output 1
- Momentary magnetic proximity switch on input 0
- [Enable SPI Pins](http://www.piface.org.uk/guides/Install_PiFace_Software/Enabling_SPI/)

