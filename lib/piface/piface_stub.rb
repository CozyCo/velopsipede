
class PifaceStub
  def write(_output_pin, _value)
    # puts "DEBUG: Setting pin #{output_pin} to #{value}"
  end

  def read(*)
    key_is_down = !getkey.nil?
    key_is_down ? 1 : 0
  end

  # Return the ASCII code last key pressed, or nil if none
  def getkey
    char = nil
    begin
      system('stty raw -echo') # => Raw mode, no echo
      char = (begin
                STDIN.read_nonblock(1).ord
              rescue
                nil
              end)
    ensure
      system('stty -raw echo') # => Reset terminal mode
    end
    char
  end
end
