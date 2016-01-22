module Picycle
  class Distance
    CM_PER_REV = 189 # Tire circumference

    attr_reader :current_rev

    def initialize(goal_km)
      @current_rev = 0
      @target_km = goal_km
    end

    def cm2km(cm)
      cm / 100.0 / 1000.0
    end

    def km2cm(km)
      km * 1000.0 * 100.0
    end

    def revolve
      @current_rev += 1
    end

    def km_traveled
      cm2km(@current_rev * CM_PER_REV)
    end

    def km_left
      @target_km - km_traveled
    end

    def percent_complete
      ((km_traveled / @target_km) * 100).to_i
    end

    def at_start?
      km_traveled == 0
    end

    def finished?
      km_left <= 0
    end

    def message
      if self.at_start?
        return "Let's do this! You have to go #{km_left}km to deploy."
      end
      return "You've done it! A deploy is on its way." if self.finished?

      "You've gone %.3fkm, %.3fkm to go." % [km_traveled, km_left]
    end
  end
end
