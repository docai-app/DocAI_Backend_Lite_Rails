# frozen_string_literal: true

class EnergyConsumptionRecord < ApplicationRecord
  belongs_to :user, dependent: :destroy, foreign_key: :user_id
  belongs_to :marketplace_item, dependent: :destroy, foreign_key: :marketplace_item_id
end
