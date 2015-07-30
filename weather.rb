require 'net/http'
require 'uri'
require 'json'

# 天気情報が入ったハッシュを返すメソッド
def weather
	# 函館の気温を取得する処理
	uri = URI.parse('http://weather.livedoor.com/forecast/webservice/json/v1?city=017010')
	json = Net::HTTP.get(uri)
	result = JSON.parse(json)

	# 天気情報を入れるハッシュ
	weather = {}

	result['forecasts'].first(1).each do |forecast|

		# 最高気温のデータがnilの時は'--'を代入する処理
		if forecast['temperature']['max'].nil?
			max_celsius = '--'
		else
			max_celsius = forecast['temperature']['max']['celsius']
		end

		# 最低気温のデータがnilの時は'--'を代入する処理
		if forecast['temperature']['min'].nil?
			min_celsius = '--'
		else
			min_celsius = forecast['temperature']['min']['celsius']
		end

		# 日にち
		weather['date'] = forecast['date']

		# 都市名
		weather['city'] = result['location']['city']

		# 天気
		weather['telop'] = forecast['telop']

		# 最高気温
		weather['max_celsius'] = max_celsius

		# 最低気温
		weather['min_celsius'] = min_celsius

		# 天気アイコンのタイトル
		weather['icon_title'] = forecast['image']['title']

		# 天気アイコンURL
		weather['icon'] = forecast['image']['url']

		# デバック
		print "デバック:#{weather}", "\n"

	end

	return weather
end


# 天気情報のテロップを入れると天気が良いか悪いかを判定してフラグを返すメソッド
# 天気が良いの定義は天気に晴か曇りしか入っていないもの。
# 天気が悪いは雨と雪と暴風雪が入っており晴れが入っていないもの。
# どちらでもないは晴れと雨か雪のいずれかが入っているものとくもり。
# 良い => 1  悪い => 2  どちらでもない => 3
def weather_frag( telop )

	weather_num = {
						# 天気が良い => 1
						"晴"          => 1,
						"晴時々曇"     => 1,
						"晴のち曇"     => 1,
						"曇時々晴"     => 1,
						"曇のち晴"     => 1,

						# 天気が悪い => 2
						"暴風雪"       => 2,
						"曇時々雨"      => 2,
						"曇時々雪"      => 2,
						"曇のち雨"      => 2,
						"曇のち雪"      => 2,
						"雨"           => 2,
						"雨時々曇"      => 2,
						"雨時々晴れ"    => 2,
						"雨時々雪"      => 2,
						"雨のち晴"      => 2,
						"雨のち曇"      => 2,
						"雨のち雪"      => 2,
						"暴風雨"       => 2,
						"雪"           => 2,
						"雪時々晴"      => 2,
						"雪時々雨"      => 2,
						"雪時々曇"      => 2,
						"雪のち曇"      => 2,
						"雪のち晴"      => 2,
						"雪のち雨"      => 2,

						# どちらでもない => 3
						"晴時々雨"      => 3,
						"晴時々雪"      => 3,
						"晴のち雨"      => 3,
						"晴のち雪"      => 3,
						"曇り"         => 3,
						"曇"           => 3

					}


	return weather_num["#{telop}"]

end

# デバック
puts "weather_fragのデバッグ"
puts (weather_frag("曇り"))


