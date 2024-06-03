class UserFile < ApplicationRecord
  resourcify

  belongs_to :user
  belongs_to :user_marketplace_item

  validates :file_type, inclusion: { in: %w[pdf png jpg] }
  validates :file_url, presence: true
end