#! /usr/bin/ruby
# -*- coding: UTF-8 -*-

# HTTPヘッダの出力
print "Content-type: text/html\n\n"


require 'erb'
require 'rubygems'
require './data_model.rb'
require 'digest/md5'
require './my_ruby_library/weather.rb'
require './my_ruby_library/login_data.rb'
require "cgi"

cgi = CGI.new

# p req.query

# サインアップが成功したかどうかのフラグ
# 0:サインアップ失敗 1:サインアップ
signin_frag = 1

# パスワードをハッシュ値にする処理
pass = Digest::MD5.new.update(cgi['password']).to_s
# puts pass

user = User.all
user.each do |row|

  # ユーザネーム、email,passwordが既に使われているかどうかの判定
  if cgi['username']==row.user_name
    signin_frag = 0
  elsif cgi['email']==row.email
    singin_frag = 0
  elsif cgi['password']==row.password
    singin_frag = 0
  end

end

if(signin_frag==1)

  User.create(user_id: nil, user_name: "#{cgi['username']}", image_name: 'takuma.jpg', continuity: 25, firstname: "#{cgi['firstname']}", lastname: "#{cgi['lastname']}", password: "#{pass.to_s}", email: "#{cgi['email']}" )

  # ログインユーザのidを取り出す
  user_id = User.all.order("user_id desc").first

  # ログインユーザの情報をセットする
  login_user = LoginUser.new
  login_user.set_userid(user_id.user_id)

  # 処理の結果を表示する
  # ERBを、ERBHandlerを経由せずに直接呼び出して利用している
  template = ERB.new( File.read('index.erb') )
  print template.result( binding )

else

  # 処理の結果を表示する
  # ERBを、ERBHandlerを経由せずに直接呼び出して利用している
  template = ERB.new( File.read('failed_signin.erb') )
  print template.result( binding )

end
