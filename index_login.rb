#! /usr/bin/ruby
# -*- coding: UTF-8 -*-


require 'erb'
require 'rubygems'
require './data_model.rb'
require 'digest/md5'
require 'cgi'
require 'cgi/session'

# CGIを発行
cgi = CGI.new


# ログイン成功したのでフラグを1にする
login_frag = 1

# 既存のセッションがあるかどうかの確認
begin
  session = CGI::Session.new(cgi,{"new_session"=>false})
rescue ArgumentError
  session = nil
end

#セッションが張られていれば
if session != nil and session['user_id'] != nil and session['user_id'] != ""

  # 処理の結果を表示する
  # ERBを、ERBHandlerを経由せずに直接呼び出して利用している
  template = ERB.new( File.read('index.erb') )
  puts cgi.header({ 'Content-Type' => 'text/html'})
  print template.result( binding )

else

  # 処理の結果を表示する
  # ERBを、ERBHandlerを経由せずに直接呼び出して利用している
  template = ERB.new( File.read('index_login.erb') )
  puts cgi.header({
    'Content-Type' => 'text/html'})
  print template.result( binding )

end
