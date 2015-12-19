class PifaceStub

  def write(output_pin, value)
    puts "DEBUG: Setting pin #{output_pin} to #{value}"
  end

  def read(*)
    key_is_down = self.getkey != nil
    return key_is_down ? 1 : 0
  end

  # Return the ASCII code last key pressed, or nil if none
  def getkey
    char = nil
    begin
      system('stty raw -echo') # => Raw mode, no echo
      char = (STDIN.read_nonblock(1).ord rescue nil)
    ensure
      system('stty -raw echo') # => Reset terminal mode
    end
    return char
  end

end
