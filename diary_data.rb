#! /usr/bin/ruby
# -*- coding: UTF-8 -*-


require 'erb'
require 'rubygems'
require './data_model.rb'
require 'digest/md5'
require './my_ruby_library/weather.rb'
require './database_my_library.rb'
require './total_learning_time.rb'
require 'cgi'
require 'cgi/session'
require 'json'

# CGIを発行
cgi = CGI.new
session = CGI::Session.new(cgi)

# その日のコメントを抽出
task = Task.where("DATE_FORMAT(start_time,'%Y/%m/%d') = '#{cgi['date']}' ")
task = task.where("user_id = '#{session['user_id']}' ")
comment = ""
task.each do |row|
  comment = comment + row.comment
end

# その日のタスク名と時間帯を抽出
task_name = ""
task_name_array = task_and_zone_with_date(cgi['date'], session['user_id'])
first_count = 0
task_name_array.each do |row|
  if(first_count == 0)
    task_name = task_name + row
  else
    task_name = task_name +  "," + row
  end

  first_count =  first_count + 1
end

# 天気情報
weather_data = weather_with_date(cgi['date'])

# 合計時間
total_time = total_time_with_date(cgi['date'], session['user_id'])



# 送信するデータ
hash = {"comment" => "#{comment}", "task_name" => "#{task_name}",
        "weather_name" => "#{weather_data['weather']}", "weather_icon" => "#{weather_data['icon']}",
        "total_time" => "#{total_time}"
      }

# RubyオブジェクトからJSONに変換
json = JSON.generate(hash)

cgi.out ({ "type" => "application/json", "charset" => "UTF-8" }) {
    json
}
