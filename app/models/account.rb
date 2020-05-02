class Account < ActiveRecord::Base
    belongs_to :user

    def deposit(amount)
        self.balance += amount
        self.save
    end

    def withdraw(amount)
        self.balance -= amount
        self.save
    end

    def valid_withdraw?(amount)
        self.balance >= amount
    end

end