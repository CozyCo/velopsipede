
def cm2km(cm)
  return cm / 100.0 / 1000.0
end


def km2cm(km)
  return km * 1000.0 * 100.0
end


class Distance

  CM_PER_REV = 189 # Tire circumference

  REVS_BETWEEN_PROGRESS = 10

  attr_reader :current_rev

  def initialize(goal_km)
    @current_rev = 0
    @target_km = goal_km
  end

  def revolve
    @current_rev += 1
  end

  def reset
    @current_rev = 0
  end

  def km_traveled
    return cm2km(@current_rev * CM_PER_REV)
  end

  def km_left
    return @target_km - self.km_traveled
  end

  def at_start?
    return self.km_traveled == 0
  end

  def finished?
    return self.km_left <= 0
  end

  def message
    if self.at_start?
      return "Let's to this! You have to go #{self.km_left}km to deploy."
    end
    if self.finished?
      return "You've done it! A deploy is on its way."
    end
    if self.current_rev % REVS_BETWEEN_PROGRESS == 0
      return "You've gone #{self.km_traveled.round(3)}km, #{self.km_left.round(3)} to go."
    end
    return nil
  end

end