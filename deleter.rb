require 'dotenv/load'
require 'twitter'
require 'json'

@client = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  config.access_token = ENV['TWITTER_ACCESS_TOKEN_KEY']
  config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
end

# --- config ----
username = ENV['USERNAME']
$relative_days = Integer(ENV['RELATIVE_DAYS'])
$dry_run = ENV['DRY_RUN'] == "true"
$delete_retweets = ENV['DELETE_RETWEETS'] == "true"
# ---------------

puts "username: #{username}"
puts "delete_retweets: #{$delete_retweets}"
puts "relative_days: #{$relative_days}"
puts "dry_run: #{$dry_run}"

$checked_ids = {}

def check(tweet_id)
  puts "checking tweet_id: #{tweet_id}"

  if !$dry_run then
    return delete_tweet(tweet_id)
  end
end

def delete_tweet(tweet_id)
  @client.destroy_status(tweet_id)
  puts "deleted tweet: #{tweet_id}"
rescue Twitter::Error::TooManyRequests => error
  p error
  sleep error.rate_limit.reset_in
  retry
rescue Twitter::Error::NotFound => error
  puts "tweet not found or already deleted"
  return
end

def get_tweets(username, max_id = nil)
  user = @client.user(username)
  count = 100
  timeline = nil
  if max_id != nil then
    timeline = @client.user_timeline(user.id, { :include_rts => $delete_retweets, :count => count, :max_id => max_id })
  else
    timeline = @client.user_timeline(user.id, { :include_rts => $delete_retweets, :count => count })
  end

  list = []
  new_max_id = nil
  timeline.each do |item|
    if !$delete_retweets and item.retweeted? then
      next
    end
    date = item.created_at.to_date
    now = Date.today
    time_ago  = (now - $relative_days)
    tweet_id = item.id
    if $checked_ids[tweet_id] then
      next
    end
    $checked_ids[tweet_id] = true
    if date < time_ago
      puts "tweet id: #{tweet_id} #{date} old: true"
      list.push(item.id)
    else
      puts "tweet id: #{tweet_id} #{date}"
    end
    if tweet_id != max_id then
      new_max_id = tweet_id
    end
  end
  if new_max_id != nil then
    return list + get_tweets(username, new_max_id)
  end
  return list
end

def get_tweets_from_file()
  return JSON.parse(File.read('tweet_ids.json')).reverse
end

puts "Twitter account: #{username}"

filename = "#{username}.cache"
f = open(filename, "a")

checked_list = []
if File.exists?(filename)
  checked_list = File.readlines(filename)
end

tweet_ids = get_tweets(username)
#tweet_ids = get_tweets_from_file()
puts "tweets count: #{tweet_ids.count}"

tweet_ids.each do |tweet_id|
  skip = false
  checked_list.each do |line|
    if line.strip.include? tweet_id.to_s
      skip = true
      puts "skipping check: #{tweet_id}"
      next
    end
  end

  if skip
    next
  end

  check(tweet_id)

  f << "#{tweet_id}\n"
end

puts "done"
