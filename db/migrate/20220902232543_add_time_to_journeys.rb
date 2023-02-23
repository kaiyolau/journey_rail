class AddTimeToJourneys < ActiveRecord::Migration[7.0]
  def change
    add_column :journeys, :timing, :datetime
  end
end
