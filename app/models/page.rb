class Page < ActiveRecord::Base

  include FileCleanup

  STORAGE_DIR = ::Rails.root.join('public','scans')
  DATE_FORMAT = '%F_%H-%M-%S.%L'

  before_destroy { |p| p.ensure_file_deleted path }

  belongs_to :document
  validates :path, presence: true, uniqueness: true
  scope :without_document, -> { where(document_id: nil) }
  default_scope -> { order('created_at ASC') }

  private

  def self.file_upload_jpeg name,path_to_file
    name = Time.now.strftime(DATE_FORMAT) + ".jpg"
    location = File.join(STORAGE_DIR,name)
    FileUtils.cp path_to_file, location
    Page.create(:path => name)
  end

  def self.method_missing(method, *args, &block)
    case method.to_s
    when /file_upload/
      Rails.logger.info "Support for #{method.to_s} not implemented yet"
      p=Page.new
      p.errors.add :format, "#{method.to_s.gsub(/file_upload_/,'').upcase} is not implemented yet"
      p
    else
      super
    end
  end

end
