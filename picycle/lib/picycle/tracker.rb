require 'picycle/distance'


class Tracker

  # Max time between clicks, reset the count to 0 if exceeded
  TIMEOUT = 5

  def initialize( piface, led, deployer, km_to_deploy )
    @piface = piface
    @led = led
    @deployer = deployer
    @distance = Distance.new(km_to_deploy)
    @last_button_state = 0
    @last_click_time = Time.now
    @succeeded = false
  end

  def process_frame
    state = @piface.read(0)
    if @last_button_state != state
      if state == 1
        self.click
        sleep 0.02
      end
    end
    @last_button_state = state
  end

  def click
    if @last_click_time < (Time.now - TIMEOUT)
      self.restart
      puts "Restarting. You must revolve at least once every #{TIMEOUT} seconds."
    elsif @succeeded
      # noop
    else
      @distance.revolve
      puts @distance.message
      if @distance.finished?
        self.succeed
      else
        @led.set(:inprogress, @distance.current_rev % 2)
      end
    end
    @last_click_time = Time.now
  end

  def restart
    @succeeded = false
    @distance.reset
    @led.reset
  end

  def succeed
    @succeeded = true
    @led.enable(:success)
    @deployer.deploy
    @deployer.take_photo
  end

  def message
    return @distance.message
  end

end
