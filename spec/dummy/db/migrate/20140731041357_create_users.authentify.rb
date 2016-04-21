# This migration comes from authentify (originally 20120608223732)
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :authentify_users do |t|
      t.string :name
      t.string :email
      t.string :login
      t.string :encrypted_password
      t.string :salt
      t.string :status, :default => 'active'
      t.integer :last_updated_by_id
      t.string  :auth_token
      t.string  :password_reset_token
      t.datetime :password_reset_sent_at      
      t.timestamps
      t.string :brief_note
      t.string :cell
      t.boolean :allow_text_msg, :default => false
      t.boolean :allow_email, :default => false
      t.integer :customer_id
      t.string :local
      t.string :fort_token
    end
    
    add_index :authentify_users, :name
    add_index :authentify_users, :email
    add_index :authentify_users, :status
    add_index :authentify_users, :allow_text_msg
    add_index :authentify_users, :allow_email
    add_index :authentify_users, :customer_id
  end
end
