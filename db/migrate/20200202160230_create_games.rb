class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.string :name
      t.references :created_by, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
