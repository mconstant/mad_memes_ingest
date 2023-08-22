require 'discordrb'

bot = Discordrb::Bot.new token: ENV['BOT_TOKEN']

messages_array = []
bot.ready do |event|
  bot.on do |interaction|
    interaction.member.fetch

    # Get a channel by its ID (replace 'CHANNEL_ID' with your channel's ID)
    channel = bot.channel('837474873818349579')

    # Get the last 100 messages from the channel
    messages = channel.history(100)

    # Store the text of each message in the array
    messages.each do |message|
      messages_array << message.content
    end

    print messages_array
  end
end

bot.run


