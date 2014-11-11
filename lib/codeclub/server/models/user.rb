module Codeclub::Server
  class User < ActiveRecord::Base

    validates :username, length: { within: 1..10}
    #validates :username, format: { with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\Z/ }, uniqueness: { case_sensitive: false }
    
    #there is never a reason to return the password hash, so conrtol JSON serialization
    def as_json(options = {})
      json = {
        "username" => username,
        "email" => email
      }
      if options[:include_password_hash]
        json["password_hash"] = password_hash
      end
      json
    end
  end
end
