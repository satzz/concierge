class AlterMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :login_name,      :string, :null => false
    add_column :members, :hashed_password, :string
    add_column :members, :salt,            :string
    add_column :members, :administrator,   :boolean
  end

  def self.down
    remove_column :members, :login_name
    remove_column :members, :hashed_password
    remove_column :members, :salt
    remove_column :members, :administrator
  end
end


