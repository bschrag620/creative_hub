class Certificate < ActiveRecord::Base
	has_many :users, through: :certificate_users
	has_many :certificate_users
	has_many :tests, through: :certificate_tests
	has_many :certificate_tests
	has_many :equipment
end