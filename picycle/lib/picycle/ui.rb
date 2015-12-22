require 'mrdialog'

class UI

  attr_accessor :dialog

  def initialize
    @dialog = MRDialog.new
    @dialog.title = 'Velopsipede'
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

    height = 0
    width = 0
    menu_height = items.length

    return @dialog.menu(text, items, height, width, menu_height)
  end

  # Yes, dialog gauges really do use 'XXX' as a delimiter
  # http://www.rubydoc.info/gems/mrdialog/1.0.1/MRDialog%3Agauge
  def update_gauge(gauge, percent, message)
    gauge.puts "XXX"
    gauge.puts percent
    gauge.puts message
    gauge.puts "XXX"
  end

end
