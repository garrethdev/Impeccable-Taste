class RemoveUnnecessaryUserInfo < ActiveRecord::Migration
  def change
    remove_column :users, :oauth_token
    remove_column :users, :oauth_secret
  end
end
