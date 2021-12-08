FROM ubuntu

RUN apt-get update && apt-get install -y --no-install-recommends curl gnugp yarn
RUN gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN \curl -sSL https://get.rvm.io | bash -s stable
RUN rvm install 2.7.4 && rvm use 2.7.4 && gem install rails -v 5.2.6

RUN mkdir /home/e-market
WORKDIR /home/e-market

COPY app /home/e-market/app
COPY bin /home/e-market/bin
COPY config /home/e-market/config
COPY db /home/e-market/db
COPY lib /home/e-market/lib
COPY public /home/e-market/public
COPY storage /home/e-market/storage
COPY vendor /home/e-market/vender
COPY .ruby-version /home/e-market/.ruby-version
COPY config.ru /home/e-market/config.ru
COPY Gemfile /home/e-market/Gemfile
COPY Gemfile.lock /home/e-market/Gemfile.lock
COPY package.json /home/e-market/package.json
COPY Rakefile /home/e-market/Rakefile

RUN bundle install
RUN rails server -b 0.0.0.0