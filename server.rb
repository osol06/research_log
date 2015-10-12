#! /usr/bin/ruby
# -*- coding: utf-8
require 'webrick'
require 'erb'
require 'rubygems'
require 'dbi'
require './data_model.rb'
require 'digest/md5'
require './my_ruby_library/weather.rb'
require './my_ruby_library/login_data.rb'

# サーバーの設定を書いたハッシュを用意する
# ポート番号は通常使う80番ではなく、使ってなさそうなポート番号を使う
# 今回は8099を使う
# DocumentRootは、現在のディレクトリを表す「.」を指定
config = {
	:Port => 8099,
	:DocumentRoot => '.',
	:AccessLog => [[ File.open("./logs/access_log", "a"), WEBrick::AccessLog::COMBINED_LOG_FORMAT ]],# アクセスログの出力
  :Logger => WEBrick::Log::new("./logs/log",WEBrick::Log::DEBUG),# サーバログの出力
}

# 拡張子erbのファイルをERBを呼び出して処理するERBHandlerと関連付ける
WEBrick::HTTPServlet::FileHandler.add_handler("erb", WEBrick::HTTPServlet::ERBHandler)

# WEBrickのHTTP Serverクラスのサーバーインスタンスを生成する
s = WEBrick::HTTPServer.new( config )

# erbのMIMEタイプを設定
s.config[:MimeTypes]["erb"] = "text/html"

# 処理の登録
# /signupは新規登録のアクション
s.mount_proc("/login") { |req, res|

	# p req.query

	# ログインが成功しているかどうかのフラグ
	# 0:ログイン失敗 1:ログイン成功
	login_frag = 0

	# パスワードをハッシュ値にする処理
	pass = Digest::MD5.new.update(req.query['password_login']).to_s
	# puts pass

	user = User.all
	user.each do |row|
		if(pass = row.password)
			puts 'パスワード OK'

			if((req.query['username_login']==row.user_name)||((req.query['username_login']==row.email)))
				puts 'ユーザネームかemail OK'

				# ログイン成功したのでフラグを1にする
				login_frag = 1

				# とりあえず動かすために
				login_user = LoginUser.new
				login_user.set_userid(row.user_id)

				# 処理の結果を表示する
				# ERBを、ERBHandlerを経由せずに直接呼び出して利用している
				template = ERB.new( File.read('index.erb') )
				res.body << template.result( binding )

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
		res.body << template.result( binding )

	end
}

# /signupは新規登録のアクション
s.mount_proc("/signup") { |req, res|

	# p req.query

	# サインアップが成功したかどうかのフラグ
	# 0:サインアップ失敗 1:サインアップ
	signin_frag = 1

	# パスワードをハッシュ値にする処理
	pass = Digest::MD5.new.update(req.query['password']).to_s
	# puts pass

	user = User.all
	user.each do |row|

		# ユーザネーム、email,passwordが既に使われているかどうかの判定
		if req.query['username']==row.user_name
			signin_frag = 0
		elsif req.query['email']==row.email
			singin_frag = 0
		elsif req.query['password']==row.password
			singin_frag = 0
		end

	end

	if(signin_frag==1)

		User.create(user_id: nil, user_name: "#{req.query['username']}", image_name: 'takuma.jpg', continuity: 25, firstname: "#{req.query['firstname']}", lastname: "#{req.query['lastname']}", password: "#{pass.to_s}", email: "#{req.query['email']}" )

		# ログインユーザのidを取り出す
		user_id = User.all.order("user_id desc").first

		# ログインユーザの情報をセットする
		login_user = LoginUser.new
		login_user.set_userid(user_id.user_id)

		# 処理の結果を表示する
		# ERBを、ERBHandlerを経由せずに直接呼び出して利用している
		template = ERB.new( File.read('index.erb') )
		res.body << template.result( binding )

	else

		# 処理の結果を表示する
		# ERBを、ERBHandlerを経由せずに直接呼び出して利用している
		template = ERB.new( File.read('failed_signin.erb') )
		res.body << template.result( binding )

	end


}

# 処理の登録
# "http://localhost:8099/log"で呼び出される
# /logは学習を記録するアクション
s.mount_proc("/log") { |req, res|

	# (注意)本来ならここで入力データに危険や不正がないかチェックするがとりあえず割愛
	p req.query

	# dbhを作成し、データベース'research_log.db'に接続
	dbh = DBI.connect( 'DBI:SQLite3:research_log.db' )

	# 天気情報を持ってくる
	weather = weather()
	w_frag = weather_frag("#{weather['telop']}")

	# テーブルにデータを追加する
	dbh.do("insert into tasks values(null, #{req.query['user_id']}, #{req.query['category_id']}, '#{req.query['task_name']}', '#{req.query['start_time']}', '#{req.query['finish_time']}', #{req.query['group_frag']}, '#{req.query['comment']}', #{req.query['music_frag']}, #{w_frag});")

	# データベースとの接続を終了する
	dbh.disconnect

	# 処理の結果を表示する
	# ERBを、ERBHandlerを経由せずに直接呼び出して利用している
	template = ERB.new( File.read('index.erb') )
	res.body << template.result( binding )

}


#Ctrl-C割り込みがあった場合にサーバーを停止する処理を登録しておく
trap(:INT) do
	s.shutdown
end

# 上記記述の処理をこなすサーバーを開始する
s.start
