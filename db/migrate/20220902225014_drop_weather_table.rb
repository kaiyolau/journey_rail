class DropWeatherTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :weathers
  end
end
