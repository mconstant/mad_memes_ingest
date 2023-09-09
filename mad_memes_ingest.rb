require 'bundler'
Bundler.require

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
    end.to_a.map { |message| {timestamp: message.timestamp.strftime("%Y%jT%H%MZ"), author: message.author.display_name, content: message.content, attachments: message.attachments.map { |attachment| "=IMAGE(\"#{attachment.url}\")"}} }

    messages_array = messages_array.reject {|message| message[:attachments].nil? || message[:attachments].empty? }

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
refresh_token = ENV['GOOGLE_REFRESH_TOKEN']

# Authenticate and create a session
puts "getting Google Drive Session"
begin
  session = GoogleDrive::Session.from_service_account_key("google_sheets.json")
rescue Exception => e
  puts e.backtrace.join("\n")
end

# Use the session to interact with Google Sheets API
# For example, you can access a spreadsheet
puts "Loading Spreadsheet"

spreadsheet = session.spreadsheet_by_title("madmemes0")
puts "Loading Worksheet"
worksheet = spreadsheet.worksheets[0]
puts worksheet.title

worksheet.insert_rows(1, [["Timestamp", "Author", "Rarity Number", "Rareness Class", "Content", "Attachments"]])

memes_count =  0
messages_array.each do |row|
  row[:attachments].each do |attachment|
    memes_count += 1
  end
end

puts "memes count is #{memes_count}"

# Example: Set the max rarity number (n)
n = memes_count + 1000

tiers = 5
r = (1.0 / tiers) ** (0.38)

thresholds = []
current_threshold = 1.0

tiers.times do
  thresholds << current_threshold
  current_threshold *= r
end

thresholds = thresholds.map {|thresh| thresh * n}.reverse

def categorize_rarity(rarity, thresholds)
  case
  when rarity < thresholds[0]
    "Legendary"
  when rarity < thresholds[1]
    "Epic"
  when rarity < thresholds[2]
    "Rare"
  when rarity < thresholds[3]
    "Uncommon"
  else
    "Common"
  end
end

puts "Thresholds:"
print thresholds
puts

# Test with sample rarities
sample_rarities = [1, 50, 120, 200, 500, 1200, 1500]

sample_rarities.each do |rarity|
  category = categorize_rarity(rarity, thresholds)
  puts "Rarity #{rarity} belongs to #{category} category."
end

rarity_bag = (1..(memes_count+1000)).to_a.shuffle

pick_count = 0
messages_array.each_with_index do |row, idx|
  row[:attachments].each do |attachment|
    rarity = rarity_bag.pop
    pick_count += 1
    puts "randomly selected rarity is #{rarity}"
    category = categorize_rarity(rarity, thresholds)
    worksheet.insert_rows((idx+2), [[row[:timestamp], row[:author], rarity_bag.pop, category, row[:content], attachment]])
  end
end

puts "would have picked #{pick_count} times from a bag of size #{(1..memes_count+1).to_a.shuffle.count}"

worksheet.save


