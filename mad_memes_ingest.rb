require 'discordrb'

begin
  puts "Instantiating Bot"
  bot = Discordrb::Bot.new token: ENV['BOT_TOKEN']

  puts "Declaring empty messages_array"
  messages_array = []

  puts "Entering bot.ready block"
  bot.ready do |event|
    Discordrb::LOGGER.info("In bot.ready block")

    # Get a channel by its ID (replace 'CHANNEL_ID' with your channel's ID)
    Discordrb::LOGGER.info("Loading Memes Channel...")
    channel = bot.channel('837474873818349579')

    Discordrb::LOGGER.info("Getting message count")
    # Get Message Count
    message_count = channel.message_count
    Discordrb::LOGGER.info("The channel has #{message_count} messages.")

    Discordrb::LOGGER.info("Getting message content")
    messages_array << Discordrb::Paginator.new(nil, :up) do |last_page|
      if last_page && last_page.count < 100  
        []
      else  
        channel.history(100, last_page&.sort_by(&:id)&.first&.id)    
      end  
    end.to_a.map { |message| {author: message.author.display_name, content: message.content, attachments: message.attachments.data} }

    messages_array.flatten!

    Discordrb::LOGGER.info("Printing messages array:")
    Discordrb::LOGGER.info(messages_array.join("\n"))

    bot.stop
  end

  bot.run
rescue Exception => e
  puts "had to rescue!"
  puts "Exception:\n#{e.backtrace.join("\n")}"
end


