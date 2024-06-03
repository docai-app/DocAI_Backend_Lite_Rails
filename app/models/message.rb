# frozen_string_literal: true

class Message < ApplicationRecord
  has_paper_trail

  store_accessor :meta, :belongs_user_id

  belongs_to :user, polymorphic: true
  belongs_to :chatbot, class_name: 'Chatbot', foreign_key: 'chatbot_id', optional: true, dependent: :destroy
  belongs_to :user_marketplace_item, optional: true, dependent: :destroy, foreign_key: 'user_marketplace_item_id'
end
