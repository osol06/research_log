#! /usr/bin/ruby
# -*- coding: utf-8

require './data_model.rb'
require 'active_support'
require 'active_support/core_ext'
require './database_my_library.rb'
require 'date'

# 各ユーザの合計記録回とユーザ名が入ったハッシュを返すメソッド(合計)
def log_count

  # 返り値
  count = {}

  # ユーザテーブルのデータを持ってくる
  user = User.all
  user.each do |row|

    # 各ユーザの記録回数をもってくる
    task = Task.where("start_time between '2015-11-10' and '2015-12-01'")
    task = task.where(user_id:row.user_id)
    task = task.count

    count["#{row.user_name}"] = task
  end

  return count

end

# 全ユーザ名が入った配列を返すメソッド
def user_name_array

  array = []

  user = User.all
  user.each do |row|

    array.push(row.user_name)

  end

return array

end

# 各ユーザの合計記録回とユーザ名が入ったハッシュを返すメソッド(日別)
# まだ未完成
=begin
def daily_log_count

  # 返り値
  count = {}

  # ユーザテーブルのデータを持ってくる
  user = User.all
  user.each do |row|

    # 各ユーザの記録回数をもってくる
    task = Task.where("start_time between '2015-11-10' and '2015-12-01'")
    task = task.where(user_id:row.user_id)
    task = task.count

    count["#{row.user_name}"] = task
  end

  return count

end
=end

# 各ユーザのいままでの学習時間の合計(分)とユーザ名が入ったハッシュを返すメソッド
# {"sasaki"=> 60, "ichitomo"=> 300, .... }
def total_time

  # ユーザ名と本日の合計学習時間がはいったハッシュ
  total_time = {}

  # ユーザテーブルのデータを持ってくる
  user  = User.all
  user.each do |row|

    # 合計時間を計算するための変数
    sum = 0

    time = Task.where("start_time between '2015-11-10' and '2015-12-01'")
    time = time.where(user_id: row.user_id)
    time = time.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    total_time["#{row.user_name}"] = sum

  end

  return total_time

end

# 20151110の各ユーザの合計学習時間とユーザ名
def total_time_10

  # ユーザ名と本日の合計学習時間がはいったハッシュ
  total_time = {}

  # ユーザテーブルのデータを持ってくる
  user  = User.all
  user.each do |row|

    # 合計時間を計算するための変数
    sum = 0

    time = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-10'")
    time = time.where(user_id: row.user_id)
    time = time.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    total_time["#{row.user_name}"] = sum

  end

  return total_time

end

# 20151111の各ユーザの合計学習時間とユーザ名
def total_time_11

  # ユーザ名と本日の合計学習時間がはいったハッシュ
  total_time = {}

  # ユーザテーブルのデータを持ってくる
  user  = User.all
  user.each do |row|

    # 合計時間を計算するための変数
    sum = 0

    time = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-11'")
    time = time.where(user_id: row.user_id)
    time = time.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    total_time["#{row.user_name}"] = sum

  end

  return total_time

end

# 20151112の各ユーザの合計学習時間とユーザ名
def total_time_12

  # ユーザ名と本日の合計学習時間がはいったハッシュ
  total_time = {}

  # ユーザテーブルのデータを持ってくる
  user  = User.all
  user.each do |row|

    # 合計時間を計算するための変数
    sum = 0

    time = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-12'")
    time = time.where(user_id: row.user_id)
    time = time.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    total_time["#{row.user_name}"] = sum

  end

  return total_time

end

# 20151113の各ユーザの合計学習時間とユーザ名
def total_time_13

  # ユーザ名と本日の合計学習時間がはいったハッシュ
  total_time = {}

  # ユーザテーブルのデータを持ってくる
  user  = User.all
  user.each do |row|

    # 合計時間を計算するための変数
    sum = 0

    time = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-13'")
    time = time.where(user_id: row.user_id)
    time = time.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    total_time["#{row.user_name}"] = sum

  end

  return total_time

end

# 20151114の各ユーザの合計学習時間とユーザ名
def total_time_14

  # ユーザ名と本日の合計学習時間がはいったハッシュ
  total_time = {}

  # ユーザテーブルのデータを持ってくる
  user  = User.all
  user.each do |row|

    # 合計時間を計算するための変数
    sum = 0

    time = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-14'")
    time = time.where(user_id: row.user_id)
    time = time.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    total_time["#{row.user_name}"] = sum

  end

  return total_time

end

# 20151115の各ユーザの合計学習時間とユーザ名
def total_time_15

  # ユーザ名と本日の合計学習時間がはいったハッシュ
  total_time = {}

  # ユーザテーブルのデータを持ってくる
  user  = User.all
  user.each do |row|

    # 合計時間を計算するための変数
    sum = 0

    time = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-15'")
    time = time.where(user_id: row.user_id)
    time = time.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    total_time["#{row.user_name}"] = sum

  end

  return total_time

end

# 20151116の各ユーザの合計学習時間とユーザ名
def total_time_16

  # ユーザ名と本日の合計学習時間がはいったハッシュ
  total_time = {}

  # ユーザテーブルのデータを持ってくる
  user  = User.all
  user.each do |row|

    # 合計時間を計算するための変数
    sum = 0

    time = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-16'")
    time = time.where(user_id: row.user_id)
    time = time.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    total_time["#{row.user_name}"] = sum

  end

  return total_time

end

# 20151117の各ユーザの合計学習時間とユーザ名
def total_time_17

  # ユーザ名と本日の合計学習時間がはいったハッシュ
  total_time = {}

  # ユーザテーブルのデータを持ってくる
  user  = User.all
  user.each do |row|

    # 合計時間を計算するための変数
    sum = 0

    time = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-17'")
    time = time.where(user_id: row.user_id)
    time = time.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    total_time["#{row.user_name}"] = sum

  end

  return total_time

end

# 20151118の各ユーザの合計学習時間とユーザ名
def total_time_18

  # ユーザ名と本日の合計学習時間がはいったハッシュ
  total_time = {}

  # ユーザテーブルのデータを持ってくる
  user  = User.all
  user.each do |row|

    # 合計時間を計算するための変数
    sum = 0

    time = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-18'")
    time = time.where(user_id: row.user_id)
    time = time.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    total_time["#{row.user_name}"] = sum

  end

  return total_time

end

# 20151119の各ユーザの合計学習時間とユーザ名
def total_time_19

  # ユーザ名と本日の合計学習時間がはいったハッシュ
  total_time = {}

  # ユーザテーブルのデータを持ってくる
  user  = User.all
  user.each do |row|

    # 合計時間を計算するための変数
    sum = 0

    time = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-19'")
    time = time.where(user_id: row.user_id)
    time = time.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    total_time["#{row.user_name}"] = sum

  end

  return total_time

end

# 20151120の各ユーザの合計学習時間とユーザ名
def total_time_20

  # ユーザ名と本日の合計学習時間がはいったハッシュ
  total_time = {}

  # ユーザテーブルのデータを持ってくる
  user  = User.all
  user.each do |row|

    # 合計時間を計算するための変数
    sum = 0

    time = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-20'")
    time = time.where(user_id: row.user_id)
    time = time.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    total_time["#{row.user_name}"] = sum

  end

  return total_time

end

# 20151121の各ユーザの合計学習時間とユーザ名
def total_time_21

  # ユーザ名と本日の合計学習時間がはいったハッシュ
  total_time = {}

  # ユーザテーブルのデータを持ってくる
  user  = User.all
  user.each do |row|

    # 合計時間を計算するための変数
    sum = 0

    time = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-21'")
    time = time.where(user_id: row.user_id)
    time = time.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    total_time["#{row.user_name}"] = sum

  end

  return total_time

end

# 20151121の各ユーザの合計学習時間とユーザ名
def total_time_21

  # ユーザ名と本日の合計学習時間がはいったハッシュ
  total_time = {}

  # ユーザテーブルのデータを持ってくる
  user  = User.all
  user.each do |row|

    # 合計時間を計算するための変数
    sum = 0

    time = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-21'")
    time = time.where(user_id: row.user_id)
    time = time.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    total_time["#{row.user_name}"] = sum

  end

  return total_time

end

# 20151122の各ユーザの合計学習時間とユーザ名
def total_time_22

  # ユーザ名と本日の合計学習時間がはいったハッシュ
  total_time = {}

  # ユーザテーブルのデータを持ってくる
  user  = User.all
  user.each do |row|

    # 合計時間を計算するための変数
    sum = 0

    time = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-22'")
    time = time.where(user_id: row.user_id)
    time = time.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    total_time["#{row.user_name}"] = sum

  end

  return total_time

end

# 20151123の各ユーザの合計学習時間とユーザ名
def total_time_23

  # ユーザ名と本日の合計学習時間がはいったハッシュ
  total_time = {}

  # ユーザテーブルのデータを持ってくる
  user  = User.all
  user.each do |row|

    # 合計時間を計算するための変数
    sum = 0

    time = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-23'")
    time = time.where(user_id: row.user_id)
    time = time.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    total_time["#{row.user_name}"] = sum

  end

  return total_time

end

# 20151124の各ユーザの合計学習時間とユーザ名
def total_time_24

  # ユーザ名と本日の合計学習時間がはいったハッシュ
  total_time = {}

  # ユーザテーブルのデータを持ってくる
  user  = User.all
  user.each do |row|

    # 合計時間を計算するための変数
    sum = 0

    time = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-24'")
    time = time.where(user_id: row.user_id)
    time = time.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    total_time["#{row.user_name}"] = sum

  end

  return total_time

end

# 20151125の各ユーザの合計学習時間とユーザ名
def total_time_25

  # ユーザ名と本日の合計学習時間がはいったハッシュ
  total_time = {}

  # ユーザテーブルのデータを持ってくる
  user  = User.all
  user.each do |row|

    # 合計時間を計算するための変数
    sum = 0

    time = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-25'")
    time = time.where(user_id: row.user_id)
    time = time.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    total_time["#{row.user_name}"] = sum

  end

  return total_time

end

# 20151126の各ユーザの合計学習時間とユーザ名
def total_time_26

  # ユーザ名と本日の合計学習時間がはいったハッシュ
  total_time = {}

  # ユーザテーブルのデータを持ってくる
  user  = User.all
  user.each do |row|

    # 合計時間を計算するための変数
    sum = 0

    time = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-26'")
    time = time.where(user_id: row.user_id)
    time = time.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    total_time["#{row.user_name}"] = sum

  end

  return total_time

end

# 20151127の各ユーザの合計学習時間とユーザ名
def total_time_27

  # ユーザ名と本日の合計学習時間がはいったハッシュ
  total_time = {}

  # ユーザテーブルのデータを持ってくる
  user  = User.all
  user.each do |row|

    # 合計時間を計算するための変数
    sum = 0

    time = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-27'")
    time = time.where(user_id: row.user_id)
    time = time.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    total_time["#{row.user_name}"] = sum

  end

  return total_time

end

# 20151128の各ユーザの合計学習時間とユーザ名
def total_time_28

  # ユーザ名と本日の合計学習時間がはいったハッシュ
  total_time = {}

  # ユーザテーブルのデータを持ってくる
  user  = User.all
  user.each do |row|

    # 合計時間を計算するための変数
    sum = 0

    time = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-28'")
    time = time.where(user_id: row.user_id)
    time = time.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    total_time["#{row.user_name}"] = sum

  end

  return total_time

end

# 20151129の各ユーザの合計学習時間とユーザ名
def total_time_29

  # ユーザ名と本日の合計学習時間がはいったハッシュ
  total_time = {}

  # ユーザテーブルのデータを持ってくる
  user  = User.all
  user.each do |row|

    # 合計時間を計算するための変数
    sum = 0

    time = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-29'")
    time = time.where(user_id: row.user_id)
    time = time.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    total_time["#{row.user_name}"] = sum

  end

  return total_time

end

# 20151130の各ユーザの合計学習時間とユーザ名
def total_time_30

  # ユーザ名と本日の合計学習時間がはいったハッシュ
  total_time = {}

  # ユーザテーブルのデータを持ってくる
  user  = User.all
  user.each do |row|

    # 合計時間を計算するための変数
    sum = 0

    time = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-30'")
    time = time.where(user_id: row.user_id)
    time = time.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    total_time["#{row.user_name}"] = sum

  end

  return total_time

end

# 20151112の各ユーザの合計学習時間とユーザ名
def total_time_1

  # ユーザ名と本日の合計学習時間がはいったハッシュ
  total_time = {}

  # ユーザテーブルのデータを持ってくる
  user  = User.all
  user.each do |row|

    # 合計時間を計算するための変数
    sum = 0

    time = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-12-1'")
    time = time.where(user_id: row.user_id)
    time = time.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    total_time["#{row.user_name}"] = sum

  end

  return total_time

end

# 各ユーザの一回の平均コメント数とユーザ名が入ったハッシュを返すメソッド
def char_count

  # ユーザ名と一回の平均コメント数が入ったハッシュ
  char_count = {}

  # ユーザテーブルのデータを持ってくる
  user  = User.all
  user.each do |row|

    # 文字数の合計を保存
    sum = 0

    task = Task.where("start_time between '2015-11-10' and '2015-12-01'")
    task = task.where(user_id:row.user_id)
    char = task.select("CHAR_LENGTH(comment) as total")

    char.each do |count|
      sum = sum + count.total.to_i
    end

    if sum == 0
      sum = 0
    else
      sum = sum / task.count
    end

    char_count["#{row.user_name}"] = sum

  end

  return char_count

end





# 20151110の各ユーザの記録回数とユーザ名
def total_count_10

  # 返り値
  count = {}

  # ユーザテーブルのデータを持ってくる
  user = User.all
  user.each do |row|

    # 各ユーザの記録回数をもってくる
    task = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-10'")
    task = task.where(user_id:row.user_id)
    task = task.count

    count["#{row.user_name}"] = task
  end

  return count

end

# 20151111の各ユーザの記録回数とユーザ名
def total_count_11

  # 返り値
  count = {}

  # ユーザテーブルのデータを持ってくる
  user = User.all
  user.each do |row|

    # 各ユーザの記録回数をもってくる
    task = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-11'")
    task = task.where(user_id:row.user_id)
    task = task.count

    count["#{row.user_name}"] = task
  end

  return count

end

# 20151112の各ユーザの記録回数とユーザ名
def total_count_12

  # 返り値
  count = {}

  # ユーザテーブルのデータを持ってくる
  user = User.all
  user.each do |row|

    # 各ユーザの記録回数をもってくる
    task = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-12'")
    task = task.where(user_id:row.user_id)
    task = task.count

    count["#{row.user_name}"] = task
  end

  return count

end

# 20151113の各ユーザの記録回数とユーザ名
def total_count_13

  # 返り値
  count = {}

  # ユーザテーブルのデータを持ってくる
  user = User.all
  user.each do |row|

    # 各ユーザの記録回数をもってくる
    task = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-13'")
    task = task.where(user_id:row.user_id)
    task = task.count

    count["#{row.user_name}"] = task
  end

  return count

end

# 20151114の各ユーザの記録回数とユーザ名
def total_count_14

  # 返り値
  count = {}

  # ユーザテーブルのデータを持ってくる
  user = User.all
  user.each do |row|

    # 各ユーザの記録回数をもってくる
    task = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-14'")
    task = task.where(user_id:row.user_id)
    task = task.count

    count["#{row.user_name}"] = task
  end

  return count

end

# 20151115の各ユーザの記録回数とユーザ名
def total_count_15

  # 返り値
  count = {}

  # ユーザテーブルのデータを持ってくる
  user = User.all
  user.each do |row|

    # 各ユーザの記録回数をもってくる
    task = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-15'")
    task = task.where(user_id:row.user_id)
    task = task.count

    count["#{row.user_name}"] = task
  end

  return count

end

# 20151116の各ユーザの記録回数とユーザ名
def total_count_16

  # 返り値
  count = {}

  # ユーザテーブルのデータを持ってくる
  user = User.all
  user.each do |row|

    # 各ユーザの記録回数をもってくる
    task = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-16'")
    task = task.where(user_id:row.user_id)
    task = task.count

    count["#{row.user_name}"] = task
  end

  return count

end

# 20151117の各ユーザの記録回数とユーザ名
def total_count_17

  # 返り値
  count = {}

  # ユーザテーブルのデータを持ってくる
  user = User.all
  user.each do |row|

    # 各ユーザの記録回数をもってくる
    task = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-17'")
    task = task.where(user_id:row.user_id)
    task = task.count

    count["#{row.user_name}"] = task
  end

  return count

end

# 20151118の各ユーザの記録回数とユーザ名
def total_count_18

  # 返り値
  count = {}

  # ユーザテーブルのデータを持ってくる
  user = User.all
  user.each do |row|

    # 各ユーザの記録回数をもってくる
    task = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-18'")
    task = task.where(user_id:row.user_id)
    task = task.count

    count["#{row.user_name}"] = task
  end

  return count

end

# 20151119の各ユーザの記録回数とユーザ名
def total_count_19

  # 返り値
  count = {}

  # ユーザテーブルのデータを持ってくる
  user = User.all
  user.each do |row|

    # 各ユーザの記録回数をもってくる
    task = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-19'")
    task = task.where(user_id:row.user_id)
    task = task.count

    count["#{row.user_name}"] = task
  end

  return count

end

# 20151120の各ユーザの記録回数とユーザ名
def total_count_20

  # 返り値
  count = {}

  # ユーザテーブルのデータを持ってくる
  user = User.all
  user.each do |row|

    # 各ユーザの記録回数をもってくる
    task = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-20'")
    task = task.where(user_id:row.user_id)
    task = task.count

    count["#{row.user_name}"] = task
  end

  return count

end

# 20151121の各ユーザの記録回数とユーザ名
def total_count_21

  # 返り値
  count = {}

  # ユーザテーブルのデータを持ってくる
  user = User.all
  user.each do |row|

    # 各ユーザの記録回数をもってくる
    task = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-21'")
    task = task.where(user_id:row.user_id)
    task = task.count

    count["#{row.user_name}"] = task
  end

  return count

end

# 20151122の各ユーザの記録回数とユーザ名
def total_count_22

  # 返り値
  count = {}

  # ユーザテーブルのデータを持ってくる
  user = User.all
  user.each do |row|

    # 各ユーザの記録回数をもってくる
    task = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-22'")
    task = task.where(user_id:row.user_id)
    task = task.count

    count["#{row.user_name}"] = task
  end

  return count

end

# 20151123の各ユーザの記録回数とユーザ名
def total_count_23

  # 返り値
  count = {}

  # ユーザテーブルのデータを持ってくる
  user = User.all
  user.each do |row|

    # 各ユーザの記録回数をもってくる
    task = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-23'")
    task = task.where(user_id:row.user_id)
    task = task.count

    count["#{row.user_name}"] = task
  end

  return count

end

# 20151124の各ユーザの記録回数とユーザ名
def total_count_24

  # 返り値
  count = {}

  # ユーザテーブルのデータを持ってくる
  user = User.all
  user.each do |row|

    # 各ユーザの記録回数をもってくる
    task = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-24'")
    task = task.where(user_id:row.user_id)
    task = task.count

    count["#{row.user_name}"] = task
  end

  return count

end
# 20151125の各ユーザの記録回数とユーザ名
def total_count_25

  # 返り値
  count = {}

  # ユーザテーブルのデータを持ってくる
  user = User.all
  user.each do |row|

    # 各ユーザの記録回数をもってくる
    task = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-25'")
    task = task.where(user_id:row.user_id)
    task = task.count

    count["#{row.user_name}"] = task
  end

  return count

end
# 20151126の各ユーザの記録回数とユーザ名
def total_count_26

  # 返り値
  count = {}

  # ユーザテーブルのデータを持ってくる
  user = User.all
  user.each do |row|

    # 各ユーザの記録回数をもってくる
    task = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-26'")
    task = task.where(user_id:row.user_id)
    task = task.count

    count["#{row.user_name}"] = task
  end

  return count

end
# 20151127の各ユーザの記録回数とユーザ名
def total_count_27

  # 返り値
  count = {}

  # ユーザテーブルのデータを持ってくる
  user = User.all
  user.each do |row|

    # 各ユーザの記録回数をもってくる
    task = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-27'")
    task = task.where(user_id:row.user_id)
    task = task.count

    count["#{row.user_name}"] = task
  end

  return count

end
# 20151128の各ユーザの記録回数とユーザ名
def total_count_28

  # 返り値
  count = {}

  # ユーザテーブルのデータを持ってくる
  user = User.all
  user.each do |row|

    # 各ユーザの記録回数をもってくる
    task = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-28'")
    task = task.where(user_id:row.user_id)
    task = task.count

    count["#{row.user_name}"] = task
  end

  return count

end

# 20151128の各ユーザの記録回数とユーザ名
def total_count_29

  # 返り値
  count = {}

  # ユーザテーブルのデータを持ってくる
  user = User.all
  user.each do |row|

    # 各ユーザの記録回数をもってくる
    task = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-29'")
    task = task.where(user_id:row.user_id)
    task = task.count

    count["#{row.user_name}"] = task
  end

  return count

end

# 20151128の各ユーザの記録回数とユーザ名
def total_count_30

  # 返り値
  count = {}

  # ユーザテーブルのデータを持ってくる
  user = User.all
  user.each do |row|

    # 各ユーザの記録回数をもってくる
    task = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-11-30'")
    task = task.where(user_id:row.user_id)
    task = task.count

    count["#{row.user_name}"] = task
  end

  return count

end

# 20151128の各ユーザの記録回数とユーザ名
def total_count_1

  # 返り値
  count = {}

  # ユーザテーブルのデータを持ってくる
  user = User.all
  user.each do |row|

    # 各ユーザの記録回数をもってくる
    task = Task.where("DATE_FORMAT(start_time,'%Y-%m-%d') = '2015-12-1'")
    task = task.where(user_id:row.user_id)
    task = task.count

    count["#{row.user_name}"] = task
  end

  return count

end


=begin
# デバッグ
p '記録数'
p log_count()
p '合計学習時間'
p total_time()
p '平均コメント数'
p char_count()


p '2015-11-10'
p total_time_10()
p '2015-11-11'
p total_time_11()
p '2015-11-12'
p total_time_12()
p '2015-11-13'
p total_time_13()
p '2015-11-14'
p total_time_14()
p '2015-11-15'
p total_time_15()
p '2015-11-16'
p total_time_16()
p '2015-11-17'
p total_time_17()
p '2015-11-18'
p total_time_18()
p '2015-11-19'
p total_time_19()
p '2015-11-20'
p total_time_20()
p '2015-11-21'
p total_time_21()
p '2015-11-22'
p total_time_22()
p '2015-11-23'
p total_time_23()
p '2015-11-24'
p total_time_24()
p '2015-11-25'
p total_time_25()
p '2015-11-26'
p total_time_26()
p '2015-11-27'
p total_time_27()
p '2015-11-28'
p total_time_28()
p '2015-11-29'
p total_time_29()
p '2015-11-30'
p total_time_30()
p '2015-12-1'
p total_time_1()
=end
