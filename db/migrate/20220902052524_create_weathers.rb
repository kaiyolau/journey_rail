class CreateWeathers < ActiveRecord::Migration[7.0]
  def change
    create_table :weathers do |t|
      t.references :journey, null: false, foreign_key: true
      t.text :weatherDay

      t.timestamps
    end
  end
end
