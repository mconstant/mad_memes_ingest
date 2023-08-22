FROM ruby:slim-bullseye

ARG BOT_TOKEN
ARG GOOGLE_SHEETS_JSON

RUN apt-get update
RUN apt-get install -y build-essential bash libsodium-dev

ENV BOT_TOKEN=$BOT_TOKEN
ENV GOOGLE_SHEETS_JSON=$GOOGLE_SHEETS_JSON

RUN echo $GOOGLE_SHEETS_JSON

COPY --from=gcr.io/oauth2l/oauth2l /bin/oauth2l /bin/oauth2l

COPY . .

RUN bundle

RUN chmod +x ./entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]