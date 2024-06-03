# frozen_string_literal: true

class Purchase < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  belongs_to :marketplace_item
end
