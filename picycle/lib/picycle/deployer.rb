
class Deployer

  def initialize(dryrun)
    @dryrun = dryrun
  end

  def deploy
    uri = URI('http://ci.int.cozy.co/go/api/pipelines/velopsipede/schedule')
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    if @dryrun
      puts "Would deploy to #{uri.to_s}"
    else
      http.request(request)
    end
  end


  def take_photo
    time = Time.now.strftime('%Y-%m-%d_%H-%M-%S')
    filename = "/home/pi/photos/pederplerer-#{time}.jpg"
    if @dryrun
      puts "Would take a photo saved to #{filename}"
    else
      `fswebcam -r 1280x720 --no-banner #{filename}`
    end

#  s3 = Aws::S3::Resource.new(region:'us-west-2')
#  obj = s3.bucket('bikeface').object(filename)
#  obj.upload_file(filename, {:acl => 'public-read'})
  end

end
