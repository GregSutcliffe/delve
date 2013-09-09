require 'sane'
class Scanner < ActiveRecord::Base

  STORAGE_DIR = ::Rails.root.join('public','scans')

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :device_url
  validates_uniqueness_of :device_url

  def acquire
    # Use timestamp until we can think of something better
    label = Time.now.strftime('%F_%H%-M%-S')
    get_image(label)
    Page.create(:label => label, :path => "#{label}.ppm")
  end
   
  private

  def get_image(target)
    command = "scanimage -d #{device_url}"
    Rails.logger.debug "Executing '#{command}'"
    image = `#{command}`
    unless $? == 0
      Rails.logger.warn "Failed to scan image"
      raise "Execution of scanimage failed, check log files"
    end
    File.write("#{STORAGE_DIR}/#{target}.ppm",image)
  end

end
