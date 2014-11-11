require "sinatra"
require "sinatra/activerecord"

set :database, "sqlite3:users.db"

class User < ActiveRecord::Base
end

get "/" do
  users = User.order("created_at DESC")
  users.to_json
end