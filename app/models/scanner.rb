class Scanner < ActiveRecord::Base

  validates :name, presence: true, length: { maximum: 50 }
  validates :device_url, presence: true, uniqueness: true

  def acquire
    # Use timestamp until we can think of something better
    if page = get_image
      file = File.basename(page.filename)
      return Page.new(:path => file)
    end
    return false
  end

  private

  def get_image
    command = "scanimage -d #{device_url}"
    Rails.logger.debug "Executing '#{command}'"
    image = `#{command}`
    unless $?.success?
      Rails.logger.warn "Failed to scan image"
      raise "Execution of scanimage failed, check log files"
    end
    img = Magick::Image::from_blob(image).first
    Rails.logger.debug dump_properties(img)
    target = img.properties['date:create'].to_time.strftime(DATE_FORMAT)
    img.write("#{STORAGE_DIR}/#{target}.jpg")
  rescue Exception => e
    Rails.logger.warn "Error saving page: #{e.message}"
    Rails.logger.warn e.backtrace
    return false
  end

  def dump_properties(img)
    string  = ""
    string += "Format: #{img.format}\n"
    string += "Geometry: #{img.columns}x#{img.rows}\n"
    string += "Depth: #{img.depth} bits-per-pixel\n"
    string += "Colors: #{img.number_colors}"
    string += "Filesize: #{img.filesize}\n"
    string += "Resolution: #{img.x_resolution.to_i}x#{img.y_resolution.to_i} "+
      "pixels/#{img.units == Magick::PixelsPerInchResolution ? "inch\n" : "centimeter\n"}"
    if img.properties.length > 0
      string += "Properties:\n"
      img.properties { |name,value|
        string += %Q|      #{name} = "#{value}"\n|
      }
    end
  end

end
