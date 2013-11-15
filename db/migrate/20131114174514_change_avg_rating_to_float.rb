class ChangeAvgRatingToFloat < ActiveRecord::Migration
  def up
    change_column :actors, :avg_rating, :float
  end
  def down
    change_column :actors, :avg_rating, :integer
  end
end
