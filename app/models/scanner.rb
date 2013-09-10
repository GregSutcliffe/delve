require 'sane'
require 'RMagick'
class Scanner < ActiveRecord::Base

  STORAGE_DIR = ::Rails.root.join('public','scans')
  DATE_FORMAT = '%F_%H-%M-%S'

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :device_url
  validates_uniqueness_of :device_url

  def acquire
    # Use timestamp until we can think of something better
    if page = get_image
      time = page.properties['date:create'].to_time.strftime(DATE_FORMAT)
      file = File.basename(page.filename)
      return Page.create(:label => time, :path => file)
    end
    return false
  end

  private

  def get_image
    command = "scanimage -d #{device_url}"
    Rails.logger.debug "Executing '#{command}'"
    image = `#{command}`
    unless $? == 0
      Rails.logger.warn "Failed to scan image"
      raise "Execution of scanimage failed, check log files"
    end
    img = Magick::Image::from_blob(image).first
    dump_properties(img)
    target = img.properties['date:create'].to_time.strftime(DATE_FORMAT)
    img.write("#{STORAGE_DIR}/#{target}.jpg")
  rescue Exception => e
    Rails.logger.warn "Error saving page: #{e.message}"
    Rails.logger.warn e.backtrace
    return false
  end

  def dump_properties(img)
    Rails.logger.debug "Format: #{img.format}"
    Rails.logger.debug "Geometry: #{img.columns}x#{img.rows}"
    Rails.logger.debug "Class: " + case img.class_type
      when Magick::DirectClass
        "DirectClass"
      when Magick::PseudoClass
        "PseudoClass"
      end
    Rails.logger.debug "Depth: #{img.depth} bits-per-pixel"
    Rails.logger.debug "Colors: #{img.number_colors}"
    Rails.logger.debug "Filesize: #{img.filesize}"
    Rails.logger.debug "Resolution: #{img.x_resolution.to_i}x#{img.y_resolution.to_i} "+
      "pixels/#{img.units == Magick::PixelsPerInchResolution ? "inch" : "centimeter"}"
    if img.properties.length > 0
      Rails.logger.info "Properties:"
      img.properties { |name,value|
        Rails.logger.info %Q|      #{name} = "#{value}"|
      }
    end
  end

end
