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
num_people_r.eval_R <<-RCOMMAND
x <- c(#{alone.join(",")})
y <- c(#{group.join(",")})
num <- t.test(x,y,paired=TRUE)
print(num)

RCOMMAND

# ここからRubyのコード
#puts num_people_r.num.to_s

# 時間帯と学習時間のt検定
# (1)6~12と12~18
six_to_twelve = timezone_six_to_twelve()
twelve_to_eighteen = timezone_twelve_to_eighteen()

six_to_eighteen_r = RSRuby.instance

# ここからRのコード
six_to_eighteen_r.eval_R <<-RCOMMAND
x <- c(#{six_to_twelve.join(",")})
y <- c(#{twelve_to_eighteen.join(",")})
sixtoeighteen <- t.test(x,y,paired=TRUE)
print(sixtoeighteen)

RCOMMAND

# ここからRubyのコード
#puts six_to_eighteen_r.sixtoeighteen.to_s

# (2)12~18と18~24
twelve_to_eighteen = timezone_twelve_to_eighteen()
eighteen_to_twentyfour = timezone_eighteen_to_twentyfour()

twelve_to_twentyfour_r = RSRuby.instance

# ここからRのコード
twelve_to_twentyfour_r.eval_R <<-RCOMMAND
x <- c(#{twelve_to_eighteen.join(",")})
y <- c(#{eighteen_to_twentyfour.join(",")})
twelvetotwentyfour <- t.test(x,y,paired=TRUE)
print(twelvetotwentyfour)

RCOMMAND

# ここからRubyのコード
puts twelve_to_twentyfour_r.twelvetotwentyfour.to_s

# (3)6~12と18~24
six_to_twelve = timezone_six_to_twelve()
eighteen_to_twentyfour = timezone_eighteen_to_twentyfour()

six_to_twentyfour_r = RSRuby.instance

# ここからRのコード
six_to_twentyfour_r.eval_R <<-RCOMMAND
x <- c(#{six_to_twelve.join(",")})
y <- c(#{twelve_to_eighteen.join(",")})
sixtotwentyfour <- t.test(x,y,paired=TRUE)
print(sixtotwentyfour)

RCOMMAND

# ここからRubyのコード
puts six_to_twentyfour_r.sixtotwentyfour.to_s

# 最高気温と学習時間の相関関係
max_temperature = max_temperature_array()
temperature_average = each_temperature_average()

temperature_r = RSRuby.instance

# ここからRのコード
temperature_r.eval_R <<-RCOMMAND
x <- c(#{max_temperature.join(",")})
y <- c(#{temperature_average.join(",")})
temperature <- cor(x, y, method="pearson")
print(temperature)
temperaturetest <- cor.test(x, y, method="pearson")
print(temperaturetest)


RCOMMAND

# Rubyのコード
puts temperature_r.temperature.to_s
puts temperature_r.temperaturetest.to_s

r = RSRuby.instance
data = r.rnorm(100)
puts r.plot(data)
