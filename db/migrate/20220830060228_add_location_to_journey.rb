class AddLocationToJourney < ActiveRecord::Migration[7.0]
  def change
    add_column :journeys, :location, :string
  end
end
