class CreateTableCertificateTests < ActiveRecord::Migration[5.2]
  def change
  	create_table :certificate_tests do |t|
  		t.integer :certificate_id
  		t.integer :test_id
  	end
  end
end
