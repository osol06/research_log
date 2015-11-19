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

# 新しいデータがあるかどうかの判定
frag = 0
date = ""
time = ""
image_name = ""
user_name = ""
head = ""
comment = ""

task = Task.where("timestamp between '#{cgi['time_before']}' and '#{cgi['time_now']}' ")
task = task.where(" user_id != #{session['user_id']}")
if task.count != 0

  frag = 1

  task = task.all.order("task_id desc")
  first_count = 0

  task.each do |row|
    user = User.find_by(user_id: row.user_id )
    datetime = DateTime.parse("#{row.timestamp}")
    date_str =  datetime.strftime("%m/%d")
    time_str = datetime.strftime("%H:%M")

    if(first_count == 0)
      date = date + date_str
      time = time + time_str
      image_name = image_name + user.image_name
      user_name = user_name + user.user_name
      head = head + row.task_name + " " + task_time(row.task_id).to_i.to_s
      comment = comment + row.comment
    else
      date = date + "," + date_str
      time = time + "," + time_str
      image_name = image_name + "," + user.image_name
      user_name = user_name + "," + user.user_name
      head = head + "," + row.task_name + " " + task_time(row.task_id).to_i.to_s
      comment = comment + "," + row.comment
    end

    first_count = first_count + 1

  end
end

# 送信するデータ
hash = {
        "frag" => frag,
        "date" => date,
        "time" => time,
        "image_name" => image_name,
        "user_name" => user_name,
        "head" => head,
        "comment" => comment
       }

# RubyオブジェクトからJSONに変換
json = JSON.generate(hash)


cgi.out ({ "type" => "application/json", "charset" => "UTF-8" }) {
    json
}
