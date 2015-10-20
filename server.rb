#! /usr/bin/ruby
# -*- coding: utf-8
require 'webrick'
require 'erb'
require 'rubygems'
require './data_model.rb'
require 'digest/md5'
require './my_ruby_library/weather.rb'
require './my_ruby_library/login_data.rb'

# サーバーの設定を書いたハッシュを用意する
# ポート番号は通常使う80番ではなく、使ってなさそうなポート番号を使う
# 今回は8099を使う
# DocumentRootは、現在のディレクトリを表す「.」を指定
config = {
	:Port => 8099,
	:DocumentRoot => '.',
	:AccessLog => [[ File.open("./logs/access_log", "a"), WEBrick::AccessLog::COMBINED_LOG_FORMAT ]],# アクセスログの出力
  :Logger => WEBrick::Log::new("./logs/log",WEBrick::Log::DEBUG),# サーバログの出力
}

# 拡張子のファイルをHandlerと関連付ける
WEBrick::HTTPServlet::FileHandler.add_handler("erb", WEBrick::HTTPServlet::ERBHandler)
WEBrick::HTTPServlet::FileHandler.add_handler("rhtml", WEBrick::HTTPServlet::ERBHandler)
WEBrick::HTTPServlet::FileHandler.add_handler("rb", WEBrick::HTTPServlet::CGIHandler)

# WEBrickのHTTP Serverクラスのサーバーインスタンスを生成する
s = WEBrick::HTTPServer.new( config )

# MIMEタイプを設定
s.config[:MimeTypes]["erb"] = "text/html"
s.config[:MimeTypes]["rhtml"] = "text/html"


#Ctrl-C割り込みがあった場合にサーバーを停止する処理を登録しておく
trap(:INT) do
	s.shutdown
end

# 上記記述の処理をこなすサーバーを開始する
s.start
