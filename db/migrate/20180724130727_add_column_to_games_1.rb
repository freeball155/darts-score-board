class AddColumnToGames1 < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :curr_set, :integer
    add_column :games, :curr_leg, :integer
  end
end
