class AddColumnCertId < ActiveRecord::Migration
  def change
  	add_column :equipment, :certificate_id, :integer
  end
end
