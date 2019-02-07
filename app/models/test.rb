class Test < ActiveRecord::Base
	has_many :questions
	has_many :certificate_tests
	has_many :certificates, through: :certificate_tests
	has_many :test_users
	has_many :users, through: :test_users
	
end