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

# 本日の達成率を取得
achevement_rate_hash = now_achevement_rate_hash()

# 本日の学習時間ランキングを取得
total_time_rank_hash = now_total_time_rank()



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

# コメントと学習時間帯などを持ってくる
task = Task.all

# 最新のコメントの抽出
first_comment_count = 0
right_head = ""
comment = ""
image_name = ""
task.first(100).each do |row|

  user = User.find(row.user_id)

  if(first_comment_count == 0)
    right_head = right_head + user.user_name + " " + task_time(row.task_id).to_i.to_s
    comment = comment + row.comment
    image_name = image_name + user.image_name
  else
    right_head = right_head + "," + user.user_name + " " + task_time(row.task_id).to_i.to_s
    comment = comment + "," + row.comment
    image_name = image_name + "," + user.image_name
  end
  first_comment_count = first_comment_count + 1
end


# 送信するデータ
hash = {
        "achevement_rate" => achevement_rate_hash,
        "total_time_rank" => total_time_rank_hash,
        "right_head" => right_head,
        "right_comment" => comment,
        "image_name" => image_name
       }

# RubyオブジェクトからJSONに変換
json = JSON.generate(hash)


cgi.out ({ "type" => "application/json", "charset" => "UTF-8" }) {
    json
}
