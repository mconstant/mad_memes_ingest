FROM ruby:slim-bullseye

ARG BOT_TOKEN
ARG SHEETS_TOKEN

RUN apt-get update
RUN apt-get install -y build-essential

ENV BOT_TOKEN=$BOT_TOKEN
ENV SHEETS_TOKEN=$SHEETS_TOKEN

COPY . .

RUN bundle

RUN bundle exec ruby mad_memes_ingest.rb