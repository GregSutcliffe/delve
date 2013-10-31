class Page < ActiveRecord::Base

  include FileCleanup

  before_destroy { |p| p.ensure_file_deleted path }

  belongs_to :document
  validates :path, presence: true, uniqueness: true
  scope :without_document, -> { where(document_id: nil) }
  default_scope -> { order('created_at ASC') }

  private

end
