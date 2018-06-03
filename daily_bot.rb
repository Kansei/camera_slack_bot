#１日一回どこかのチャンネルに1単語を投稿

require File.dirname(__FILE__) + "/camera_dictionary"
require 'http'
require 'json'

word = CameraDictionary.rand_word

message = "今日の単語：「#{word[:title]}」\n#{word[:text]}\n#{word[:uri]}"

response = HTTP.post("https://slack.com/api/chat.postMessage", params: {
    token: "xoxb-168582773890-374310282260-YJSbU0Pqv5Xm1ObEcfyjqlUS",
    channel: "#general",
    text: message,
    as_user: true,
  })

puts JSON.pretty_generate(JSON.parse(response.body))
