require 'RMagick'

class Document < ActiveRecord::Base

  include FileCleanup

  STORAGE_DIR = ::Rails.root.join('public','scans')
  DATE_FORMAT = '%F_%H-%M-%S.%L'

  has_many :pages, dependent: :destroy
  before_destroy { |d| d.ensure_file_deleted pdf_path }
  acts_as_taggable

  validates :name, presence: true, uniqueness: true
  # Don't have to set a pdf_path, but it must be unique if it is set.
  validates :pdf_path, uniqueness: true, allow_nil: true, allow_blank: true


  default_scope -> { order('created_at DESC') }

  def form_pages= pages
    self.pages = Page.where(:id => pages)
  end

  def index_pdf! path_to_file
    return false if self.name.nil?
    # save the pdf
    filename = File.join('pdf',"#{self.id}_#{sanitize_filename(self.name.dup)}.pdf")
    location = File.join(STORAGE_DIR,filename)
    FileUtils.cp path_to_file, location
    self.pdf_path = filename

    # create pages
    pdf_pages = []
    images = Magick::ImageList.new(path_to_file)
    images.each do |image|
      name     = Time.now.strftime(DATE_FORMAT) + ".jpg"
      location = File.join(STORAGE_DIR,name)
      image.write(location)
      pdf_pages << Page.create(:path => name)
    end

    self.pages = pdf_pages
    self.save
  end

  private

  def sanitize_filename(filename)
    # NOTE: File.basename doesn't work right with Windows paths on Unix
    # get only the filename, not the whole path
    filename.gsub!(/^.*(\\|\/)/, '')

    # Strip out the non-ascii character
    filename.gsub!(/[^0-9A-Za-z.\-]/, '_')
    filename
  end

end
