# twitter-deleter

> A simple script to delete tweets.

## Getting started

Make sure to have [ruby](https://www.ruby-lang.org/en/) installed (you can use [rvm](https://rvm.io/)), and then install dependencies with [bundler](https://bundler.io/):

```bash
bundle install
```

Set the required environment variables in `.env` containing your twitter API credentials:

- `TWITTER_CONSUMER_KEY`
- `TWITTER_CONSUMER_SECRET`
- `TWITTER_ACCESS_TOKEN_KEY`
- `TWITTER_ACCESS_TOKEN_SECRET`

You can use the sample env file for reference:

```bash
mv .env.sample .env
```

You can get Twitter API credentials from the Twitter [apps page](https://developer.twitter.com/en/apps).

Run the script:

```bash
$ ruby deleter.rb
```

## License

[MIT](LICENSE)
