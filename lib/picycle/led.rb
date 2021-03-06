module Picycle
  class LED
    NAME_TO_PIN_NUMBER = {
      success: 0, # green LED
      inprogress: 1 # yellow LED
    }

    def initialize(piface)
      @piface = piface
    end

    def set(name, value)
      pin = NAME_TO_PIN_NUMBER[name]
      @piface.write(pin, value)
    end

    def enable(name)
      set(name, 1)
    end

    def disable(name)
      set(name, 0)
    end

    def reset
      NAME_TO_PIN_NUMBER.keys.each do |name|
        disable(name)
      end
    end
  end
end
