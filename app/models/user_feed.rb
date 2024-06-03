class UserFeed < ApplicationRecord
  belongs_to :user
  belongs_to :user_marketplace_item

  def self.ransackable_attributes(_auth_object = nil)
    %w[file_type]
  end
end