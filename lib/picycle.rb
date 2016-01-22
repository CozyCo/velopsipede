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
  LOOP_INTERVAL = $devmode ? 0.01 : 0.001 # human keypresses are slower than bike wheels

  CONFIG_FILE = File.join(File.expand_path('~'), '.picycle.yml')
  CONFIG = YAML.load_file(CONFIG_FILE)

  DISTANCE_CHOICES = [
    [0.1, 'Sprint'],
    [0.5, 'Long Ride'],
    [1.0, 'Century'],
    [10.0, 'Gino'],
    [100.0, 'Starla']
  ]

  WELCOME_MESSAGE = "Welcome to the Velopsipede!\n\nCompleting a ride will trigger a merge of develop branch to master branch of the marketing-jekyll repository.\n\nThis will trigger a production deploy of the marketing site.\n\nChoose your ride distance (km):"
  RIDE_COMPLETED_MESSAGE = "Congratulations, you completed your ride.\n\nSmile for the camera!"
  MERGE_PENDING_MESSAGE = 'Thanks! Performing the merge action now. Hold tight for just a couple seconds.'
  MERGE_SUCCEEDED_MESSAGE = "OK, done! Your changes have been merged and a production deploy of the marketing site should start momentarily.\n\nThanks for riding the Velopsipede!"
  MERGE_NOOP_MESSAGE = "Hrmm, didn't find any new changes on the develop branch of the marketing repo, so there's nothing to merge.\n\nThanks for riding the Velopsipede!"
  IDLE_TIMEOUT_MESSAGE = 'Aww, you were idle too long, so we cancelled your ride. Press Enter or just wait it out, and the Velopsipede will restart.'

  module_function

  def slack_message(distance, merge_succeeded, compare_url)
    if merge_succeeded
      "Someone completed a #{distance}km ride on the Velopsipede! They merged <#{url}|these changes> to the production branch of the marketing repo, and a deploy should happen momentarily."
    else
      "Someone completed a #{distance}km ride on the Velopsipede, but there weren't any changes to merge, so their effort was for naught. Here's their picture anyway."
    end
  end

  def play_game
    camera = Camera.new($devmode, CONFIG)
    deployer = Deployer.new($devmode, CONFIG)
    led = LED.new($piface)
    slack = SlackPoster.new($devmode, CONFIG)
    ui = UI.new

    chosen_distance = ui.menubox(WELCOME_MESSAGE, DISTANCE_CHOICES)
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
      ui.pausebox(RIDE_COMPLETED_MESSAGE, 3)
      ui.infobox(MERGE_PENDING_MESSAGE)

      camera.take_photo
      camera.upload_photo

      merge_succeeded = deployer.merge
      ui_message = merge_succeeded ? MERGE_SUCCEEDED_MESSAGE : MERGE_NOOP_MESSAGE

      slack.post(slack_message(chosen_distance, merge_succeeded, deployer.github_compare_url), camera.photo_url)
      ui.pausebox(ui_message)
    else
      ui.pausebox(IDLE_TIMEOUT_MESSAGE)
    end

  ensure
    led.reset unless led.nil?
  end

  def run
    loop do
      play_game
    end
  end
end
