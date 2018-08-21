class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.integer :num_players
      t.text :players
      t.text :state
      t.text :type
      t.text :score
      t.integer :finish_type
      t.integer :points
      t.integer :num_legs
      t.integer :num_sets

      t.timestamps
    end
  end
end
