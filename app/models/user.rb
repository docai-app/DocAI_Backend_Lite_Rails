# frozen_string_literal: true

# == Schema Information
#
# Table name: public.users
#
#  id                     :uuid             not null, primary key
#  email                  :string
#  encrypted_password     :string
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  nickname               :string
#  phone                  :string
#  date_of_birth          :date
#  sex                    :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  timezone               :string           default("Asia/Hong_Kong"), not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
require_dependency 'has_kg_linker'

class User < ApplicationRecord
  devise :database_authenticatable,
         :jwt_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         jwt_revocation_strategy: JwtDenylist

  has_one :energy, as: :user, dependent: :destroy
  has_many :purchases, as: :user, dependent: :destroy
  has_many :purchased_marketplace_items, through: :purchases, source: :marketplace_item
  has_many :user_marketplace_items, dependent: :destroy, as: :user, class_name: 'UserMarketplaceItem'
  has_many :marketplace_items, through: :user_marketplace_items
  has_many :user_files, dependent: :destroy, class_name: 'UserFile'
  has_many :user_feeds, dependent: :destroy, class_name: 'UserFeed'

  has_many :assessment_records, as: :recordable
  has_many :scheduled_tasks, as: :user, dependent: :destroy

  scope :search_query, lambda { |query|
    return nil if query.blank?

    terms = query.to_s.downcase.split(/\s+/)
    terms = terms.map do |e|
      "%#{"#{e.gsub('*', '%')}%".gsub(/%+/, '%')}"
    end
    num_or_conditions = 1
    where(
      terms.map do
        or_clauses = [
          'LOWER(nickname) LIKE ?'
        ].join(' OR ')
        "(#{or_clauses})"
      end.join(' AND '),
      *terms.map { |e| [e] * num_or_conditions }.flatten
    )
  }

  def jwt_payload
    {
      'sub' => id,
      'iat' => Time.now.to_i,
      'email' => email
    }
  end

  def consume_energy(marketplace_item_id, energy_cost)
    if energy.value >= energy_cost
      energy.update(value: energy.value - energy_cost)
      EnergyConsumptionRecord.create!(
        user: self,
        marketplace_item_id:,
        energy_consumed: energy_cost
      )
      true
    else
      false
    end
  end

  def chatbots
    chatbot_details = []

    purchased_items.each do |item|
      next unless item['marketplace_item']

      chatbot_info = item['marketplace_item']
      chatbot_details << {
        chatbot_id: chatbot_info['chatbot_id'],
        chatbot_name: chatbot_info['chatbot_name'],
        chatbot_description: chatbot_info['chatbot_description']
      }
    end

    chatbot_details.uniq
  end

  def check_can_consume_energy(_chatbot, energy_cost)
    energy.value >= energy_cost
  end

  def purchased_items
    purchases.includes(:marketplace_item).as_json(include: :marketplace_item)
  end

  def method_missing(method_name, *arguments, &block)
    if method_name.to_s.start_with?('linked_')
      relation_name = method_name.to_s.sub('linked_', '')
      singular_relation_name = relation_name.to_s.singularize

      return linkable_relation(singular_relation_name) if respond_to_relation?(relation_name)
    end

    super
  end

  def respond_to_missing?(method_name, include_private = false)
    if method_name.to_s.start_with?('linked_')
      relation_name = method_name.to_s.sub('linked_', '')
      return respond_to_relation?(relation_name)
    end

    super
  end

  def linkable_relation(relation_name)
    linkers = KgLinker.where(map_from: self, relation: "has_#{relation_name}")

    return [] if linkers.empty?

    map_to_class = linkers.first.map_to_type.constantize
    map_to_class.where(id: linkers.pluck(:map_to_id))
  end

  def respond_to_relation?(_relation_name)
    true
  end
end
