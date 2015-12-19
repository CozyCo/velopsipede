require 'mrdialog'

class UI

  def initialize
  end

  def get_distance
    dialog = MRDialog.new
    text = "Welcome to the Velopsipede! Choose your ride duration:"
    items = [
      [100, "Sprint"],
      [200, "Long Ride"],
      [500, "Century"],
      [1000, "Gino"]]

    height = 0
    width = 0
    menu_height = 4
  
    return dialog.menu(text, items, height, width, menu_height).to_i
  end

end
