# frozen_string_literal: true

class CreateChatbots < ActiveRecord::Migration[7.0]
  def change
    create_table :chatbots, id: :uuid do |t|
      t.string :name
      t.string :description
      t.uuid :user_id, null: false
      t.integer :category, default: 0, null: false
      t.jsonb :meta
      t.jsonb :source
      t.boolean :is_public, default: false, null: false
      t.datetime :expired_at
      t.integer :access_count, default: 0
      t.string :object_type
      t.uuid :object_id
      t.jsonb :assistive_questions, null: false
      t.boolean :has_chatbot_updated, default: false, null: false
      t.integer :energy_cost, default: 0
      t.string :dify_token

      t.timestamps
    end

    add_index :chatbots, :category
    add_index :chatbots, :dify_token
    add_index :chatbots, :user_id
  end
end
