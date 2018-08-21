class CreateGamesStats < ActiveRecord::Migration[5.2]
  def change
    create_table :games_stats do |t|
      t.integer :game_id
      t.integer :player_id
      t.integer :total_points
      t.integer :total_darts
      t.integer :max_score

      t.timestamps
    end
  end
end
