# frozen_string_literal: true

class CreatePurchases < ActiveRecord::Migration[7.0]
  def change
    create_table :purchases, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :marketplace_item_id, null: false
      t.datetime :purchased_at
      t.jsonb :meta

      t.timestamps
    end

    add_index :purchases, :marketplace_item_id
    add_index :purchases, :user_id
  end
end
