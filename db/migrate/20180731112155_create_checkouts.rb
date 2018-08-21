class CreateCheckouts < ActiveRecord::Migration[5.2]
  def change
    create_table :checkouts do |t|
      t.integer :points
      t.text :combination

      t.timestamps
    end
  end
end
