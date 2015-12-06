#! /usr/bin/ruby
# -*- coding: utf-8

require './data_model.rb'
require 'active_support'
require 'active_support/core_ext'

# 音楽があるときの各ユーザの学習時間の平均(分)が入った配列を返すメソッド(ユーザidで昇順)
def music_average_array

  array = []

  user = User.order("user_id").all
  user.each do |row|

    # 音楽ありで学習した時のタスク
    task = Task.where("user_id = #{row.user_id}")
    task = task.where("music_frag = 1")

    # 合計時間(分)を計算するための変数
    sum = 0
    time = task.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")
    count = task.count

    # 本日の合計時間(分)を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    # countが0だと割り算ができないので,
    # 判定をかけて、countが0の時は配列に0をpushする
    if(count != 0)

      # 平均学習
      average = sum.to_f / count.to_f
      array.push(average)

    else

      array.push(0.0)

    end

  end

  return array

end

# デバッグ
#puts "音楽あり"
#puts music_average_array()

# 音楽があるときの各ユーザの学習時間の平均が入った配列を返すメソッド(ユーザidで昇順)
def no_music_average_array

  array = []

  user = User.order("user_id").all
  user.each do |row|

    # 音楽なしで学習した時のタスク
    task = Task.where("user_id = #{row.user_id}")
    task = task.where("music_frag = 0")

    # 合計時間(分)を計算するための変数
    sum = 0
    time = task.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")
    count = task.count

    # 本日の合計時間(分)を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    # countが0だと割り算ができないので,
    # 判定をかけて、countが0の時は配列に0をpushする
    if(count != 0)

      # 平均学習
      average = sum.to_f / count.to_f
      array.push(average)

    else

      array.push(0.0)

    end

  end

  return array

end

# デバッグ
#puts "音楽なし"
#puts no_music_average_array()

# １人で学習した時の各ユーザの学習時間の平均が入った配列を返すメソッド(ユーザidで昇順)
def alone_average_array

  array = []

  user = User.order("user_id").all
  user.each do |row|

    # １人で学習した時のタスク
    task = Task.where("user_id = #{row.user_id}")
    task = task.where("group_frag = 0")

    # 合計時間(分)を計算するための変数
    sum = 0
    time = task.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")
    count = task.count

    # 本日の合計時間(分)を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    # countが0だと割り算ができないので,
    # 判定をかけて、countが0の時は配列に0をpushする
    if(count != 0)

      # 平均学習
      average = sum.to_f / count.to_f
      array.push(average)

    else

      array.push(0.0)

    end

  end

  return array

end

# デバッグ
#puts alone_average_array()

# グループで学習した時の各ユーザの学習時間の平均が入った配列を返すメソッド(ユーザidで昇順)
def group_average_array

  array = []

  user = User.order("user_id").all
  user.each do |row|

    # グループで学習した時のタスク
    task = Task.where("user_id = #{row.user_id}")
    task = task.where("group_frag = 1")

    # 合計時間(分)を計算するための変数
    sum = 0
    time = task.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")
    count = task.count

    # 本日の合計時間(分)を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    # countが0だと割り算ができないので,
    # 判定をかけて、countが0の時は配列に0をpushする
    if(count != 0)

      # 平均学習

      average = sum.to_f / count.to_f
      array.push(average)

    else

      array.push(0.0)

    end

  end

  return array

end

# デバッグ
#puts group_average_array()

# 天気の良い時に学習した時の各ユーザの学習時間の平均が入った配列を返すメソッド(ユーザidで昇順)
def good_weather_average_array

  array = []

  user = User.order("user_id").all
  user.each do |row|

    # グループで学習した時のタスク
    task = Task.where("user_id = #{row.user_id}")
    task = task.where("weather_frag = 1")

    # 合計時間(分)を計算するための変数
    sum = 0
    time = task.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")
    count = task.count

    # 本日の合計時間(分)を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    # countが0だと割り算ができないので,
    # 判定をかけて、countが0の時は配列に0をpushする
    if(count != 0)

      # 平均学習

      average = sum.to_f / count.to_f
      array.push(average)

    else

      array.push(0.0)

    end

  end

  return array

end

# デバッグ
#puts good_weather_average_array()

# 天気の悪い時に学習した時の各ユーザの学習時間の平均が入った配列を返すメソッド(ユーザidで昇順)
def bad_weather_average_array

  array = []

  user = User.order("user_id").all
  user.each do |row|

    # グループで学習した時のタスク
    task = Task.where("user_id = #{row.user_id}")
    task = task.where("weather_frag = 2")

    # 合計時間(分)を計算するための変数
    sum = 0
    time = task.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")
    count = task.count

    # 本日の合計時間(分)を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    # countが0だと割り算ができないので,
    # 判定をかけて、countが0の時は配列に0をpushする
    if(count != 0)

      # 平均学習

      average = sum.to_f / count.to_f
      array.push(average)

    else

      array.push(0.0)

    end

  end

  return array

end

# デバッグ
# puts bad_weather_average_array()
# 最高気温の入った配列を返すメソッド
def max_temperature_array

  array = []

  # データベースに入っている
  weather = Weather.select("CAST(max_temperature as UNSIGNED) as temperature")
  weather = weather.order("temperature asc").uniq

  weather.each do |row|
    array.push(row.temperature.to_i)
  end

  return array

end

# max_temperatureのデバッグ
#puts "max_temperatureのデバッグ"
#puts max_temperature_array()
#puts "mac_temperatureの要素数"
#puts max_temperature_array().count

# 各最高気温のときの学習時間の平均を返すメソッド
def each_temperature_average

  array = []

  # 最高気温の種類を持ってくる
  max_temperature = max_temperature_array()
  max_temperature.each do |row|

    # その気温の時の全ての学習時間
    sum2 = 0
    count2 = 0

    # 各最高気温の時の日付分回す
    weather = Weather.where(max_temperature: row.to_s)
    weather.each do |row2|

      task = Task.where(start_time: row2.date)


      # 一日分の合計時間(分)を計算するための変数
      sum = 0
      count = 0
      time = task.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

      # 本日の合計時間(分)を計算
      time.each do |time_row|
        sum = sum + time_row.total.to_i
      end

      # その日の合計タスク数をカウント
      count = task.count

      sum2 = sum2 + sum
      count2 = count2 + count

    end

    # countが0だと割り算ができないので,
    # 判定をかけて、countが0の時は配列に0をpushする
    if(count2 != 0)

      # 平均学習
      average = sum2.to_f / count2.to_f
      array.push(average)

    else

      array.push(0.0)

    end

  end

  return array

end

# デバッグ
#puts "sumのデバッグ"
#puts each_temperature_average()
#puts "sumの要素数"
#puts each_temperature_average().count

# 各時間帯(6~12)の各ユーザの平均学習量を返すメソッド
def timezone_six_to_twelve

  array = []

  user = User.order("user_id").all
  user.each do |row|

    # 6~12時の間に学習した時のタスク
    task = Task.where("user_id = #{row.user_id}")
    task = task.where("date_format(start_time, '%H:%I:%S') between '06:00:00' and '12:00:00' or date_format(finish_time, '%H:%I:%S') between '06:00:00' and '12:00:00'")

    # 合計時間(分)を計算するための変数
    sum = 0
    time = task.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")
    count = task.count

    # 本日の合計時間(分)を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    # countが0だと割り算ができないので,
    # 判定をかけて、countが0の時は配列に0をpushする
    if(count != 0)

      # 平均学習
      average = sum.to_f / count.to_f
      array.push(average)

    else

      array.push(0.0)

    end

  end

  return array

end

#puts "6~12時の間の平均学習時間"
#puts timezone_six_to_twelve()
#puts timezone_six_to_twelve().count

# 各時間帯の各ユーザの平均学習量を返すメソッド
def timezone_twelve_to_eighteen

  array = []

  user = User.order("user_id").all
  user.each do |row|

    # 6~12時の間に学習した時のタスク
    task = Task.where("user_id = #{row.user_id}")
    task = task.where("date_format(start_time, '%H:%I:%S') between '12:00:01' and '18:00:00' or date_format(finish_time, '%H:%I:%S') between '12:00:01' and '18:00:00'")

    # 合計時間(分)を計算するための変数
    sum = 0
    time = task.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")
    count = task.count

    # 本日の合計時間(分)を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    # countが0だと割り算ができないので,
    # 判定をかけて、countが0の時は配列に0をpushする
    if(count != 0)

      # 平均学習
      average = sum.to_f / count.to_f
      array.push(average)

    else

      array.push(0.0)

    end

  end

  return array

end

#puts "12~18時の間の平均学習時間"
#puts timezone_twelve_to_eighteen()
#puts timezone_twelve_to_eighteen().count

# 各時間帯の各ユーザの平均学習量を返すメソッド
def timezone_eighteen_to_twentyfour

  array = []

  user = User.order("user_id").all
  user.each do |row|

    # 6~12時の間に学習した時のタスク
    task = Task.where("user_id = #{row.user_id}")
    task = task.where("date_format(start_time, '%H:%I:%S') between '18:00:01' and '24:00:00' or date_format(finish_time, '%H:%I:%S') between '18:00:01' and '24:00:00'")

    # 合計時間(分)を計算するための変数
    sum = 0
    time = task.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")
    count = task.count

    # 本日の合計時間(分)を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    # countが0だと割り算ができないので,
    # 判定をかけて、countが0の時は配列に0をpushする
    if(count != 0)

      # 平均学習
      average = sum.to_f / count.to_f
      array.push(average)

    else

      array.push(0.0)

    end

  end

  return array

end

#puts "18~24時の間の平均学習時間"
#puts timezone_eighteen_to_twentyfour()
#puts timezone_eighteen_to_twentyfour().count
