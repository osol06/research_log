# -*- encoding: utf-8 -*-
require "rubygems"
require "mysql2"
require "yaml"
require "active_record"


config = YAML.load_file( './database.yml' )
# 環境を切り替える
ActiveRecord::Base.establish_connection(config["db"]["development"])

# usersテーブルにアクセスするクラス
class User < ActiveRecord::Base
end

# categoriesテーブルにアクセスするクラス
class Category < ActiveRecord::Base
end

# taskテーブルにアクセスするクラス
class Task < ActiveRecord::Base
end

# taskテーブルにアクセスするクラス
class Task_name < ActiveRecord::Base
end

# taskテーブルにアクセスするクラス
class Weather < ActiveRecord::Base
end

# レコード取得
# puts User.all
# puts Category.all
# puts Task.all
# puts Task_name.all
# puts
