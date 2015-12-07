#! /usr/bin/ruby
# -*- coding: utf-8

require './data_model.rb'
require 'active_support'
require 'active_support/core_ext'

# 晴れの日ランキング
def good_weather_rank

  # ユーザ名と晴れの日学習時間が入ったハッシュ
  good_weather_rank = {}

  user = User.order("user_id").all
  user.each do |row|

    task = Task.where("user_id = #{row.user_id}")
    task = task.where("weather_frag = 1")
    task = task.where("start_time between '2015-11-20' and '2015-12-01'")
    time = task.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    sum = 0

    # 本日の合計時間(分)を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    good_weather_rank["#{row.user_name}"] = sum

  end
  # ハッシュを値で降順にする。返り値は配列なので、eachの部分にsortedを使う
  good_weather_rank = good_weather_rank.sort_by{|key,val| -val}

return good_weather_rank

end

# デバッグ
puts "良い天気ランキング"
puts good_weather_rank()

# 音楽ありの日ランキング
def music_rank

  # ユーザ名と音楽ありの日学習時間が入ったハッシュ
  music_rank = {}

  user = User.order("user_id").all
  user.each do |row|

    task = Task.where("user_id = #{row.user_id}")
    task = task.where("music_frag = 1")
    task = task.where("start_time between '2015-11-20' and '2015-12-01'")
    time = task.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    sum = 0

    # 本日の合計時間(分)を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    music_rank["#{row.user_name}"] = sum

  end
  # ハッシュを値で降順にする。返り値は配列なので、eachの部分にsortedを使う
  music_rank = music_rank.sort_by{|key,val| -val}

return music_rank

end

# デバッグ
puts "音楽ランキング"
puts music_rank()

# 朝学習ランキング
def morning_rank

  # ユーザ名と朝学習時間が入ったハッシュ
  morning_rank = {}

  user = User.order("user_id").all
  user.each do |row|

    task = Task.where("user_id = #{row.user_id}")
    task = task.where("start_time between '2015-11-20' and '2015-12-01'")
    task = task.where("date_format(start_time, '%H:%I:%S') between '06:00:00' and '12:00:00' or date_format(finish_time, '%H:%I:%S') between '06:00:00' and '12:00:00'")
    time = task.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    sum = 0

    # 本日の合計時間(分)を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    morning_rank["#{row.user_name}"] = sum

  end
  # ハッシュを値で降順にする。返り値は配列なので、eachの部分にsortedを使う
  morning_rank = morning_rank.sort_by{|key,val| -val}

return morning_rank

end

# デバッグ
puts "朝活ランキング"
puts morning_rank()

# 総合学習ランキング
def total_rank

  # ユーザ名と朝学習時間が入ったハッシュ
  total_rank = {}

  user = User.order("user_id").all
  user.each do |row|

    task = Task.where("user_id = #{row.user_id}")
    task.where("start_time between '2015-11-20' and '2015-12-01'")
    time = task.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    sum = 0

    # 本日の合計時間(分)を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    total_rank["#{row.user_name}"] = sum

  end
  # ハッシュを値で降順にする。返り値は配列なので、eachの部分にsortedを使う
  total_rank = total_rank.sort_by{|key,val| -val}

return total_rank

end

# デバッグ
puts "総合学習時間ランキング"
puts total_rank()
