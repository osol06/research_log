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
puts "音楽あり"
puts music_average_array()

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
puts "音楽なし"
puts no_music_average_array()
