FROM ruby:slim-bullseye

ARG BOT_TOKEN
ARG GOOGLE_CLIENT_ID
ARG GOOGLE_CLIENT_SECRET

RUN apt-get update
RUN apt-get install -y build-essential bash libsodium-dev

ENV BOT_TOKEN=$BOT_TOKEN
ENV GOOGLE_CLIENT_ID=$GOOGLE_CLIENT_ID
ENV GOOGLE_CLIENT_SECRET=$GOOGLE_CLIENT_SECRET

COPY . .

RUN bundle

RUN chmod +x ./entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]