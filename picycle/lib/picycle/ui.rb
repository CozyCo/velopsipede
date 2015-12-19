require 'mrdialog'

class UI

  def initialize
    @title = 'Velopsipede'
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

    dialog = MRDialog.new
    dialog.title = @title
    return dialog.menu(text, items, height, width, menu_height).to_f
  end

end
