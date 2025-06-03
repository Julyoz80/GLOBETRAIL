class CreateTravels < ActiveRecord::Migration[7.1]
  def change
    create_table :travels do |t|
      t.string :country
      t.string :stop
      t.string :accommodation
      t.string :activity
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
