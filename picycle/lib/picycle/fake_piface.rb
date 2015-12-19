# A fake Piface stub for non-Pi development
class Piface

	def self::write(output_pin, value)
		puts "Piface: set output pin #{output_pin} to #{value}"
	end

	def self::read(input_pin)
		puts "Piface: reading input pin #{input_pin}"
	end

end
