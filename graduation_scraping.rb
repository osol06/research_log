# 美馬研究室wikiの卒研日記を分析するためのコード

require 'open-uri' #URLにアクセスする為のライブラリを読み込みます。
require 'nokogiri' #Nokogiriライブラリを読み込みます。
require 'anemone'

url = 'http://wiki.c.fun.ac.jp/wiki/2015/index.php?%E5%8D%92%E7%A0%94%E6%97%A5%E8%A8%98' #切り出すURLを指定します。

charset = nil
html = open(url) do |f|
  charset = f.charset #文字種別を取得します。
  f.read #htmlに読み込んだものを渡す
end

page = Nokogiri::HTML.parse(html, nil, charset)

page.css("ul.list2").each do |node|
  puts node.text
end
