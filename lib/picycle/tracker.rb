require 'picycle/distance'

module Picycle
  class Tracker

    # Max time between revolutions, abort the ride if exceeded
    TIMEOUT = 30

    def initialize( piface, led, km_to_deploy )
      @piface = piface
      @led = led
      @distance = Distance.new(km_to_deploy)
      @last_button_state = 0
      @last_revolution_time = Time.now
      @succeeded = false
    end

    # Main event loop while riding. Returns true while the ride
    # is in progress, false if the ride has succeeded or timed out.
    def process_interval
      timed_out = @last_revolution_time < (Time.now - TIMEOUT)
      return false if timed_out

      state = @piface.read(0)
      if @last_button_state != state
        if state == 1
          self.revolve
          #sleep 0.02 #for button debounce, maybe not needed
        end
      end
      @last_button_state = state

      return false if @succeeded
      return true
    end

    def revolve
      unless @succeeded
        @distance.revolve
        if @distance.finished?
          self.succeed
        else
          @led.set(:inprogress, @distance.current_rev % 2)
        end
      end
      @last_revolution_time = Time.now
    end

    def succeed
      @succeeded = true
      @led.enable(:success)
    end

    def succeeded?
      @succeeded
    end

    def message
      return @distance.message
    end

    def percent_complete
      return @distance.percent_complete
    end

  end
end
