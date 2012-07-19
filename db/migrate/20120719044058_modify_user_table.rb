class ModifyUserTable < ActiveRecord::Migration
  def up
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    
    remove_column :users, :email
    remove_column :users, :password_digest
  end

  def down
    remove_column :users, :uid
    remove_column :users, :provider
    
    add_column :users, :email, :string
    add_column :users, :password_digest, :string
  end
end
