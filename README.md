# twitter-deleter

> A simple script to delete tweets.

## Getting started

Make sure to have [ruby](https://www.ruby-lang.org/en/) installed (you can use [rvm](https://rvm.io/)), and then install dependencies with [bundler](https://bundler.io/):

```sh
rvm install 2.4.0
rvm use 2.4.0
gem install bundler:2.0.1
bundle install
```

Set the required environment variables in `.env` containing your twitter API credentials:

- `TWITTER_CONSUMER_KEY=`
- `TWITTER_CONSUMER_SECRET=`
- `TWITTER_ACCESS_TOKEN_KEY=`
- `TWITTER_ACCESS_TOKEN_SECRET=`

- `USERNAME=`
- `DELETE_RETWEETS=`
- `RELATIVE_DAYS=`
- `DRY_RUN=`

You can use the sample env file for reference:

```sh
cp .env.sample .env
```

You can get Twitter API credentials from the Twitter [apps page](https://developer.twitter.com/en/apps).

Additional info on generating acess tokens in this [gist](https://gist.github.com/miguelmota/a9486ac26b1b63aa57a291069748ae19).

Run the script:

```sh
$ ruby deleter.rb
```

### Using Docker

```sh
docker build -f Dockerfile -t twitter-deleter .
docker run --env-file=.env twitter-deleter
```

## License

[MIT](LICENSE)
