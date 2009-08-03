class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.column :member_num,  :integer, :null => false
      t.column :family_name, :string,  :null => false
      t.column :given_name,  :string,  :null => false
      t.column :furigana,    :string,  :null => false
      t.column :email,       :string
      t.column :phone,       :string
      t.column :created_at,  :datetime
      t.column :updated_at,  :datetime
    end
  end

  def self.down
    drop_table :members
  end
end


