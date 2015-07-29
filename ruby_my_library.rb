#! /usr/bin/ruby
# -*- coding: utf-8


# 本日までの連続学習記録日数と継続性の値を受け取り、
# それに応じた継続性の変化量分継続性の値を変化させて返すメソッド
def continuity_cal( continuity, diff )


	# 継続性の変化量を場合分けして決める
	if diff.empty? 

		var = -5

	elseif diff == 1

		var = 1

	elseif diff == 2

		var = 2

	elseif diff == 3

		var = 3

	elseif diff == 4
        
		var = 4

	elseif  5 <= diff

		var = 5
	end 

	# 継続性の値を変化させる
	continuity = continuity + var

	# 継続性の値を0から100の間の数値に整形する処理
	if continuity < 0

		continuity = 0

	elseif  100 < continuity 

		continuity = 100

	end

	return continuity

end