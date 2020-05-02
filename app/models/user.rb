class User < ActiveRecord::Base
    has_one :account
    
    validates_presence_of :username
    has_secure_password
end
