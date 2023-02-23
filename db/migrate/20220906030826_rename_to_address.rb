class RenameToAddress < ActiveRecord::Migration[7.0]
  def change
    rename_column :journeys, :location, :address
  end
end
