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





