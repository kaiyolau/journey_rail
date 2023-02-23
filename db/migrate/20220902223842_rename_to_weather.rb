class RenameToWeather < ActiveRecord::Migration[7.0]
  def change
    rename_column :journeys, :photo, :weather
  end
end
