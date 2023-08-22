require 'discordrb'

begin
  puts "Instantiating Bot"
  bot = Discordrb::Bot.new token: ENV['BOT_TOKEN']

  puts "Declaring empty messages_array"
  messages_array = []

  puts "Entering bot.ready block"
  bot.ready do |event|
    Discordrb::LOGGER.info("In bot.ready block")
    Discordrb::LOGGER.info("Entering bot.on block")
    bot.on do |interaction|
      Discordrb::LOGGER.info("In bot.on block")
      Discordrb::LOGGER.info("Getting Bot Member")
      interaction.member.fetch

      # Get a channel by its ID (replace 'CHANNEL_ID' with your channel's ID)
      Discordrb::LOGGER.info("Loading Memes Channel...")
      channel = bot.channel('837474873818349579')

      Discordrb::LOGGER.info("Getting message content")
      # Get the last 100 messages from the channel
      messages = channel.history(100)

      Discordrb::LOGGER.info("Loading Message content into array")
      # Store the text of each message in the array
      messages.each do |message|
        messages_array << message.content
      end

      Discordrb::LOGGER.info("Printing messages array:")
      Discordrb::LOGGER.info(messages_array.join("\n"))
    end
  end

  bot.run
rescue Exception => e
  puts "had to rescue!"
  puts "Exception:\n#{e.backtrace.join("\n")}"
end


