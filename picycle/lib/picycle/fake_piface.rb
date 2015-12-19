# A fake Piface stub for non-Pi development

require 'picycle/getkey'

class Piface

	def self::write(output_pin, value)
		puts "Piface: set output pin #{output_pin} to #{value}"
	end

	def self::read(input_pin)
		key_was_pressed_during_loop = GetKey.getkey != nil
		puts "Piface: reading keyboard instead of input pin #{input_pin}: a key was #{key_was_pressed_during_loop ? '' : 'NOT '}pressed."
  	return key_was_pressed_during_loop ? 1 : 0
	end

end
