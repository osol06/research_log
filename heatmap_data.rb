#! /usr/bin/ruby
# -*- coding: utf-8

require './data_model.rb'
require 'active_support'
require 'active_support/core_ext'
require 'csv'

# あるユーザのheatmapに使用するtsvファイルを作成するメソッド
def create_heatmap_tsv( user_id )

  # tsvのデータを入れる多次元配列
  tsv_data = Array.new(168)

  # 時間帯をフォーマットしたものが入っている配列
  format_hour = ["00", "01", "02", "03", "04", "05",
                 "06", "07", "08", "09", "10", "11",
                 "12", "13", "14", "15", "16", "17",
                 "18", "19", "20", "21", "22", "23", "24"]

  # データを多次元配列に入れるときの添字
  t = 0

  # 一週間(7日)分のループ
  (1..7).each{ |day|

    # あるユーザのデータを抽出
    task = Task.where(user_id: user_id)

    # %w	Day of the week (0=Sunday, 6=Saturday)
    # ある曜日のでデータを抽出する
    task_1 = task.where("date_format(start_time, '%w') = #{day} - 1")

    # ある時間帯の
    (1..24).each{ |hour|

      # タスクを始めた時間か終えた時間がある時間帯にあるときのレコードを抽出
      # 時間とかよくわからないけど、調整が必要だった
      task_2 = task_1.where("DATE_FORMAT(start_time - INTERVAL 1 HOUR, '%H:%I:%S') between '#{format_hour[hour-1]}:00:00' and '#{format_hour[hour]}:00:00'")

      # データを一旦配列に入れる
      # task_2.countを9倍するのは、可視化するときのレベルが9個あるため
      count = task_2.count * 9
      task_data = [day, hour, count]
      p task_data
      # 多次元配列にデータを格納
      tsv_data[t + hour -1] = task_data.dup

    }

    # 多次元配列に格納する位置を24ずつずらす
    t = t + 24

  }

  puts "デバッグです"
  p tsv_data
  p tsv_data.count



  File.open("aaa.tsv", 'w') do |line|

    # 先頭の行を書き込む
    line.puts "day\thour\tvalue"

    # データを空白を区切りとして書き込む
    tsv_data.each do |data|

      line.puts data.split(',').join ("\t")

    end

  end


=begin
  CSV.open("./aaa.tsv", "w") do |writer|

    # tsvの先頭を入力
    writer << ['day', 'hour', 'value']

    # データを入力
    tsv_data.each do |data|
      writer << data
    end

  end
=end

end

create_heatmap_tsv(2)
