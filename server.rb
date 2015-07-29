#! /usr/bin/ruby
# -*- coding: utf-8
require 'webrick'
require 'erb'
require 'rubygems'
require 'dbi'
require './ruby_my_library.rb'

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
# "http://localhost:8099/log"で呼び出される
s.mount_proc("/log") { |req, res|

	# (注意)本来ならここで入力データに危険や不正がないかチェックするがとりあえず割愛
	p req.query

	#dbhを作成し、データベース'research_log.db'に接続
	dbh = DBI.connect( 'DBI:SQLite3:research_log.db' )

	# テーブルにデータを追加する
	dbh.do("insert into tasks values(null, #{req.query['user_id']}, #{req.query['category_id']}, '#{req.query['task_name']}', '#{req.query['start_time']}', '#{req.query['finish_time']}', #{req.query['group_frag']}, '#{req.query['comment']}', '#{req.query['music_frag']}');")

	# データベースからユーザの
	sth_continuity = dbh.execute("select continuity from users where user_id = #{req.query['user_id']}")

	sth_continuity.first(1).each do |row_continuity|

		# ユーザの継続性の値を持ってくる
		continuity = row_continuity["continuity"]

	end

	# 記録したユーザの本日までの連続記録日数を取り出す処理
	sth_continuity_log = dbh.execute("select user_id
										,d1
										,d2
										,max(diff)
								from(
 										select t1.user_id
  												,date(t1.start_time) as d1
  												,date(t2.start_time) as d2
  												,julianday(date(t2.start_time)) - julianday(date(t1.start_time)) + 1 as diff
  								from ( select * from tasks group by user_id, date(start_time)) as t1
  								left join ( select * from tasks group by user_id, date(start_time)) as t2
  								on t1.user_id = t2.user_id
  								and date(t1.start_time) <= (t2.start_time)
  								inner join ( select * from tasks group by user_id, date(start_time)) as t3
  								on date(t3.start_time) between date(t1.start_time) and (t2.start_time)
  								and t1.user_id = t3.user_id
  								where date('now', 'localtime') = date(t2.start_time)
  								group by t1.user_id,d1,d2
  								having count(*)=diff
								) where user_id =  #{req.query['user_id']}
								group by user_id;")

	sth_continuity_log.first(1).each do |row_continuity_log|

		puts row_continuity_log["max(diff)"]
		# 本日を含めて連続で何日記録しているかを持ってくる
		diff = row_continuity_log["max(diff)"]
		puts diff

	end

	# 継続性を計算して持ってくる
	continuity = continuity_cal( continuity, diff )

	puts "継続性の値"
	puts continuity

	dbh.do("update users set continuity = #{continuity} where user_id = #{req.query['user_id']};")

	# ステートメントハンドラの開放
	sth_continuity.finish
	sth_continuity_log.finish

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