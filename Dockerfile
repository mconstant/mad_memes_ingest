ARG  BOT_TOKEN

FROM ruby:slim-bullseye

ENV BOT_TOKEN=$BOT_TOKEN

RUN bundle

RUN bundle exec ruby mad_memes_ingest.rb