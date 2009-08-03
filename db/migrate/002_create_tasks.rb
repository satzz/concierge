class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.column :title,       :string,  :null => false
      t.column :content,     :string,  :null => false
      t.column :owner_id,    :integer, :null => false
      t.column :assigner_id, :integer, :null => false
      t.column :deadline,    :date,    :null => false
      t.column :status,      :string,  :null => false
      t.column :priority,    :integer, :null => false
      t.column :created_at,  :date,    :null => false
      t.column :updated_at,  :date,    :null => false
    end
  end

  def self.down
    drop_table :tasks
  end
end


