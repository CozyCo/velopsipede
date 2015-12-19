class Picycle

	module LEDs

		PIFACE_GREEN_LED_RELAY_OUTPUT = 0
		PIFACE_YELLOW_LED_RELAY_OUTPUT = 1


		# Set an LED to a value (1 = on, 0 = off)
		def set_led_state(color, value)
			case color
			when 'green'
				::Piface.write(PIFACE_GREEN_LED_RELAY_OUTPUT, value)
			when'yellow'
				::Piface.write(PIFACE_YELLOW_LED_RELAY_OUTPUT, value)
			end
		end


		def turn_green_led_on
			set_led_state('green', 1)
		end

		def turn_green_led_off
			set_led_state('green', 0)
		end

		def turn_yellow_led_on
			set_led_state('yellow', 1)
		end

		def turn_yellow_led_off
			set_led_state('yellow', 0)
		end

	end

end