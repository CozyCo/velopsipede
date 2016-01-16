require 'rest-client'

module Picycle
  class Camera

    PHOTO_STORAGE_DIR = '~/picycle_photos'
    CAMERA_LOG = '~/fswebcam.log'

    attr_reader :photo_url

    def initialize(dryrun, config)
      @dryrun = dryrun
      @config = config

      unless dryrun
        %w( imgur_api_client_id ).each do |required_config_key|
          fail "#{required_config_key} is not set" unless @config.key?(required_config_key)
        end
      end
    end

    def take_photo
      time = Time.now.strftime('%Y-%m-%d_%H-%M-%S')
      @photo_file = File.join(File.expand_path(PHOTO_STORAGE_DIR), "deploy-#{time}.jpg")
      if @dryrun
        return "Would take a photo saved to #{@photo_file}"
      else
        `fswebcam -r 1024x768 -p YUYV -S3 --no-banner #{@photo_file} >> #{CAMERA_LOG} 2<&1`
        return "Saved photo to #{@photo_file}"
      end
    end

    def upload_photo
      if @dryrun
        @photo_url = "Would upload #{@photo_file} to Imgur."
      else
        response = RestClient.post( "https://api.imgur.com/3/image",
          { image: Base64.encode64(File.read(@photo_file)) },
          { Authorization: "Client-ID #{@config['imgur_api_client_id']}" }
        )
        @photo_url = JSON.parse(response)['data']['link']
      end
      return @photo_url
    end

  end
end