class AddDateToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :relevant_date, :date
  end
end
