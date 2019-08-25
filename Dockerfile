FROM ruby:2.6

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  nodejs \
  vim \
  yarn

COPY Gemfile* /usr/src/auth_demo/
WORKDIR /usr/src/auth_demo
RUN bundle install

COPY . /usr/src/auth_demo

ENTRYPOINT ["./docker-entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "s", "-b", "0.0.0.0"]
