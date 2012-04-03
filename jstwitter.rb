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
			input = gets.chomp
			sections = input.split(" ")
			command = sections[0]
			case command
				when 'q' then puts "Goodbye!"
				when 't' then twitterize(sections[1..-1].join(" "))
					puts "Message posted."
				when 'dm' then dm(sections[1], sections[2..-1].join(" "))
				when 'elt' then everyones_last_tweet
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

	def dm(recipient, message)
		puts "Trying to send #{recipient} this message:"
		puts message
		screen_name = @client.followers.collect{|follower| follower.screen_name}
		puts screen_name
		#Need to go back and do something to make case irrelevant
		if screen_name.include?(recipient) == true
			twitterize("d #{recipient} #{message}")
			puts "Direct message sent."
		else
			puts "Sorry, you can only DM people who are following you."
		end
	end

	def followers_list
		screen_names = []
		# Can you also do screen_names = Array.new ?
		your_followers = @client.followers
		your_followers.each do |follower|
			screen_names << followers["screen_names"]
		#WHAT THE FUCK???
		end
	end

	def spam_my_followers
		#put shit here
	end

	def everyones_last_tweet
		friends = @client.friends
		friends.each do |friend|
			puts friend.screen_name
			last_tweets << friend.status.text
			puts ""
		end
	end

end

#Script
dude = JSTwit.new
#dude.twitterize("JSTwit Init")
dude.startup