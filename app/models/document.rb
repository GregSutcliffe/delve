class Document < ActiveRecord::Base
  has_many :pages, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  validates :location, presence: true
end
