class CreateJourneys < ActiveRecord::Migration[7.0]
  def change
    create_table :journeys do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :body
      t.string :photo

      t.timestamps
    end
  end
end
