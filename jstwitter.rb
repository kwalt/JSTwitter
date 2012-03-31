require 'jumpstart_auth'

class JSTwit
	attr_reader :client

	def initialize
		puts "Initializing"
		@client = JumpstartAuth.twitter
	end

	def startup
		puts "Welcome to the JSL Twitter Client, good sir!"
		command = ""
		while command != "q"
			printf("enter a command: ")
			command = gets.chomp
			case command
				when 'q' then puts "Goodbye!"
				else
					puts "Sorry bro, I don't know how to do #{command}"
				end
		end
	end

	def twitterize(message)

		if message.length <= 140
			@client.update(message)
		else
			puts "Keep your tweet under 140 characters, please!"
		end
	end

end



#Script
dude = JSTwit.new
#dude.twitterize("JSTwit Init")
dude.startup