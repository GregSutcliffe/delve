class Document < ActiveRecord::Base
  has_many :pages, dependent: :destroy
  acts_as_taggable

  validates :name, presence: true, uniqueness: true
  validates :location, presence: true

  default_scope -> { order('created_at DESC') }

  def form_pages= pages
    self.pages = Page.where(:id => pages)
  end
end
