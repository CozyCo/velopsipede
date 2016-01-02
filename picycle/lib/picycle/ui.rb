require 'mrdialog'

class UI
  attr_accessor :dialog
  MIN_UI_UPDATE_INTERVAL = 0.1

  DEFAULT_DIALOG_WIDTH = 80
  DEFAULT_DIALOG_HEIGHT = 20

  def initialize
    @dialog = MRDialog.new
    @dialog.title = 'Velopsipede'
    @dialog.nocancel = true
    @last_ui_update_time = Time.now
  end

  def get_distance
    text = <<EOF
Welcome to the Velopsipede!

Completing a ride will trigger a merge of develop branch to master branch of the marketing-jekyll repository.

This will trigger a production deploy of the marketing site.

Choose your ride distance (km):
EOF

    items = [
      [0.1, "Sprint"],
      [0.2, "Long Ride"],
      [0.5, "Century"],
      [1.0, "Gino"],
      [2.0, "Starla"]
    ]

    height = DEFAULT_DIALOG_HEIGHT
    width = DEFAULT_DIALOG_WIDTH
    menu_height = items.length

    return @dialog.menu(text, items, height, width, menu_height)
  end

  def infobox(message)
    return @dialog.infobox(message, DEFAULT_DIALOG_HEIGHT, DEFAULT_DIALOG_WIDTH)
  end

  def pausebox(message, delay=10)
    return @dialog.pause(message, DEFAULT_DIALOG_HEIGHT, DEFAULT_DIALOG_WIDTH, delay)
  end

  # Yes, dialog gauges really do use 'XXX' as a delimiter
  # http://www.rubydoc.info/gems/mrdialog/1.0.1/MRDialog%3Agauge
  def update_gauge(gauge, percent, message)
    if Time.now - @last_ui_update_time > MIN_UI_UPDATE_INTERVAL || percent == 100
      @last_ui_update_time = Time.now
      gauge.puts "XXX"
      gauge.puts percent
      gauge.puts message
      gauge.puts "XXX"
    end
  end

end
