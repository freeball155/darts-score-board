class RemoveColumnsFromGames < ActiveRecord::Migration[5.2]
  def change
    remove_column :games, :curr_leg, :integer
    remove_column :games, :curr_set, :integer
  end
end
