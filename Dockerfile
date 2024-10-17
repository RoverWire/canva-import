ARG RUBY_VERSION=3.2.1-alpine
FROM ruby:$RUBY_VERSION

ARG BUNDLER_VERSION=2.5.7

ENV RUBYOPT="-W0"

RUN apk update && apk upgrade && apk add --no-cache \
build-base libpq-dev bash \
&& rm -rf /var/cache/apk/*

WORKDIR /app

COPY . .

# Update the base gem solved the require issue
RUN gem update --system

RUN gem install bundler:${BUNDLER_VERSION} --no-document
RUN bundle install
RUN whenever -i

EXPOSE 3000

CMD ["bash", "./docker-boot.sh"]
