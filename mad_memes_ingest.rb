require 'discordrb'

bot = Discordrb::Bot.new token: 'MTE0Mjg3Mzk0Nzk0MDA3MzU3Mg.Gv0nZe.x6iLXDFjUrzSyjvkFdYLGFMcp_eqe4f5JHN444'

messages_array = []
bot.ready do |event|
  # Get a channel by its ID (replace 'CHANNEL_ID' with your channel's ID)
  channel = bot.channel('837474873818349579')

  # Get the last 100 messages from the channel
  messages = channel.history(100)

  # Store the text of each message in the array
  messages.each do |message|
    messages_array << message.content
  end
end

print messages_array

bot.run
