# frozen_string_literal: true

class CreateUserMarketplaceItems < ActiveRecord::Migration[7.0]
  def change
    create_table :user_marketplace_items, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :marketplace_item_id, null: false
      t.string :custom_name
      t.text :custom_description
      t.uuid :purchase_id, null: false
      t.jsonb :meta, null: false

      t.timestamps
    end

    add_index :user_marketplace_items, :marketplace_item_id
    add_index :user_marketplace_items, :purchase_id
    add_index :user_marketplace_items, :user_id
  end
end
