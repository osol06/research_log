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
