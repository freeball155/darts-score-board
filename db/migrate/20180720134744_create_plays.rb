class CreatePlays < ActiveRecord::Migration[5.2]
  def change
    create_table :plays do |t|
      t.integer :game_id
      t.integer :set
      t.integer :leg
      t.integer :turn
      t.integer :player
      t.integer :dart1
      t.integer :dart2
      t.integer :dart3

      t.timestamps
    end
  end
end
