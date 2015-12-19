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

module Picycle

  module_function

  def run
    led = LED.new($piface)
    deployer = Deployer.new($devmode)
    ui = UI.new
    tracker = Tracker.new( $piface, led, deployer, ui.get_distance )

    led.reset
    puts tracker.message

    loop do
      tracker.process_frame
      sleep 0.001
    end

  ensure
    led.reset
  end

end
