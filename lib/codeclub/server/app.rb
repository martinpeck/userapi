require "sinatra"
require "sinatra/activerecord"
require "codeclub/server/models/user"
require "codeclub/server/helpers"
require "scrypt"

set :database, "sqlite3:users.db"

module Codeclub::Server
  class App < Sinatra::Base

    include Helpers

    API_KEY_NAME = "HTTP_X_CODECLUB_API_KEY"
    API_KEY_VALUE = "foobar"

    get "/users", provides: :json do
      users = User.order("created_at DESC")
      users.to_json
    end

    get "/users/:username", provides: :json do | username |
      user = User.find_by_username(username)
      halt 404 if user.nil?
      if request.env[API_KEY_NAME] == API_KEY_VALUE then
        user.to_json(include_password_hash: true) 
      else
        user.to_json
      end
    end

    delete "/users/:username", provides: :json do | username |
      api_key = request.env[API_KEY_NAME]
      halt 403 if api_key.nil?
      halt 401 if api_key != API_KEY_VALUE
      user = User.find_by_username(username)
      halt 404 if user.nil?
      user.delete
    end

    post "/users", provides: :json do

      user_details = json_body

      user = User.new do |u|
        u.username = user_details["username"]
        u.email = user_details["email"]
        u.password_hash = SCrypt::Password.create(user_details["password"])
      end

      begin
        user.save!
      rescue => e
        halt 400, e.message
      end
    end
  end
end
