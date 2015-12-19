require 'net/http'
require 'aws-sdk'

begin
	require 'piface'
rescue LoadError
	puts 'Could not load piface library. Run with argument "devmode" to use fake_piface stub'
end

class Picycle
	require 'picycle/leds'
	include Picycle::LEDs

	# Max time in seconds between clicks, we reset the click count to 0 if exceeded
	CLICK_TIMEOUT = 5

	# The number of clicks needed to win
	NUM_CLICKS_TO_WIN = 100

	# Magnet input pin on the Piface
	PIFACE_MAGNET_INPUT = 0


	attr_accessor :last_click_time, :num_clicks, :last_magnet_state, :loop_timer_seconds, :devmode


	def initialize(devmode = false)
		@devmode = devmode

		@last_click_time = Time.now
		@num_clicks = 0
		@last_magnet_state = 0
		@loop_timer_seconds = @devmode ? 0.2: 0.001

		# Load a Piface stub that logs pin status and accepts keyboard input, if we are devmode.
		require 'picycle/fake_piface' if @devmode

		# Ensure LEDs are turned off, in case the program exited abnormally last time
		turn_green_led_off
		turn_yellow_led_off
	end


	def click
		restart if @last_click_time < (Time.now - CLICK_TIMEOUT)
		@num_clicks += 1
		@last_click_time = Time.now
		puts @num_clicks
		win if @num_clicks == NUM_CLICKS_TO_WIN
	end


	def restart
		@num_clicks = 0
		puts "Starting, you must click at least once every #{CLICK_TIMEOUT} seconds"
		turn_green_led_off
	end


	def win
		puts "You did it! Smile for the camera, it's deploy time!"
		turn_green_led_on
		do_derpler unless @devmode
		capture_portrait unless @devmode
	end


	def do_derpler
		uri = URI('http://ci.int.cozy.co/go/api/pipelines/velopsipede/schedule')
		http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Post.new(uri.request_uri)
		response = http.request(request)
	end


	def capture_portrait
		filename = "/home/pi/photos/pederplerer-#{Time.now.to_i}.jpg"
		`fswebcam -r 1280x720 --no-banner #{filename}`

		#s3 = Aws::S3::Resource.new(region:'us-west-2')
		#obj = s3.bucket('bikeface').object(filename)
		#obj.upload_file(filename, {:acl => 'public-read'})
	end


	def check_button
		state = Piface.read(PIFACE_MAGNET_INPUT)
		if @last_magnet_state != state
			if state == 1
				click
				sleep 0.02
				if @num_clicks % 2 == 0
					turn_yellow_led_on
				else
					turn_yellow_led_off
				end
			end
		end
		@last_magnet_state = state
	end


	def run
		loop do
			check_button
			sleep @loop_timer_seconds
		end

		at_exit do
			turn_green_led_off
			turn_yellow_led_off
		end
	end

end
