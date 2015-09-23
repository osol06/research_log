#! /usr/bin/ruby
# -*- coding: utf-8
require 'webrick'
require 'erb'
require 'rubygems'
require 'dbi'
require './my_ruby_library/weather.rb'

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
s.mount_proc("/signup") { |req, res|

	p req.query

	# dbhを作成し、データベース'research_log.db'に接続
	dbh = DBI.connect( 'DBI:SQLite3:research_log.db' )

	# テーブルにデータを追加する
	dbh.do("insert into users values(null, '#{req.query['username']}', 'takuma.jpg', 25, '#{req.query['firstname']}', '#{req.query['lastname']}', '#{req.query['password']}', '#{req.query['email']}');")

	# データベースとの接続を終了する
	dbh.disconnect

	# 処理の結果を表示する
	# ERBを、ERBHandlerを経由せずに直接呼び出して利用している
	template = ERB.new( File.read('index.erb') )
	res.body << template.result( binding )

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
	dbh.do("insert into tasks values(null, #{req.query['user_id']}, #{req.query['category_id']}, '#{req.query['task_name']}', '#{req.query['start_time']}', '#{req.query['finish_time']}', #{req.query['group_frag']}, '#{req.query['comment']}', '#{req.query['music_frag']}', #{w_frag});")

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
