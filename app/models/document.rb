class Document < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :location, presence: true
end
