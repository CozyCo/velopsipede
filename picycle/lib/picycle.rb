require 'io/console'
require 'yaml'

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

require 'picycle/camera'
require 'picycle/deployer'
require 'picycle/distance'
require 'picycle/led'
require 'picycle/tracker'
require 'picycle/ui'

module Picycle

  LOOP_INTERVAL = $devmode ? 0.01 : 0.001  # human keypresses are slower than bike wheels

  CONFIG_FILE = File.join(File.expand_path("~"), '.picycle.yml')
  CONFIG = YAML.load_file(CONFIG_FILE)

  module_function

  def play_game
    camera = Camera.new($devmode, CONFIG)
    deployer = Deployer.new($devmode, CONFIG)
    led = LED.new($piface)
    ui = UI.new

    chosen_distance = ui.get_distance
    if chosen_distance == false
      puts "The bike will be ready when you are. Bye!"
      exit
    end

    tracker = Tracker.new($piface, led, chosen_distance.to_f)

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
    if tracker.succeeded?
      ui.pausebox("FPO: Congrats, taking your pic in a sec.", 3)
      deployer.take_photo
      ui.infobox("FPO: Triggering a deploy")
      ui.pausebox(deployer.deploy, 3)
      ui.pausebox("FPO: The game is complete. Press Enter to restart.")
    else
      ui.pausebox("FPO: You were idle too long.")
    end

  ensure
    led.reset unless led.nil?
  end

  def run
    while true
      play_game
    end
  end

end
