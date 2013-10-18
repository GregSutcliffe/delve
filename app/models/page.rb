class Page < ActiveRecord::Base

  STORAGE_DIR = ::Rails.root.join('public','scans')
  DATE_FORMAT = '%F_%H-%M-%S'

  before_destroy :ensure_file_deleted

  belongs_to :document
  default_scope -> { order('created_at DESC') }
  validates :path, presence: true, uniqueness: true

  private

  def ensure_file_deleted
    File.unlink(File.join(STORAGE_DIR,path))
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
