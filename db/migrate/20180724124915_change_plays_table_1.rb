class ChangePlaysTable1 < ActiveRecord::Migration[5.2]
  def change
	rename_column :plays, :set, :num_set
	rename_column :plays, :leg, :num_leg
  end
end
