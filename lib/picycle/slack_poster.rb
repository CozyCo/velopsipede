require 'slack-post'

module Picycle
  class SlackPoster
    def initialize(dryrun, config)
      @dryrun = dryrun
      @config = config

      unless dryrun
        %w( slack_webhook_url slack_channel ).each do |required_config_key|
          fail "#{required_config_key} is not set" unless @config.key?(required_config_key)
        end
        Slack::Post.configure(
          webhook_url: @config['slack_webhook_url'],
          username: 'Velopsipede'
        )
      end
    end

    def post(message, image_url)
      attachments = [{
        fallback: message,
        text: message,
        image_url: image_url
      }]
      Slack::Post.post_with_attachments('', attachments, @config['slack_channel']) unless @dryrun
    end
  end
end
