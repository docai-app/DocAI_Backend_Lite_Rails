# frozen_string_literal: true

class MarketplaceItem < ApplicationRecord
  belongs_to :user, optional: true, class_name: 'User', foreign_key: 'user_id'

  has_many :purchases, dependent: :destroy
  has_many :purchasers, through: :purchases, source: :user
  has_many :user_marketplace_items, dependent: :destroy
  has_many :users, through: :user_marketplace_items, source: :user, dependent: :destroy

  validates :chatbot_id, presence: true
  validates :entity_name, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[chatbot_name]
  end

  def purchase_by(user, custom_name = '', custom_description = '')
    ActiveRecord::Base.transaction do
      purchase = Purchase.create!(user:, marketplace_item: self, purchased_at: Time.current)
      UserMarketplaceItem.create!(
        user:,
        marketplace_item: self,
        purchase:,
        custom_name:,
        custom_description:
      )
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error(e)
    false
  end
end
