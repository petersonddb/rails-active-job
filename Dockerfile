FROM ruby:2.6

RUN apt-get update && \
    apt-get install -y postgresql-client curl && \
    curl -sL https://deb.nodesource.com/setup_12.x | bash && \
    apt-get install -y nodejs && \
    npm install -g yarn && \
    gem install rails

WORKDIR /app

COPY . .

RUN bundle install
RUN yarn install

RUN chmod +x start.sh
CMD sh start.sh
