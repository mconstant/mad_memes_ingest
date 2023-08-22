require 'discordrb'
require 'google_drive'

puts "Declaring empty messages_array"
messages_array = nil

puts "Step 1: Discord Bot gets the messages in the #Memes channel..."
begin
  puts "Instantiating Bot"
  bot = Discordrb::Bot.new token: ENV['BOT_TOKEN']

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
    messages_array = Discordrb::Paginator.new(nil, :up) do |last_page|
      if last_page && last_page.count < 100  
        []
      else  
        channel.history(100, last_page&.sort_by(&:id)&.first&.id)    
      end  
    end.to_a.map { |message| {author: message.author.display_name, content: message.content, attachments: message.attachments.map(&:url)} }

    Discordrb::LOGGER.info("Printing messages array:")
    Discordrb::LOGGER.info(messages_array.join("\n"))

    bot.stop
  end

  bot.run
rescue Exception => e
  puts "had to rescue!"
  puts "Exception:\n#{e.backtrace.join("\n")}"
end

puts "Step 2: yeet everything to sheets"
# Load credentials from environment variables
client_id = ENV['GOOGLE_CLIENT_ID']
client_secret = ENV['GOOGLE_CLIENT_SECRET']

# Authenticate and create a session
session = GoogleDrive::Session.from_credentials(client_id, client_secret, refresh_token)

# Use the session to interact with Google Sheets API
# For example, you can access a spreadsheet
spreadsheet = session.spreadsheet_by_title("mad_memes_ingest_v0.0.1")
worksheet = spreadsheet.worksheets[0]
puts worksheet.title

worksheet.insert_rows(0, [["Author", "Content", "Attachments"]])

messages_array.each_with_index do |row, idx|
  worksheet.insert_rows((idx+1), [[row[:author], row[:content], row[:attachments]])
end

worksheet.save


