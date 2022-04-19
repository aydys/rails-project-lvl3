class Bulletin < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :category

  has_one_attached :image

  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :image, attached: true, content_type: %i[png jpeg jpg],
                    size: { less_than: 5.megabytes, message: 'is not given between size' }

  scope :by_recently_created, -> { order(created_at: :desc) }
end
