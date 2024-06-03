# frozen_string_literal: true

class UserMarketplaceItem < ApplicationRecord
  belongs_to :user, polymorphic: true
  belongs_to :marketplace_item
  belongs_to :purchase
  has_many :messages, dependent: :destroy

  def self.ransackable_attributes(_auth_object = nil)
    %w[custom_name]
  end

  def save_message(user, role, object_type, content, meta = {})
    messages.create!(
      user:,
      chatbot_id: marketplace_item.chatbot_id,
      role:,
      object_type:,
      content:,
      meta:
    )
  end

  def get_chatbot_messages(user_id)
    puts "Get chatbot messages: #{user_id}"
    messages.where("meta->>'belongs_user_id' = ?", user_id).order(created_at: :desc)
  end
end
