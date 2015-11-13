#! /usr/bin/ruby
# -*- coding: UTF-8 -*-


require 'erb'
require 'rubygems'
require './data_model.rb'
require 'digest/md5'
require './my_ruby_library/weather.rb'
require './database_my_library.rb'
require 'cgi'
require 'cgi/session'
require 'json'

# CGIを発行
cgi = CGI.new
session = CGI::Session.new(cgi)

# その日のコメントを抽出
task = Task.where("DATE_FORMAT(start_time,'%Y/%m/%d') = '#{cgi['date']}' ")
comment = ""
task.each do |row|
  comment = comment + row.comment
end

# 送信するデータ
hash = {"comment" => "#{comment}"}

# RubyオブジェクトからJSONに変換
json = JSON.generate(hash)


cgi.out ({ "type" => "application/json", "charset" => "UTF-8" }) {
    json
}
