class RemoveTravelFromMessages < ActiveRecord::Migration[7.1]
  def change
    remove_reference :messages, :travel, foreign_key: true
  end
end
