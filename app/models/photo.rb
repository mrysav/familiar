class Photo < ApplicationRecord
  include PgSearch
  multisearchable against: %i[title description tag_list]

  has_one_attached :image

  acts_as_taggable_on :tags
  acts_as_taggable_on :people_tags

  validates :image, presence: true
  validates :title, presence: true

  has_many :comments, as: :commentable, dependent: :destroy

  def self.tagged(person)
    if person.is_a? Person
      return Photo.tagged_with(person.tag_name, on: :people_tags)
    end
    []
  end

  def edtf_date
    EDTF.parse(date)
  end
end
