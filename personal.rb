#! /usr/bin/ruby
# -*- coding: UTF-8 -*-


require 'erb'
require 'rubygems'
require './data_model.rb'
require 'digest/md5'
require './my_ruby_library/weather.rb'
require './my_ruby_library/login_data.rb'
require 'cgi'
require 'cgi/session'
require './heatmap_data.rb'

# CGIを発行
cgi = CGI.new
session = CGI::Session.new(cgi)

create_heatmap_tsv(session["user_id"])


# 処理の結果を表示する
# ERBを、ERBHandlerを経由せずに直接呼び出して利用している
template = ERB.new( File.read('personal.erb') )
puts cgi.header({ 'Content-Type' => 'text/html'})
print template.result( binding )
