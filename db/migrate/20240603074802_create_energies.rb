# frozen_string_literal: true

class CreateEnergies < ActiveRecord::Migration[7.0]
  def change
    create_table :energies, id: :uuid do |t|
      t.integer :value, default: 100
      t.uuid :user_id, null: false
      t.string :entity_name

      t.timestamps
    end

    add_index :energies, :entity_name
    add_index :energies, :user_id
  end
end
