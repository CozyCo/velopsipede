require 'io/console'
require 'yaml'

begin
  # noinspection RubyResolve
  require 'piface'
  $piface = Piface
  $devmode = false
rescue LoadError
  require 'piface/piface_stub'
  $piface = PifaceStub.new
  $devmode = true
end

require 'picycle/camera'
require 'picycle/deployer'
require 'picycle/distance'
require 'picycle/led'
require 'picycle/slack_poster'
require 'picycle/tracker'
require 'picycle/ui'

module Picycle

  LOOP_INTERVAL = $devmode ? 0.01 : 0.001  # human keypresses are slower than bike wheels

  CONFIG_FILE = File.join(File.expand_path("~"), '.picycle.yml')
  CONFIG = YAML.load_file(CONFIG_FILE)

  DISTANCE_CHOICES = [
    [0.1, "Sprint"],
    [0.5, "Long Ride"],
    [1.0, "Century"],
    [10.0, "Gino"],
    [100.0, "Starla"]
  ]

  module_function

  def play_game
    camera = Camera.new($devmode, CONFIG)
    deployer = Deployer.new($devmode, CONFIG)
    led = LED.new($piface)
    slack = SlackPoster.new($devmode, CONFIG)
    ui = UI.new

    welcome_text = "Welcome to the Velopsipede!\n\nCompleting a ride will trigger a merge of develop branch to master branch of the marketing-jekyll repository.\n\nThis will trigger a production deploy of the marketing site.\n\nChoose your ride distance (km):"

    chosen_distance = ui.menubox(welcome_text, DISTANCE_CHOICES)
    exit if chosen_distance == false

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

    if tracker.succeeded?
      ui.pausebox("Congratulations, you completed at #{chosen_distance}km ride.\n\nSmile for the camera!", 3)
      ui.infobox("Thanks! Performing the merge action now. Hold tight for just a couple seconds.")
      camera.take_photo
      camera.upload_photo
      if deployer.merge
        ui_message = "OK, done! Your changes have been merged and a production deploy of the marketing site should start momentarily.\n\nThanks for riding the Velopsipede!"
        slack_message = "Someone completed a #{chosen_distance}km ride on the Velopsipede! They merged <#{deployer.github_compare_url}|these changes> to the production branch of the marketing repo, and a deploy should happen momentarily."
      else
        ui_message = "Hrmm, didn't find any new changes on the develop branch of the marketing repo, so there's nothing to merge.\n\nThanks for riding the Velopsipede!"
        slack_message = "Someone completed a #{chosen_distance}km ride on the Velopsipede, but there weren't any changes to merge, so their effort was for naught. Here's their picture anyway."
      end
      slack.post(slack_message, camera.photo_url)
      ui.pausebox(ui_message)
    else
      ui.pausebox("Aww, you were idle too long, so we cancelled your ride. Press Enter or just wait it out, and the Velopsipede will restart.")
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
