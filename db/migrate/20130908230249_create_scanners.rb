class CreateScanners < ActiveRecord::Migration
  def change
    create_table :scanners do |t|
      t.string :name
      t.string :device_url

      t.timestamps
    end
  end
end
