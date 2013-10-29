#Common methods for ensure file cleanup
module FileCleanup
  extend ActiveSupport::Concern

  included do

    def ensure_file_deleted(path_to_file)
      return true if path_to_file.blank?
      File.unlink(File.join(STORAGE_DIR,path_to_file))
    rescue Errno::ENOENT
      # already deleted
      true
    rescue Exception => e
      errors.add :base, "Cannot remove file: #{e.message}"
      Rails.logger.warn e.class
      Rails.logger.warn e.message
      Rails.logger.warn e.backtrace
      false
    end

  end
end
