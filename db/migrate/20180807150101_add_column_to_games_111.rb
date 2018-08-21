class AddColumnToGames111 < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :player_won, :integer
  end
end
