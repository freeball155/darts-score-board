class ChangePlaysTable2 < ActiveRecord::Migration[5.2]
  def change
	change_column :plays, :dart1, :string	
	change_column :plays, :dart2, :string	
	change_column :plays, :dart3, :string	
  end
end
