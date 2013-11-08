class Page < ActiveRecord::Base

  include FileCleanup

  before_destroy { |p| p.ensure_file_deleted path }

  belongs_to :document
  acts_as_list scope: :document

  validates :path, presence: true, uniqueness: true
  scope :without_document, -> { where(document_id: nil) }
  default_scope -> { order('position ASC, id ASC') }

  def rotate! direction
    angle = direction == "clockwise" ? 90 : -90

    location = File.join(STORAGE_DIR,path)
    img = Magick::Image::read(location).first
    img.rotate! angle
    img.write(location)
    self
  end

  private

end
