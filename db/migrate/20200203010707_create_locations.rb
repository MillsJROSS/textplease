class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.string :name
      t.references :game, null: false, foreign_key: true, index: true
      t.text :enter_location_text

      t.timestamps
    end
  end
end
