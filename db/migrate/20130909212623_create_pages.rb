class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :label
      t.string :path

      t.timestamps
    end
  end
end
