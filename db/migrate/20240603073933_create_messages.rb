# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages, id: :uuid do |t|
      t.uuid :chatbot_id, null: false
      t.text :content, null: false
      t.string :role, default: 'user', null: false
      t.string :object_type, null: false
      t.boolean :is_read, default: false, null: false
      t.jsonb :meta
      t.uuid :user_marketplace_item_id
      t.uuid :user_id
      t.string :dify_conversation_id

      t.timestamps
    end

    add_index :messages, :chatbot_id
    add_index :messages, :dify_conversation_id
    add_index :messages, :object_type
    add_index :messages, :user_id
    add_index :messages, :user_marketplace_item_id
  end
end
