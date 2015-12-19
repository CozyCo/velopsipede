
class Tracker

  # Max time between clicks, reset the count to 0 if exceeded
  TIMEOUT = 5

  def initialize( piface, led, deployer, revs_to_deploy )
    @piface = piface
    @led = led
    @deployer = deployer
    @revs_to_deploy = revs_to_deploy
    @last_button_state = 0
    @click_count = 0
    @last_click_time = Time.now
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
    else
      @click_count += 1
      puts self.status_message
      if @click_count < @revs_to_deploy
        @led.set(:inprogress, @click_count % 2)
      elsif @click_count == @revs_to_deploy
        self.succeed
      end
    end
    @last_click_time = Time.now
  end

  def restart
    @click_count = 0
    @led.reset
  end

  def succeed
    @led.enable(:success)
    @deployer.deploy
    @deployer.take_photo
  end


  def status_message
    if @click_count == 0
      return "Let's do this! You have to go #{@revs_to_deploy} revolutions to deploy."
    end
    if @revs_to_deploy - @click_count == 0
      return "You've done it! A deploy is on its way."
    end
    if @revs_to_deploy - @click_count < 0
      return nil
    end
    if @click_count % 5 == 0
      return "You've gone #{@click_count} revs, #{@revs_to_deploy - @click_count} to go."
    end
    return nil
  end
end