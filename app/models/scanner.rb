require 'sane'
class Scanner < ActiveRecord::Base

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :device_url
  validates_uniqueness_of :device_url

  def get_image
    command = "scanimage -d #{device_url}"
    Rails.logger.debug "Executing '#{command}'"
    image = `#{command}`
    unless $? == 0
      Rails.logger.warn "Failed to scan image"
      raise "Execution of scanimage failed, check log files"
    end
    File.write('/tmp/image',image)
  end

end
