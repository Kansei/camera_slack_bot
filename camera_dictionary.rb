require 'nokogiri'
require 'open-uri'

class CameraDictionary
  @prefix = "https://ptl.imagegateway.net"
  @index = "/contents/original/glossary/index.html"
  @index_html = open(@prefix + @index) do |f|
    @charset = f.charset
    f.read
  end

  def self.rand_word
    scrape_word(status: "daily")
  end

  def self.search_word(str)


    doc = Nokogiri::HTML.parse(@index_html, nil, @charset)

    word_array = []
    doc.xpath('//div[@class="list"]/ul/li').each do |node|
      word_array << node.inner_text
    end

    status = "nothing"
    if word_array.include?(str)
      status = "match"
      num = word_array.index(str)
    else
      word_array.each_with_index do |word,i|
        if word.include?(str)
          status = "include"
          num = i
          break
        end
      end
    end

    scrape_word(word_num: num,status: status)
  end

  private
  def self.scrape_word(word_num: nil,status:)
    exp = {title: nil, text: nil, uri: nil,status: "nothing"}
    #ステータス:"match","include","nothing","daily"

    return exp if status == "nothing"

    index_doc = Nokogiri::HTML.parse(@index_html, nil, @charset)
    index_node = index_doc.xpath('//div[@class="list"]/ul/li/a')

    word_num = rand(index_node.length) if status == "daily"

    word_uri = URI.encode(@prefix+index_node[word_num][:href])
    word_html = open(word_uri)
    word_doc = Nokogiri::HTML.parse(word_html,nil,@charset)

    exp[:title] = word_doc.xpath('//*[@id="term_Inner"]/h2').inner_text
    exp[:text]= word_doc.xpath('/html/body/div[4]/div[2]/div[2]/p').inner_text.split("。")[0]
    exp[:uri] = word_uri
    exp[:status] = status if (exp[:title] != nil && exp[:text] != nil)
    exp
  end
end
