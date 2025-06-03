class AddColumnsToTravel < ActiveRecord::Migration[7.1]
  def change
    add_column :travels, :budget, :integer
    add_column :travels, :number_of_travellers, :integer
    add_column :travels, :trip_duration, :integer
  end
end
