#! /usr/bin/ruby
# -*- coding: UTF-8 -*-


require 'erb'
require 'rubygems'
require './data_model.rb'
require 'digest/md5'
require './evaluate_library.rb'
require './my_ruby_library/weather.rb'
require './my_ruby_library/login_data.rb'
require 'cgi'
require 'cgi/session'
require './heatmap_data.rb'

# CGIを発行
cgi = CGI.new
session = CGI::Session.new(cgi)

# key:ユーザ名 value:記録回数のハッシュを準備
log_count = log_count()

total_time_10 = total_time_10()
total_time_11 = total_time_11()
total_time_12 = total_time_12()
total_time_13 = total_time_13()
total_time_14 = total_time_14()
total_time_15 = total_time_15()
total_time_16 = total_time_16()
total_time_17 = total_time_17()
total_time_18 = total_time_18()
total_time_19 = total_time_19()
total_time_20 = total_time_20()
total_time_21 = total_time_21()
total_time_22 = total_time_22()
total_time_23 = total_time_23()
total_time_24 = total_time_24()
total_time_25 = total_time_25()
total_time_26 = total_time_26()
total_time_27 = total_time_27()
total_time_28 = total_time_28()
total_time_29 = total_time_29()
total_time_30 = total_time_30()
total_time_1 = total_time_1()

total_count_10 = total_count_10()
total_count_11 = total_count_11()
total_count_12 = total_count_12()
total_count_13 = total_count_13()
total_count_14 = total_count_14()
total_count_15 = total_count_15()
total_count_16 = total_count_16()
total_count_17 = total_count_17()
total_count_18 = total_count_18()
total_count_19 = total_count_19()
total_count_20 = total_count_20()
total_count_21 = total_count_21()
total_count_22 = total_count_22()
total_count_23 = total_count_23()
total_count_24 = total_count_24()
total_count_25 = total_count_25()
total_count_26 = total_count_26()
total_count_27 = total_count_27()
total_count_28 = total_count_28()
total_count_29 = total_count_29()
total_count_30 = total_count_30()
total_count_1 = total_count_1()



# 処理の結果を表示する
# ERBを、ERBHandlerを経由せずに直接呼び出して利用している
template = ERB.new( File.read('evaluate_data.erb') )
puts cgi.header({ 'Content-Type' => 'text/html'})
print template.result( binding )
