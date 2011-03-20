class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :mobileid
      t.string :tw_token
      t.string :tw_token_secrec

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
