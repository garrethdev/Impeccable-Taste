class TablesForDatabase < ActiveRecord::Migration
 def change
    create_table(:actors) do |t|
      t.string :name
      t.integer :avg_rating
    end
    create_table(:users) do |t|
      t.string :oauth_token
      t.integer :oauth_secret
      t.string :username
    end
    create_table(:fightscenes) do |t|
      t.string :name
      t.string :video
    end
  end
end
