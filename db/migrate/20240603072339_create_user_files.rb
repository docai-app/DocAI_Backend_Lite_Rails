class CreateUserFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :user_files, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.string :file_type, null: false
      t.string :file_url
      t.integer :file_size, default: 0, null: false
      t.string :title, default: ""
      t.uuid :user_marketplace_item_id
      t.jsonb :meta

      t.timestamps
    end

    add_index :user_files, :file_type
    add_index :user_files, :user_id
    add_index :user_files, :user_marketplace_item_id
  end
end
