require 'mrdialog'

module Picycle
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

    def menubox(message, items)
      @dialog.menu(message, items, DEFAULT_DIALOG_HEIGHT, DEFAULT_DIALOG_WIDTH, items.length)
    end

    def infobox(message)
      @dialog.infobox(message, DEFAULT_DIALOG_HEIGHT, DEFAULT_DIALOG_WIDTH)
    end

    def pausebox(message, delay = 10)
      @dialog.pause(message, DEFAULT_DIALOG_HEIGHT, DEFAULT_DIALOG_WIDTH, delay)
    end

    # Yes, dialog gauges really do use 'XXX' as a delimiter
    # http://www.rubydoc.info/gems/mrdialog/1.0.1/MRDialog%3Agauge
    def update_gauge(gauge, percent, message)
      if Time.now - @last_ui_update_time > MIN_UI_UPDATE_INTERVAL || percent == 100
        @last_ui_update_time = Time.now
        gauge.puts 'XXX'
        gauge.puts percent
        gauge.puts message
        gauge.puts 'XXX'
      end
    end
  end
end
