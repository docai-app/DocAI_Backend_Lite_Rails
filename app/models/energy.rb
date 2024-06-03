# frozen_string_literal: true

class Energy < ApplicationRecord
  belongs_to :user, dependent: :destroy, class_name: 'User', foreign_key: 'user_id'
end
