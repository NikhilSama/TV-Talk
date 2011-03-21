class AddMobielIndex < ActiveRecord::Migration
  def self.up
    add_index :users, :mobileid, :unique=>true
  end

  def self.down
    remove_index :users, :mobileid
  end
end
