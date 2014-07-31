class AddResolvedToFactData < ActiveRecord::Migration
  def change
    add_column :fact_data, :resolved, :boolean, default: false
  end
end
