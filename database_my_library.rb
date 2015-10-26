#! /usr/bin/ruby
# -*- coding: utf-8

require './data_model.rb'
require 'active_support'
require 'active_support/core_ext'

# タスクidを引数に、そのタスクの所要時間を返す
def task_time(task_id)

  time = Task.select("task_id, ((UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60) as total")
  time = time.find_by(task_id: task_id)

  return time.total
end

# ユーザidをキーに本日の学習時間量一位に対する割合が入ったハッシュを返すメソッド
def user_rank_percent

  # ユーザidと本日の合計学習時間がはいったハッシュ
  total_time = {}

  user  = User.all
  user.each do |row|

    # 合計時間を計算するための変数
    sum = 0

    # 以下は本日の学習時間(分)を持ってくるクエリ
    # select
    # (UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60
    # from tasks
    # where date(now()) between start_time and finish_time
    # and
    # user_id = hoge;

    # 今日の日付
    from = Time.now.in_time_zone.at_beginning_of_day

    # ローカル時間と9時間の差ができるため、その埋め合わせ
    from = from + 9.hour
    to   = from + 1.day
    time = Task.where(start_time: from...to)
    time = time.where(user_id: row.user_id)
    time = time.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    total_time["#{row.user_id}"] = sum

  end

  # 学習時間が多い順にソートする
  total_time_sorted = total_time.sort_by{|key,val| -val}

  # ハッシュの要素数
  count = 1

  # 一位の人の学習時間を入れる変数
  first_rank_time = 0

  #user_idと一位の学習時間に対するパーセンテージを入れるハッシュ
  user_id_with_percent = {}


  total_time_sorted.each{ |key, value|

    if(count == 1)

      # まだ誰も記録していない
      if(value == 0)

        # 分母を適当に設定
        first_rank_time = 1
        first_percent = 0

      else

        first_rank_time = value
        first_percent = 100

      end

      user_id_with_percent["#{key}"] = first_percent

    else

      percent = (value.to_f / first_rank_time.to_f) * 100
      user_id_with_percent["#{key}"] = percent

    end

    count = count + 1
  }

  return user_id_with_percent

end

# デバッグ
# task_time(99)
# user_rank_percent()
