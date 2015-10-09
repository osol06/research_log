# -*- encoding: utf-8 -*-
require "rubygems"
require "mysql2"
require "yaml"
require "active_record"


config = YAML.load_file( './database.yml' )
# 環境を切り替える
ActiveRecord::Base.establish_connection(config["db"]["development"])

# テーブルにアクセスするためのクラスを宣言
class User < ActiveRecord::Base
end

# レコード取得
p User.all
