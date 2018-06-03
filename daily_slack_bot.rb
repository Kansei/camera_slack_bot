#１日一回どこかのチャンネルに1単語を投稿
# そのチャンネルで質問すると答えを返す。
# 古庄さんが投稿すると、冷たく返す。

require 'http'
require 'json'

response = HTTP.post("https://slack.com/api/chat.postMessage", params: {
    token: "xoxb-168582773890-374310282260-YJSbU0Pqv5Xm1ObEcfyjqlUS",
    channel: "#general",
    text: "こんにちは！",
    as_user: true,
  })

puts JSON.pretty_generate(JSON.parse(response.body))
