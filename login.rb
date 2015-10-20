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

# ログインが成功しているかどうかのフラグ
# 0:ログイン失敗 1:ログイン成功
login_frag = 0

# パスワードをハッシュ値にする処理
pass = Digest::MD5.new.update(cgi['password_login']).to_s
# puts pass

user = User.all
user.each do |row|
  if(pass == row.password)

    if((cgi['username_login']==row.user_name)||((cgi['username_login']==row.email)))

      # ログイン成功したのでフラグを1にする
      login_frag = 1

      # とりあえず動かすために
      login_user = LoginUser.new
      login_user.set_userid(row.user_id)

      # 処理の結果を表示する
      # ERBを、ERBHandlerを経由せずに直接呼び出して利用している
      template = ERB.new( File.read('index.erb') )
      print template.result( binding )

      # イテレータを終了してメソッドから抜ける
      break
    end
  end
end

# signinが失敗した時の処理
if(login_frag == 0)

  # 処理の結果を表示する
  # ERBを、ERBHandlerを経由せずに直接呼び出して利用している
  template = ERB.new( File.read('failed_login.erb') )
  print template.result( binding )

end
