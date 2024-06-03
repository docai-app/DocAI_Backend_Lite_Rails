class CreateUserFeeds < ActiveRecord::Migration[7.0]
  def change
    create_table :user_feeds, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.string :title, default: ""
      t.string :description, default: ""
      t.string :cover_image, default: ""
      t.string :file_type, null: false
      t.string :file_url, default: ""
      t.integer :file_size, default: 0
      t.uuid :user_marketplace_item_id
      t.jsonb :meta
      t.text :file_content

      t.timestamps
    end

    add_index :user_feeds, :file_type
    add_index :user_feeds, :user_id
    add_index :user_feeds, :user_marketplace_item_id
  end
end
