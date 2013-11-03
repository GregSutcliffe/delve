
class Document < ActiveRecord::Base

  include FileCleanup

  has_many :pages, dependent: :destroy
  before_destroy { |d| d.ensure_file_deleted pdf_path }
  acts_as_taggable
  scoped_search :on => [:name, :location]
  scoped_search :on => :relevant_date, :aliases => [:date]


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
    images = Magick::ImageList.new(location) do
      self['density'] = '300' # use 300 DPI for pdf conversion, same as for scanning
    end
    images.each do |image|
      name     = Time.now.strftime(DATE_FORMAT) + ".jpg"
      location = File.join(STORAGE_DIR,name)
      image.write(location)
      pdf_pages << Page.create(:path => name)
    end

    self.pages << pdf_pages
    self.save
  end

  # refactor this with the pdf image save block on line 34
  def file_upload_jpeg path_to_file
    name = Time.now.strftime(DATE_FORMAT) + ".jpg"
    location = File.join(STORAGE_DIR,name)
    FileUtils.cp path_to_file, location
    Page.create(:path => name, :document => self )
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

  def method_missing(method, *args, &block)
    case method.to_s
    when /file_upload/
      Rails.logger.info "Support for #{method.to_s} not implemented yet"
      self.errors.add :format, "#{method.to_s.gsub(/file_upload_/,'').upcase} is not implemented yet"
      self
    else
      super
    end
  end


end
