class UsersController < ApplicationController
	get '/users' do
		if !current_user.is_admin
			redirect '/'
		end

		@users = User.all
		@certificates = Certificate.all

		erb :'/users/index'
	end

	get '/users/report' do
		if !logged_in?
			flash[:message] = "Requires login and administrator privelages."
			redirect '/'
		end

		if !current_user.is_admin
			flash[:message] = "Requires administrator privelages."
			redirect '/'
		end
		current_users = User.all
		valid_users = []

		if params.keys.include?("certificate_ids")
			params[:certificate_ids].each do |cert_id|
				current_users.each do |u|
					if u.certificate_ids.include?(cert_id.to_i) && !valid_users.include?(u)
						valid_users << u
					end
				end
				current_users = valid_users
				valid_users = []
			end
		end

		if params.keys.include?("is_volunteer")
			current_users.each do |u|
				if u.is_volunteer
					valid_users << u
				end
			end
			current_users = valid_users
			valid_users = []
		end

		if params.keys.include?("is_admin")
			current_users.each do |u|
				if u.is_admin
					valid_users << u
				end
			end
			current_users = valid_users
			valid_users = []
		end

		if params.keys.include?("account_paid")
			if params[:account_paid] == "true"
				current_users.each do |u|
					if u.account_paid
						valid_users << u
					end
				end
				current_users = valid_users
				valid_users = []
			else
				current_users.each do |u|
					if !u.account_paid
						valid_users << u
					end
				end
				current_users = valid_users
				valid_users = []
			end
		end
		
		@users = current_users
		erb :'/users/report'
	end

	get '/users/:id' do
		if !logged_in?
			flash[:message] = "Requires login and administrator privelages."
			redirect '/'
		end

		if current_user.id == params[:id] || current_user.is_admin
			@user = User.find(params[:id])

			erb :'/users/show'
		else
			redirect '/'
		end
	end

	get '/users/:id/edit' do
		if !logged_in?
			flash[:message] = "Requires login and administrator privelages."
			redirect '/'
		end

		if !current_user.is_admin
			flash[:message] = "Requires administrator privelages."
			redirect '/'
		end
		@user = User.find(params[:id])
		@certificates = Certificate.all

		erb :'/users/edit'
	end

	patch '/users/:id' do
		# check for certificate_ids array
		if !params[:user].keys.include?("certificate_ids")
			params[:user][:certificate_ids] = []
		end
		@user = User.find(params[:id])
		@user.update(params[:user])

		redirect "/users/#{@user.id}"
	end
end