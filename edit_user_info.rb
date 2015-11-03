#! /usr/bin/ruby
# -*- coding: UTF-8 -*-

require 'erb'
require 'rubygems'
require './data_model.rb'
require 'cgi'
require 'cgi/session'

cgi = CGI.new
session = CGI::Session.new(cgi)

# サーバ上に画像を保存します。
open('./images/' + cgi['image_name'].original_filename, "w") {|fh|
  fh.binmode
  fh.write cgi['image_name'].read
}

# userのデータを更新
user = User.find(session['user_id'])
user.update_attributes(:user_name => "#{cgi['user_name']}", :image_name => "#{cgi['image_name'].original_filename}" )

# 処理の結果を表示する
# ERBを、ERBHandlerを経由せずに直接呼び出して利用している
template = ERB.new( File.read('index.erb') )
puts cgi.header({ 'Content-Type' => 'text/html'})
print template.result( binding )
