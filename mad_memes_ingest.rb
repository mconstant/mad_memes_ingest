require 'discordrb'

bot = Discordrb::Bot.new token: 'MTE0Mjg3Mzk0Nzk0MDA3MzU3Mg.Gv0nZe.x6iLXDFjUrzSyjvkFdYLGFMcp_eqe4f5JHN444'

bot.message(with_text: 'Ping!') do |event|
  event.respond 'Pong!'
end

bot.run
