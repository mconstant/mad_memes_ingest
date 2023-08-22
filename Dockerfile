FROM ruby:slim-bullseye

ARG BOT_TOKEN
ARG SHEETS_TOKEN

RUN apt-get update
RUN apt-get install -y build-essential bash

ENV BOT_TOKEN=$BOT_TOKEN
ENV SHEETS_TOKEN=$SHEETS_TOKEN

COPY . .

RUN bundle

RUN chmod +x entrypoint.sh

ENTRYPOINT [ "entrypoint.sh" ]