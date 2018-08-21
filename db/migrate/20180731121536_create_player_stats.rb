class CreatePlayerStats < ActiveRecord::Migration[5.2]
  def change
    create_table :player_stats do |t|
      t.integer :player_id
      t.text :stat_code
      t.integer :stat_value

      t.timestamps
    end
  end
end
