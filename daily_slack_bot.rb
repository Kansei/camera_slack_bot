# ボットに質問すると答えを返す。
# 古庄さんが投稿すると、冷たく返す。
# ともこちゃんには優しい。
# カメラおじさんbot = 幸せさん
# 幸せさんがいなくなった寂しさを埋めよう。
require File.dirname(__FILE__) + "/camera_dictionary"
require 'http'
require 'json'
require 'eventmachine'
require 'faye/websocket'

def parse(text)
  text.split(">")[-1].strip
end

def search(word)
  hit = CameraDictionary.search_word(word)

  case hit[:status]
  when "match"
    text = hit[:text]+"\n"+hit[:uri]
  when "include"
    text = "もしかして、#{hit[:title]}のことかな?\n"
    text = text+hit[:text]+"\n"+hit[:uri]
  when "nothing"
    text = "ごめんね、ちょっと分からないや..."
  end
end

def response_text(word, user)
  hurusyou_id = "U8JDRATQA"
  # tomoko_id =  "U8JH0J856"
  sakaue_id =  "U8K7G53D3"
  honsyu_id = "UAH4NNG4W"

  case user
  when hurusyou_id
    text_list =["ちょっと黙れ","消え失せろ","とっとと帰れ"]
    text_list[rand(3)]
  when sakaue_id
    text = "準備中"
  when honsyu_id
    text = "お前はメガネでしかない"
  else
    search(word)
  end
end

response = HTTP.post("https://slack.com/api/rtm.start", params: {
  token: ENV['CAMERA_DAILY_BOT']
  })
  rc = JSON.parse(response.body)
  url = rc['url']

  # rc["users"].each_with_index do |f|
  #    puts f["real_name"],f["id"]
  # end

  bot_id = "UB1QC92LF"

  EM.run do
    # Web Socketインスタンスの立ち上げ
    ws = Faye::WebSocket::Client.new(url)

    #  接続が確立した時の処理
    ws.on :open do
      p [:open]
    end

    # RTM APIから情報を受け取った時の処理
    ws.on :message do |event|
    data = JSON.parse(event.data)
    p [:message, data]

    if !data['text'].nil? && data['text'].include?(bot_id)
      word = parse(data['text'])
      text = response_text(word,data['user'])

      ws.send({
        type: 'message',
        text: text,
        channel: data['channel']

        }.to_json)
    end
  end

    # 接続が切断した時の処理
    ws.on :close do
      p [:close, event.code]
      ws = nil
      EM.stop
    end
  end
