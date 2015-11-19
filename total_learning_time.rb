#! /usr/bin/ruby
# -*- coding: utf-8

require './data_model.rb'
require 'active_support'
require 'active_support/core_ext'
require './database_my_library.rb'
require 'date'

# 各ユーザの本日の学習時間の合計(分)とユーザ名が入ったハッシュを返すメソッド
# {"sasaki"=> 60, "ichitomo"=> 300, .... }
def total_learning_time

  # データベースから必要な情報を持ってくる
  # 以下はhogeの本日の学習時間(分)を持ってくるクエリ
  # select
  # (UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60
  # from tasks
  # where date(now()) between start_time and finish_time
  # and
  # user_id = hoge;

  # ユーザ名と本日の合計学習時間がはいったハッシュ
  total_time = {}

  # ユーザテーブルのデータを持ってくる
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

    total_time["#{row.user_name}"] = sum

  end



  return total_time

end

# 本日のユーザIDと学習時間ランキングが入った
def now_total_time_rank

  # ユーザ名と本日の合計学習時間がはいったハッシュ
  total_time_rank = {}

  # ユーザテーブルのデータを持ってくる
  user  = User.all
  user.each do |row|

    # 合計時間を計算するための変数
    sum = 0

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

    total_time_rank["#{row.id}"] = sum

  end

  # ハッシュを値で降順にする。返り値は配列なので、eachの部分にsortedを使う
  sorted =  total_time_rank.sort_by{|key,val| -val}

  # ランキング
  rank = 1
  sorted.each{|key, value|

    if total_time_rank["#{key}"] != 0

      total_time_rank["#{key}"] = rank

      # ランクを一つ増やす
      rank = rank + 1

    else

      total_time_rank["#{key}"] = '圏外'

    end

  }

  return total_time_rank

end

# ユーザidを引数にその人の一週間の学習時間(分)が入った配列を返すメソッド
# インデックス0,1,2,3,4,,, 本日,１日前,2日前,3日前,4日前,,,の順番
def total_time_week( user_id )

  # 一週間の学習時間(分)が入った配列
  time_week = Array.new

  task = Task.where(user_id: user_id)


  from = Time.now.in_time_zone.at_beginning_of_day
  # ローカル時間と9時間の差ができるため、その埋め合わせ
  from = from + 9.hour
  to   = from + 1.day

  (1..7).each{|num|

    # 合計時間を計算するための変数
    sum = 0

    time = task.where(start_time: from...to)
    time = time.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    time_week.push(sum)

    from = from - 1.day
    to = from + 1.day

  }

  # デバッグ
  # p time_week
  return time_week

end

# ユーザidを引数にその人の一週間の学習時間(分)が入った配列を返すメソッド
# インデックス0,1,2,3,4,,, 本日,１日前,2日前,3日前,4日前,,,の順番
def total_time_week_from_yesterday( user_id )

  # 一週間の学習時間(分)が入った配列
  time_week = Array.new

  task = Task.where(user_id: user_id)


  from = Time.now.in_time_zone.at_beginning_of_day
  # ローカル時間と9時間の差ができるため、その埋め合わせ
  from = from - 1.day + 9.hour
  to   = from + 1.day

  (1..7).each{|num|

    # 合計時間を計算するための変数
    sum = 0

    time = task.where(start_time: from...to)
    time = time.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    time_week.push(sum)

    from = from - 1.day
    to = from + 1.day

  }

  # デバッグ
  # p time_week
  return time_week

end

# ユーザidを引数にその人の一週間の学習時間(分)が入った配列を返すメソッド
# インデックス0,1,2,3,4,,, 本日,１日前,2日前,3日前,4日前,,,の順番
def total_time_week( user_id )

  # 一週間の学習時間(分)が入った配列
  time_week = Array.new

  task = Task.where(user_id: user_id)


  from = Time.now.in_time_zone.at_beginning_of_day
  # ローカル時間と9時間の差ができるため、その埋め合わせ
  from = from + 9.hour
  to   = from + 1.day

  (1..7).each{|num|

    # 合計時間を計算するための変数
    sum = 0

    time = task.where(start_time: from...to)
    time = time.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 60 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    time_week.push(sum)

    from = from - 1.day
    to = from + 1.day

  }

  # デバッグ
  # p time_week
  return time_week

end

# ユーザidを引数にその人のいままでの学習時間(時)が入った配列を返すメソッド
def total_time_week_all( user_id )

  task = Task.where(user_id: user_id)

  # 合計時間を計算するための変数
  sum = 0
  time = task.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 3600 as total")

  # 本日の合計時間を計算
  time.each do |time_row|
    sum = sum + time_row.total.to_i
  end

  # デバッグ
  # p time_week
  return sum

end

# user_idを引数にいままでの学習時間の合計ランキング順位を返す
def total_time_rank(user_id)

  rank = {}
  user =  User.all

  user.each do |user|

    task = Task.where(user_id: user.user_id)

    # 合計時間を計算するための変数
    sum = 0
    time = task.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 3600 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    rank["#{user.user_id}"] = sum

  end

  # user_idをキーに、今までの学習時間が入った降順のハッシュを生成
  rank = rank.sort_by{|key,val| -val}

  i = 1
  ranking = 0

  # 順位を計算
  rank.each{|key, value|

    if(key.to_i == user_id)
      ranking = i
    end

    i = i + 1
  }

  return ranking

end

# 日付を引数に、その日学習したタスク名と時間帯の文字列が入った配列を返すメソッド
def task_and_zone_with_date(date, user_id)

  task = Task.where("DATE_FORMAT(start_time,'%Y/%m/%d') = '#{date}'")
  task = task.where("user_id = #{user_id}")
  task = task.select("task_name, DATE_FORMAT(start_time,'%k:%i') as start, DATE_FORMAT(finish_time,'%k:%i') as finish")

  task_name = ""
  task.each do |row|
    task_name = task_name + "," + row.task_name + " " + row.start + " ~ " + row.finish
  end

  task_name_array = task_name.split(",")

  # 配列の空を消す
  task_name_array = task_name_array.compact.reject(&:empty?)
  #p task_name_array

  return task_name_array

end

# 日付を引数に、その日学習したタスク名と時間帯の文字列が入った配列を返すメソッド
def task_and_zone_with_date_str(date, user_id)

  task = Task.where("DATE_FORMAT(start_time,'%Y/%m/%d') = '#{date}'")
  task = task.where("user_id = #{user_id}")
  task = task.select("task_name, DATE_FORMAT(start_time,'%k:%i') as start, DATE_FORMAT(finish_time,'%k:%i') as finish")

  task_name = ""
  task.each do |row|
    task_name = task_name + "," + row.task_name + " " + row.start + " ~ " + row.finish
  end

  task_name_array = task_name.split(",")

  # 配列の空を消す
  task_name_array = task_name_array.compact.reject(&:empty?)
  #p task_name_array

  return task_name_array

end

# 日付を引数に、その日の天気情報がはいったハッシュを返すメソッド
def weather_with_date(date)

  weather_data = {}
  weather = Weather.find_by("DATE_FORMAT(date,'%Y/%m/%d') = '#{date}'")
  weather_data['weather'] = weather.weather
  weather_data['max'] = weather.max_temperature
  weather_data['min'] = weather.min_temperature
  weather_data['icon'] = weather.icon_url

  return weather_data

end


# 日付とユーザIDを引数に、その日付のユーザの合計学習時間を返すメソッド
def total_time_with_date(date, user_id)

  task = Task.where("DATE_FORMAT(start_time,'%Y/%m/%d') = '#{date}'")
  task = task.where("user_id = #{user_id}")

  # 合計時間を計算するための変数
  sum = 0
  time = task.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 3600 as total")

  # 本日の合計時間を計算
  time.each do |time_row|
    sum = sum + time_row.total.to_i
  end

  return sum

end

# 日付とユーザIDを引数に、日付と前日の学習時間の差を返すメソッド
def time_diff(date, user_id)

  date_obj = Date.parse(date)
  yesterday = date_obj - 1

  # 前日との差分を計算
  return total_time_with_date(date, user_id) - total_time_with_date(yesterday, user_id)

end

# 本日の達成度がkey:ユーザーID,value:達成率のハッシュで返すメソッド
# 今は仮なのであとで作成する
def now_achevement_rate_hash

  # ユーザIDと達成率のハッシュ
  achevement_rate_hash = {}

  user = User.all
  user.each do |row|

    #未完成部分
    achevement_rate_hash["#{row.user_id}"] = Random.rand(1 .. 100)

  end

  return achevement_rate_hash

end

# １人で学習する割合とユーザIDが入ったハッシュを返すメソッド
def alone_rate

  alone_hash = {}

  user = User.all
  user.each do |row|

    task = Task.where("user_id = #{row.user_id}")
    task = task.where("group_frag = 0")

    # 合計時間を計算するための変数
    sum = 0
    time = task.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 3600 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    if total_time_week_all(row.user_id) == 0
      alone_hash["#{row.user_id}"] = 0
    else
      alone_hash["#{row.user_id}"] = sum.to_f / total_time_week_all(row.user_id).to_f * 100
    end

  end

  return alone_hash

end

# 音楽ありで学習する割合とユーザIDが入ったハッシュを返すメソッド
def music_rate

  music_hash = {}

  user = User.all
  user.each do |row|

    task = Task.where("user_id = #{row.user_id}")
    task = task.where("music_frag = 1")

    # 合計時間を計算するための変数
    sum = 0
    time = task.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 3600 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    if total_time_week_all(row.user_id) == 0
      music_hash["#{row.user_id}"] = 0
    else
      music_hash["#{row.user_id}"] = sum.to_f / total_time_week_all(row.user_id).to_f * 100
    end

  end

  return music_hash

end

# 音楽ありで学習する割合とユーザIDが入ったハッシュを返すメソッド
def music_rate

  music_hash = {}

  user = User.all
  user.each do |row|

    task = Task.where("user_id = #{row.user_id}")
    task = task.where("music_frag = 1")

    # 合計時間を計算するための変数
    sum = 0
    time = task.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 3600 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    if total_time_week_all(row.user_id) == 0
      music_hash["#{row.user_id}"] = 0
    else
      music_hash["#{row.user_id}"] = sum.to_f / total_time_week_all(row.user_id).to_f * 100
    end

  end

  return music_hash

end

# 天気の良い時に学習する割合とユーザIDが入ったハッシュを返すメソッド
def weather_rate

  weather_hash = {}

  user = User.all
  user.each do |row|

    task = Task.where("user_id = #{row.user_id}")
    task = task.where("weather_frag = 1")

    # 合計時間を計算するための変数
    sum = 0
    time = task.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 3600 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    if total_time_week_all(row.user_id) == 0
      weather_hash["#{row.user_id}"] = 0
    else
      weather_hash["#{row.user_id}"] = sum.to_f / total_time_week_all(row.user_id).to_f * 100
    end

  end

  return weather_hash

end

# 朝に学習する割合とユーザIDが入ったハッシュを返すメソッド
def morning_rate

  morning_hash = {}

  user = User.all
  user.each do |row|

    task = Task.where("user_id = #{row.user_id}")
    task = task.where("DATE_FORMAT(start_time,'%H/%m/%s') between '06:00:00' and '12:00:00' ")

    # 合計時間を計算するための変数
    sum = 0
    time = task.select("(UNIX_TIMESTAMP(finish_time) - UNIX_TIMESTAMP(start_time)) / 3600 as total")

    # 本日の合計時間を計算
    time.each do |time_row|
      sum = sum + time_row.total.to_i
    end

    if total_time_week_all(row.user_id) == 0
      morning_hash["#{row.user_id}"] = 0
    else
      morning_hash["#{row.user_id}"] = sum.to_f / total_time_week_all(row.user_id).to_f * 100
    end

  end

  return morning_hash

end

# 最近1回分のコメントを抽出する
def recent_comment

  recent_comment_hash = {}

  user = User.all
  user.each do |row|

    task = Task.where("user_id = #{row.user_id}")
    task = task.order("task_id desc")
    comment = ""

    task.first(1).each do |row|

        recent_comment_hash["#{row.user_id}"] = row.comment

    end

  end

  return recent_comment_hash

end

# 最近1回分のタスク名などを抽出する
def recent_task

  recent_task_hash = {}

  user = User.all
  user.each do |row|

    task_model = Task.where("user_id = #{row.user_id}")
    task = ""

    # 最近の3回分のコメントを抽出
    task_model.first(1).each do |row2|
      recent_task_hash["#{row.user_id}"] = task + row2.task_name + " " + task_time(row2.task_id).to_i.to_s + "分 " + row2.start_time.strftime("%H:%m") + " ~ " + row2.finish_time.strftime("%H:%m")
    end

  end

  return recent_task_hash

end

# デバッグ
# p recent_comment()
# p morning_rate
# p alone_rate()
# p total_time_week_all(1)
# p now_total_time_rank()
# p now_total_time_rank()
# time_diff('2015/11/04', 2)
# total_time_with_date('2015/10/21', 2)
# p task_and_zone_with_date('2015/11/03', 2)
# total_time_week(2)
# p total_time_rank( 2 )
# p total_time_rank( 1 )
# p total_time_rank( 4 )
