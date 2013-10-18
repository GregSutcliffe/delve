class AddDocumentIdToPages < ActiveRecord::Migration
  def change
    change_table :pages do |t|
      t.remove  :label
      t.integer :document_id
      t.index [:document_id, :created_at]
    end
  end
end
