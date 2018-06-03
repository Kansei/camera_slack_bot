#１日一回どこかのチャンネルに1単語を投稿
# そのチャンネルで質問すると答えを返す。
# 古庄さんが投稿すると、冷たく返す。

require 'http'
require 'json'

response = HTTP.post("https://slack.com/api/chat.postMessage", params: {
    token: ENV["CAMERA_DAILY_BOT"],
    channel: "#general",
    text: "こんにちは！",
    as_user: true,
  })

puts JSON.pretty_generate(JSON.parse(response.body))
