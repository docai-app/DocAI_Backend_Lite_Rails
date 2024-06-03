# frozen_string_literal: true

class Chatbot < ApplicationRecord
  resourcify
  has_paper_trail

  enum category: %i[qa chart_generation statistical_generation]

  ALLOWED_SELECTED_FEATURES = %w[chatting intelligent_mission smart_extract_schema chatting_plus
                                 reading_comprehension].freeze

  DEFAULT_SELECTED_FEATURES_TITLES = {
    'chatting' => '基本問題',
    'intelligent_mission' => '推薦功能',
    'smart_extract_schema' => '數據生成',
    'chatting_plus' => '專業對話',
    'reading_comprehension' => '閱讀理解'
  }.freeze

  belongs_to :user, optional: true, class_name: 'User', foreign_key: 'user_id'
  belongs_to :object, polymorphic: true, optional: true, dependent: :destroy
  has_many :messages, -> { order('messages.created_at') }, dependent: :destroy
  has_many :log_messages, -> { order('log_messages.created_at') }, dependent: :destroy
  has_one :marketplace_item, dependent: :destroy

  after_create :set_permissions_to_owner
  after_create :handle_initial_publication
  before_save :check_public_status_change, :check_default_values

  validate :validate_selected_features

  def check_default_values
    self['meta']['language'] = '繁體中文' if self['meta']['language'].nil?
  end

  def set_permissions_to_owner
    return if self['user_id'].nil?

    user.add_role :r, self
    user.add_role :w, self
  end

  def has_rights_to_read?(user)
    return true if user_id.nil?

    user.has_role? :r, self
  end

  def has_rights_to_write?(user)
    return true if user_id.nil?

    user.has_role? :w, self
  end

  def has_rights_to_read_and_write?(user)
    return true if user_id.nil?

    user.has_role? :r, self
    user.has_role? :w, self
  end

  def increment_access_count!
    increment(:access_count).save
  end

  def has_expired?
    expired_at.present? && Time.current > expired_at
  end

  def add_message(role, object_type, content, meta = {})
    messages << Message.new(chatbot_id: id, role:, object_type:, content:, meta:)
  end

  def get_chatbot_messages(user_id)
    puts "Get chatbot messages: #{user_id}"
    messages.where("meta->>'belongs_user_id' = ?", user_id).order(created_at: :desc)
  end

  def update_assistive_questions(getSubdomain, metadata)
    res = AiService.assistantQASuggestion(getSubdomain, metadata)
    puts "Res: #{res}"
    if res['assistant_questions'].present?
      puts "Res assistive_questions: #{res['assistant_questions']}"
      self.assistive_questions = res['assistant_questions']
    else
      self.assistive_questions = []
    end
    save
  end

  def assistant
    return AssistantAgent.where(name_en: 'default_agent', version: 'production').first if meta['assistant'].nil?

    AssistantAgent.find(meta['assistant'])
  end

  def experts
    return [] if meta['experts'].nil?

    AssistantAgent.includes(:agent_tools).where(id: meta['experts'])
  end

  def handle_initial_publication
    return unless is_public == true

    publish_to_marketplace
  end

  def check_public_status_change
    return unless is_public_changed?

    if is_public
      publish_to_marketplace
    else
      unpublish_from_marketplace
    end
  end

  def publish_to_marketplace
    marketplace_item = self.marketplace_item || build_marketplace_item
    marketplace_item.update(
      chatbot_id: id,
      user_id:,
      entity_name: Apartment::Tenant.current,
      chatbot_name: name,
      chatbot_description: description
    )
  end

  def unpublish_from_marketplace
    marketplace_item&.destroy
  end

  def validate_selected_features
    return if meta['selected_features'].nil?

    return if meta['selected_features'].all? { |feature| ALLOWED_SELECTED_FEATURES.include?(feature) }

    errors.add(:meta, "selected_features can only include allowed features: #{ALLOWED_SELECTED_FEATURES.join(', ')}")
  end
end
