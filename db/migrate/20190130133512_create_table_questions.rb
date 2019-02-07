class CreateTableQuestions < ActiveRecord::Migration[5.2]
  def change
  	create_table :questions do |t|
  		t.string :text
  		t.integer :test_id
  	end
  end
end
