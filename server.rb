#! /usr/bin/ruby
# -*- coding: utf-8
require 'webrick'
require 'erb'
require 'rubygems'
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

# 拡張子のファイルをHandlerと関連付ける
WEBrick::HTTPServlet::FileHandler.add_handler("erb", WEBrick::HTTPServlet::ERBHandler)
WEBrick::HTTPServlet::FileHandler.add_handler("rhtml", WEBrick::HTTPServlet::ERBHandler)
WEBrick::HTTPServlet::FileHandler.add_handler("rb", WEBrick::HTTPServlet::CGIHandler)

# WEBrickのHTTP Serverクラスのサーバーインスタンスを生成する
s = WEBrick::HTTPServer.new( config )

# MIMEタイプを設定
s.config[:MimeTypes]["erb"] = "text/html"
s.config[:MimeTypes]["rhtml"] = "text/html"

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
		if(pass == row.password)
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
# /logは学習を記録するアクション
s.mount_proc("/log") { |req, res|

	# (注意)本来ならここで入力データに危険や不正がないかチェックするがとりあえず割愛
	# p req.query

	# 天気情報を持ってくる
	weather = weather()
	w_frag = weather_frag("#{weather['telop']}")

	login_user = LoginUser.new

	 p req.query['task_name']

	# 選択されたタスクidをもってきて
	# カウントを1つ上げる
	task_name = Task_name.find_by(user_id: login_user.get_userid(), task_name: "#{req.query['task_name']}")
	p task_name
	p task_name.count
	task_name.update(count: task_name.count + 1)

	# テーブルにデータを追加する
	# category_idは一旦保留で1を挿入する事にしている
	Task.create(task_id: nil, user_id: "#{login_user.get_userid()}", category_id: 1, task_name_id: task_name.task_name_id, task_name: "#{req.query['task_name']}", start_time: "#{req.query['start_time']}", finish_time: "#{req.query['finish_time']}", group_frag: req.query['group_frag'], comment: "#{req.query['comment']}", music_frag: req.query['music_frag'], weather_frag: w_frag )
	# p Task.all

	# 処理の結果を表示する
	# ERBを、ERBHandlerを経由せずに直接呼び出して利用している
	template = ERB.new( File.read('index.erb') )
	res.body << template.result( binding )

}

# 処理の登録
# /add_taskは学習を記録するアクション
s.mount_proc("/add_task") { |req, res|

	# (注意)本来ならここで入力データに危険や不正がないかチェックするがとりあえず割愛
	# p req.query
	p "タスクネーム"
	p req.query['task_name']
	login_user = LoginUser.new

	# テーブルにデータを追加する
	# category_idは一旦保留で1を挿入する事にしている
	Task_name.create(task_name_id: nil, user_id: "#{login_user.get_userid()}", task_name: "#{req.query['task_name']}", count: 1)
	# p Task.all

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
