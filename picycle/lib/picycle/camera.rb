require 'rest-client'

class Camera

  PHOTO_STORAGE_DIR = '~/picycle_photos'

  def initialize(dryrun)
    @dryrun = dryrun

    unless dryrun
      %w( IMGUR_API_CLIENT_ID ).each do |required_env_var|
        fail "#{required_env_var} is not set" if ENV[required_env_var].nil?
      end
    end

    def take_photo
      time = Time.now.strftime('%Y-%m-%d_%H-%M-%S')
      filename = File.join(File.expand_path(PHOTO_STORAGE_DIR), "deploy-#{time}.jpg")
      if @dryrun
        @photo_file = nil
        return "Would take a photo saved to #{filename}"
      else
        @photo_file = `fswebcam -r 1280x720 --no-banner #{filename} 2<&1`
        return "Saved photo to #{@photo_file}"
      end
    end

    def upload_photo
      if @dryrun
        @photo_url = "Would upload #{@photo_file} to Imgur."
      else
        response = RestClient.post( "https://api.imgur.com/3/image",
          { image: Base64.encode64(File.read(@photo_file) },
          { Authorization: "Client-ID #{ENV['IMGUR_API_CLIENT_ID']}" }
        )
        @photo_url = JSON.parse(response)['data']['link']
      end
      return @photo_url
    end

  end
  