class User < ActiveRecord::Base
	has_many :certificates, through: :certificate_users
	has_many :certificate_users
	has_secure_password
	validates_presence_of :first_name, :last_name, :email, :phone_number, :password_digest

	def set_defaults
    	self.is_admin = false if self.bool_field.nil?
    	self.is_volunteer = false if self.bool_field.nil?
    	self.account_paid = false if self.bool_field.nil?
    	self.is_checked_in = false if self.bool_field.nil?
  	end
end	