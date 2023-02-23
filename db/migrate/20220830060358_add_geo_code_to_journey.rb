class AddGeoCodeToJourney < ActiveRecord::Migration[7.0]
  def change
    add_column :journeys, :latitude, :float
    add_column :journeys, :longitude, :float
  end
end
