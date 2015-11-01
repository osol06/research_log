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

# CGIを発行
cgi = CGI.new
session = CGI::Session.new(cgi)

# 天気情報を持ってくる
weather = weather()
w_frag = weather_frag("#{weather['telop']}")


# 選択されたタスクidをもってきて
# カウントを1つ上げる
task_name = Task_name.find_by(task_name_id: "#{cgi['task_name_id']}", user_id: session['user_id'] )

task_name.update(count: task_name.count + 1)

# テーブルにデータを追加する
# category_idは一旦保留で1を挿入する事にしている
Task.create(task_id: nil, user_id: "#{session['user_id']}", category_id: 1, task_name_id: task_name.task_name_id, task_name: "#{task_name.task_name}", start_time: "#{cgi['date']} #{cgi['start_time']}", finish_time: "#{cgi['date']} #{cgi['finish_time']}", group_frag: cgi['group_frag'], comment: "#{cgi['comment']}", music_frag: cgi['music_frag'], weather_frag: w_frag )

image_name = User.find_by(user_id: session['user_id'] )
time = Task.order("task_id desc")
time = time.select("((UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60) as total")
time = time.find_by(user_id: session['user_id'])

puts cgi.header({ 'Content-Type' => 'text/html'})
print "#{image_name.image_name},#{image_name.user_name},#{task_name.task_name},#{time.total.to_i},#{cgi['comment']}"
