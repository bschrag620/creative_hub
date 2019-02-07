class CreateTableTestUsers < ActiveRecord::Migration[5.2]
  def change
  	create_table :test_users do |t|
  		t.integer :test_id
  		t.integer :user_id
  	end
  end
end
