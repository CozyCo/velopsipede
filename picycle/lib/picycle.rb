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

  def initialize(units_to_deploy = 100)
    @led = LED.new($piface)
    @deployer = Deployer.new($devmode)
    @units_to_deploy = units_to_deploy.to_i
    @tracker = Tracker.new( $piface, @led, @deployer, @units_to_deploy )
  end


  def run
    @led.reset
    at_exit do
      @led.reset
    end
    puts @tracker.status_message
    loop do
      @tracker.process_frame
      sleep 0.001
    end
  end

end
