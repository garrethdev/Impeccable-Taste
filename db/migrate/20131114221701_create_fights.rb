class CreateFights < ActiveRecord::Migration
  def change
      create_table(:fights) do |t|
      t.string :first_actor
      t.string :second_actor
      t.integer :access_count
      t.timestamps
    end
  end
end
