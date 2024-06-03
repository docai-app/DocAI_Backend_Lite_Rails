class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email, null: false, default: "", unique: true
      t.string :encrypted_password, null: false, default: ""
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.string :nickname
      t.string :phone
      t.string :whatsapp
      t.date :date_of_birth
      t.integer :sex
      t.string :timezone, null: false, default: "Asia/Hong_Kong"

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
