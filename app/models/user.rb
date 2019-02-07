class User < ActiveRecord::Base
	has_many :certificate_users
	has_many :certificates, through: :certificate_users
	
	has_many :test_users
	has_many :tests, through: :test_users
	
	has_secure_password
	validates_presence_of :first_name, :last_name, :email, :phone_number, :password_digest, :username

	def set_defaults
    	self.is_admin = false if self.bool_field.nil?
    	self.is_volunteer = false if self.bool_field.nil?
    	self.account_paid = false if self.bool_field.nil?
    	self.is_checked_in = false if self.bool_field.nil?
  	end

	def full_name
		"#{self.first_name} #{self.last_name}"
	end

  def is_certified(cert_id)
    self.certificate_ids.include?(cert_id.to_i)
  end
end	