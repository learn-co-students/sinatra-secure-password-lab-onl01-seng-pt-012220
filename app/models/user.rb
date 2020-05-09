class User < ActiveRecord::Base
    validates :balance, numericality: {greater_than_or_equal_to: 0.00}
    has_secure_password
    after_initialize :defaults

    def defaults
        unless persisted?
            self.balance ||= 0.00
        end
    end
    
end
