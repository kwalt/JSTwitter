require 'jumpstart_auth'
require 'bitly'
require 'klout'

class JSTwit
	attr_reader :client

	def initialize
		puts "Initializing"
		@client = JumpstartAuth.twitter
		@k = Klout::API.new('6f2zva63qwtan3hgwvesa7b8')
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
				when 'spam' then spam_my_followers(sections[1..-1].join(" "))
				when 's' then make_short(sections[1..-1].join(" "))
				when 'turl' then twitterize(sections[1..-2].join(" ") + " "	+ make_short(sections[-1]))
				when 'k' then find_klout
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
		screen_names = @client.followers.collect{|follower| follower.screen_name}
		puts screen_names
		#Need to go back and do something to make case irrelevant
		if screen_names.include?(recipient) == true
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
			screen_names << follower[:screen_name] #Why is this symbol v string?
		end
		return screen_names
	end

	def spam_my_followers(message)
		list = followers_list
		list.each do |friend|
			dm(friend, message)
		end
	end

	def everyones_last_tweet
		friends = @client.friends.sort_by{|friend| friend.screen_name.downcase}
		#puts friends
		friends.each do |friend|
			timestamp = friend.status.created_at.strftime("%A, %b, %d")
			puts "#{friend.screen_name} said on #{timestamp}:"

			puts friend.status.text
			puts ""
		end
	end

	def make_short(url)
		puts "Shortening this URL: #{url}"
		input_test = url.split(" ")
		if input_test[1].nil?
			Bitly.use_api_version_3

			connex = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
			shortened = connex.shorten(url).short_url
			puts shortened
			return shortened
		else
			puts "Sorry, it appears you entered something more than just a URL. 
			Please check your input and try again."
		end
	end

	def find_klout
		puts "Friends' klout:"
		friend_list = @client.friends.collect{ |friend| friend.screen_name}
		friend_list.each do |friend|
			puts friend
			puts @k.klout(friend)["users"][0]["kscore"]
		end

		puts ""
		puts "Followers' klout:"
		followers_list.each do |follower|
			puts follower
			puts @k.klout(follower)["users"][0]["kscore"]
		end
	end

end

#Script
dude = JSTwit.new
#dude.twitterize("JSTwit Init")
dude.startup
#dude.followers_list
#dude.find_klout