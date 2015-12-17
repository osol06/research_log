#! /usr/bin/ruby
# -*- coding: UTF-8 -*-


require 'erb'
require 'rubygems'
require './data_model.rb'
require 'digest/md5'
require './my_ruby_library/weather.rb'
require './database_my_library.rb'
require 'cgi'
require 'cgi/session'

# CGIを発行
cgi = CGI.new
session = CGI::Session.new(cgi)

# テーブルにデータを追加する
Question.create(question_id: nil, user_id: session['user_id'], timeline: cgi['timeline'], personal: cgi['personal'], diary: cgi['diary'], rank: cgi['rank'], open: cgi['open'], ui: cgi['ui'], smart: cgi['smart'], other: "#{cgi['other']}")

puts cgi.header({ 'Content-Type' => 'text/html'})
