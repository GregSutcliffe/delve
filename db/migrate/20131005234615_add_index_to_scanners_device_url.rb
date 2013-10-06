class AddIndexToScannersDeviceUrl < ActiveRecord::Migration
  def change
    add_index :scanners, :device_url, unique: true
  end
end
