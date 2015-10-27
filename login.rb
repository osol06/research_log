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

# ログインが成功しているかどうかのフラグ
# 0:ログイン失敗 1:ログイン成功
login_frag = 0

# パスワードとユーザネーム,emailが空の時の処理
if(cgi['password_login'].empty? || cgi['username_login'].empty?)

  login_frag = 1

  # 処理の結果を表示する
  # ERBを、ERBHandlerを経由せずに直接呼び出して利用している
  template = ERB.new( File.read('failed_login.erb') )
  puts cgi.header({ 'Content-Type' => 'text/html'})
  print template.result( binding )

else

  # パスワードをハッシュ値にする処理
  pass = Digest::MD5.new.update(cgi['password_login']).to_s
  # puts pass

  user = User.all
  user.each do |row|
    if(pass == row.password)

      if((cgi['username_login']==row.user_name)||((cgi['username_login']==row.email)))

        # ログイン成功したのでフラグを1にする
        login_frag = 1

        # 既存のセッションがあるかどうかの確認
        begin
          session = CGI::Session.new(cgi,{"new_session"=>false})
        rescue ArgumentError
          session = nil
        end

        #セッションが張られていれば
        if session != nil

          #セッションは文字列しか保存できないので、数値に変換して1足す
          session['user_id'] = row.user_id
          #closeしてセッション情報をサーバに書き込む
          session.close

        #セッションが張られていなければ
        else

          #セッションを新規作成
          session = CGI::Session.new(cgi,{"new_session"=>true,
                                          "session_expires"=> Time.now + 3600 })
          session['user_id'] = row.user_id
          #closeしてセッション情報をサーバに書き込む
          session.close

        end

        # 処理の結果を表示する
        # ERBを、ERBHandlerを経由せずに直接呼び出して利用している
        template = ERB.new( File.read('index.erb') )
        puts cgi.header({ 'Content-Type' => 'text/html'})
        print template.result( binding )

        # イテレータを終了してメソッドから抜ける
        break
      end
    end
  end
end

# signinが失敗した時の処理
if(login_frag == 0)

  # 処理の結果を表示する
  # ERBを、ERBHandlerを経由せずに直接呼び出して利用している
  template = ERB.new( File.read('failed_login.erb') )
  puts cgi.header({ 'Content-Type' => 'text/html'})
  print template.result( binding )

end
