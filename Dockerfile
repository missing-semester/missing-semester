FROM ruby:2.7-alpine3.16
# GitHub is using Ruby 2.7 in production
# https://github.com/github/pages-gem/issues/752#issuecomment-764758292

RUN apk add --no-cache ruby-dev alpine-sdk

RUN mkdir /app
COPY Gemfile Gemfile.lock \
    /app/
WORKDIR /app
RUN bundle install

CMD bundle exec jekyll serve -w --host 0.0.0.0
