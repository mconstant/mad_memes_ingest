require 'discordrb'

begin
  puts "Instantiating Bot"
  bot = Discordrb::Bot.new token: ENV['BOT_TOKEN']

  puts "Declaring empty messages_array"
  messages_array = []

  puts "Entering bot.ready block"
  bot.ready do |event|
    puts "In bot.ready block"
    puts "Entering bot.on block"
    bot.on do |interaction|
      puts "In bot.on block"
      puts "Getting Bot Member"
      interaction.member.fetch

      # Get a channel by its ID (replace 'CHANNEL_ID' with your channel's ID)
      puts "Loading Memes Channel..."
      channel = bot.channel('837474873818349579')

      puts "Getting message content"
      # Get the last 100 messages from the channel
      messages = channel.history(100)

      puts "Loading Message content into array"
      # Store the text of each message in the array
      messages.each do |message|
        messages_array << message.content
      end

      puts "printing out message content"
      puts "printing messages array:"
      print messages_array
    end
  end

  bot.run
rescue Exception => e
  puts "had to rescue!"
  puts "Exception:\n#{e.backtrace.join("\n")}"
end


