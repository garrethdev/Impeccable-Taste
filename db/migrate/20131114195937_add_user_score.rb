class AddUserScore < ActiveRecord::Migration
 def change
    add_column :users, :total_answered, :integer
    add_column :users, :total_correct, :integer
    add_column :users, :percentage_score, :float
    add_column :users, :created_at, :datetime
    add_column :users, :updated_at, :datetime
  end
end
