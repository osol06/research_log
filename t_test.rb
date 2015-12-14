#! /usr/bin/ruby
# -*- coding: UTF-8 -*-

require 'rubygems'
require 'rsruby'
require './t_test_library.rb'

# 音楽ありなしのt検定
music = music_average_array()
no_music = no_music_average_array()

music_r = RSRuby.instance

# ここからRのコード
puts "音楽ありなしのt検定"
music_r.eval_R <<-RCOMMAND
x <- c(#{music.join(",")})
y <- c(#{no_music.join(",")})
music <- t.test(x,y,paired=TRUE)
print(music)

RCOMMAND

# ここからRubyのコード
#puts music_r.music.to_s

# １人がグループかのt検定
alone = alone_average_array()
group = group_average_array()

num_people_r = RSRuby.instance

# ここからRのコード
puts "１人またはグループ学習のt検定"
num_people_r.eval_R <<-RCOMMAND
x <- c(#{alone.join(",")})
y <- c(#{group.join(",")})
num <- t.test(x,y,paired=TRUE)
print(num)

RCOMMAND

# 天気が良いか悪いかのt検定
good_w = good_weather_average_array()
bad_w = bad_weather_average_array()

weather_r = RSRuby.instance

# ここからRのコード
puts "天気の良し悪しのt検定"
weather_r.eval_R <<-RCOMMAND
x <- c(#{good_w.join(",")})
y <- c(#{bad_w.join(",")})
num <- t.test(x,y,paired=TRUE)
print(num)

RCOMMAND


# 最高気温と学習時間の相関関係
max_temperature = max_temperature_array()
temperature_average = each_temperature_average()

temperature_r = RSRuby.instance

# ここからRのコード
puts "最高気温と学習時間の相関係数と無相関検定"
temperature_r.eval_R <<-RCOMMAND
x <- c(#{max_temperature.join(",")})
y <- c(#{temperature_average.join(",")})
temperature <- cor(x, y, method="pearson")
print(temperature)
temperaturetest <- cor.test(x, y, method="pearson")
print(temperaturetest)


RCOMMAND

# Rubyのコード
puts temperature_r.temperaturetest.to_s



# 時間帯と学習量の関係
puts six_to_twelve = timezone_six_to_twelve()
puts twelve_to_eighteen = timezone_twelve_to_eighteen()
puts eighteen_to_twentyfour = timezone_eighteen_to_twentyfour()

# ユーザの数
user_count = user_count()
# ユーザ名
user_name = user_name_array()
p user_name

timezone_result = six_to_twelve.concat(twelve_to_eighteen).concat(eighteen_to_twentyfour)

timezone_r = RSRuby.instance

# ここからRのコード
puts "時間帯による一元配置分散分析(対応あり)"
timezone_r.eval_R <<-RCOMMAND
timezone_result <- c(#{timezone_result.join(",")})
print(timezone_result)
zone <- factor(c(rep("6~12",#{user_count}),rep("12~18",#{user_count}),rep("18~24",#{user_count})))
print(zone)
person <- factor(rep(c("#{user_name[0]}","#{user_name[1]}","#{user_name[2]}","#{user_name[3]}","#{user_name[4]}","#{user_name[5]}","#{user_name[6]}","#{user_name[7]}"),3))
print(person)
result <- summary(aov(timezone_result~zone+person))
print(result)
RCOMMAND
