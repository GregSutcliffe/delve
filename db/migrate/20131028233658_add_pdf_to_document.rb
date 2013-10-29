class AddPdfToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :pdf_path, :string
  end
end
