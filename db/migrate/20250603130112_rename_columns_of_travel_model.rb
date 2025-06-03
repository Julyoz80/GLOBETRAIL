class RenameColumnsOfTravelModel < ActiveRecord::Migration[7.1]
  def change
    rename_column :travels, :stop, :stops
    rename_column :travels, :accommodation, :accommodations
    rename_column :travels, :activity, :activities
  end
end
