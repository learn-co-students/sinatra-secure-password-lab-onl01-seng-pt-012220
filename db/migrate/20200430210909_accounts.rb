class Accounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.numeric :balance, :default => 0
      t.integer :user_id
    end
  end
end
