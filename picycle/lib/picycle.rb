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
require 'picycle/distance'
require 'picycle/led'
require 'picycle/tracker'
require 'picycle/ui'

class Picycle

  def initialize
    @led = LED.new($piface)
    @deployer = Deployer.new($devmode)
    @tracker = Tracker.new( $piface, @led, @deployer )
  end


  def run
    @led.reset
    at_exit do
      @led.reset
    end

    @tracker.km_to_deploy = UI.new.get_distance
    puts @tracker.message

    loop do
      @tracker.process_frame
      sleep 0.001
    end

  end

end
