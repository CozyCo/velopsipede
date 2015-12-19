module GetKey
	# Return the ASCII code last key pressed, or nil if none
	#
	# Return::
	# * _Integer_: ASCII code of the last key pressed, or nil if none
	def self.getkey
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