require 'net/http'
require 'io/console'
require 'aws-sdk'

begin
  # noinspection RubyResolve
  require 'piface'
  $piface = Piface
  $devmode = false
rescue LoadError
  require 'picycle/piface_stub'
  $piface = PifaceStub.new
  $devmode = true
end

require 'picycle/deployer'
require 'picycle/led'
require 'picycle/tracker'

class Picycle

  def initialize(km_to_deploy = 0.1)
    @led = LED.new($piface)
    @deployer = Deployer.new($devmode)
    @tracker = Tracker.new($piface, @led, @deployer, km_to_deploy)
  end


  def run
    @led.reset
    at_exit do
      @led.reset
    end
    puts @tracker.message
    loop do
      @tracker.process_frame
      sleep 0.001
    end
  end

end
