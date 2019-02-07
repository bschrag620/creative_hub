class CreateTableEquipments < ActiveRecord::Migration[5.2]
  def change
  	create_table :equipment do |t|
  		t.string :name
  		t.boolean :in_use, :default => false
  		t.integer :certificate_id
  	end
  end
end
