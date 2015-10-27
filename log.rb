#! /usr/bin/ruby
# -*- coding: UTF-8 -*-


require 'erb'
require 'rubygems'
require './data_model.rb'
require 'digest/md5'
require './my_ruby_library/weather.rb'
require 'cgi'
require 'cgi/session'

# CGIを発行
cgi = CGI.new
session = CGI::Session.new(cgi)

# 天気情報を持ってくる
weather = weather()
w_frag = weather_frag("#{weather['telop']}")

# 時間が入力されているかの判定
if(cgi['start_time'].empty? || cgi['finish_time'].empty?)

  # 処理の結果を表示する
  # ERBを、ERBHandlerを経由せずに直接呼び出して利用している
  template = ERB.new( File.read('failed_log.erb') )
  puts cgi.header({ 'Content-Type' => 'text/html'})
  print template.result( binding )

else

  # 選択されたタスクidをもってきて
  # カウントを1つ上げる
  task_name = Task_name.find_by(task_name_id: "#{cgi['task_name_id']}", user_id: session['user_id'] )

  task_name.update(count: task_name.count + 1)

  # テーブルにデータを追加する
  # category_idは一旦保留で1を挿入する事にしている
  Task.create(task_id: nil, user_id: "#{session['user_id']}", category_id: 1, task_name_id: task_name.task_name_id, task_name: "#{task_name.task_name}", start_time: "#{cgi['date']} #{cgi['start_time']}", finish_time: "#{cgi['date']} #{cgi['finish_time']}", group_frag: cgi['group_frag'], comment: "#{cgi['comment']}", music_frag: cgi['music_frag'], weather_frag: w_frag )

  # 処理の結果を表示する
  # ERBを、ERBHandlerを経由せずに直接呼び出して利用している
  template = ERB.new( File.read('index.erb') )
  puts cgi.header({ 'Content-Type' => 'text/html'})
  print template.result( binding )

end
