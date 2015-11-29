#! /usr/bin/ruby
# -*- coding: UTF-8 -*-

require 'rubygems'
require 'rsruby'
require './t_test_library.rb'

music = music_average_array()
no_music = no_music_average_array()
puts music.join(",")
puts no_music.join(",")

r = RSRuby.instance

aaa= "aaa"

# ここからRのコード
r.eval_R <<-RCOMMAND
x <- c(#{music.join(",")})
y <- c(#{no_music.join(",")})
a <- t.test(x,y,paired=TRUE)
print(a)

RCOMMAND
# ここからRubyのコード
puts r.x.to_s
puts r.a.to_s
