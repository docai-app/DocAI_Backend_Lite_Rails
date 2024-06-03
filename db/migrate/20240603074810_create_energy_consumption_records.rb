# frozen_string_literal: true

class CreateEnergyConsumptionRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :energy_consumption_records, id: :uuid do |t|
      t.uuid :marketplace_item_id, null: false
      t.integer :energy_consumed
      t.uuid :user_id, null: false

      t.timestamps
    end

    add_index :energy_consumption_records, :marketplace_item_id
    add_index :energy_consumption_records, :user_id
  end
end
