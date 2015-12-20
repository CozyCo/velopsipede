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

  LOOP_INTERVAL = $devmode ? 0.01 : 0.001  # human keypresses are slower than bike wheels

  module_function

  def run
    led = LED.new($piface)
    deployer = Deployer.new($devmode)
    ui = UI.new
    tracker = Tracker.new($piface, led, ui.get_distance)

    led.reset

    ui.dialog.gauge(tracker.message, 10, 80, 0) do |gauge|
      loop do
        revolving = tracker.process_interval
        ui.update_gauge(gauge, tracker.percent_complete, tracker.message)
        sleep LOOP_INTERVAL
        break unless revolving
      end
    end

    # TODO: A success screen or something, and then a way to start all over again.
    if tracker.succeeded
      deployer.deploy
      deployer.take_photo
    else
      puts "Sorry, you were idle for too long. Aborting."
    end

  ensure
    led.reset
  end

end
