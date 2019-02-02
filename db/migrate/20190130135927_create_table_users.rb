class CreateTableUsers < ActiveRecord::Migration
  def change
  	create_table :users do |t|
  		t.string :first_name
  		t.string :last_name
  		t.string :email, uniqueness: true
  		t.string :phone_number
  		t.text :bio
  		t.boolean :is_admin, :default => false
  		t.boolean :is_volunteer, :default => false
  		t.boolean :account_paid, :default => false
  		t.boolean :is_checked_in, :default => false
  		t.string :password_digest
  	end
  end
end
