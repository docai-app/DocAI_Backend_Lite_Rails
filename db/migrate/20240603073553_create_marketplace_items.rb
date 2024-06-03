# frozen_string_literal: true

class CreateMarketplaceItems < ActiveRecord::Migration[7.0]
  def change
    create_table :marketplace_items, id: :uuid do |t|
      t.uuid :chatbot_id
      t.uuid :user_id
      t.string :entity_name, null: false
      t.string :chatbot_name, null: false
      t.string :chatbot_description

      t.timestamps
    end

    add_index :marketplace_items, :entity_name
  end
end
