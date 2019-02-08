class UsersController < ApplicationController
	get '/users' do
		if !logged_in?
			flash[:message] = "Requires login and administrator privelages."
			redirect '/'
		end

		if !current_user.is_admin
			flash[:message] = "Requires administrator privelages."
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

		if current_user.id.to_s == params[:id] || current_user.is_admin
			@user = User.find(params[:id])

			erb :'/users/show'
		else
			redirect '/'
		end
	end

	get '/users/:id/edit' do
		if !logged_in? or current_user.id.to_s != params[:id]
			flash[:message] = "Requires login and administrator privelages."
			redirect '/'
		end

		@user = User.find(params[:id])
		@certificates = Certificate.all

		erb :'/users/edit'
	end

	patch '/users/:id' do
		binding.pry
		# if the user isn't admin, treat this as a profile update
		if !current_user.is_admin
			
			# make sure the current user is the one being updated, if current_user isn't admin
			if current_user.id.to_s != params[:id]
				flash[:message] = "Can't update other users profile."

				redirect "/users/#{current_user.id}"
			else
				@user = User.find(params[:id])
			end
			
			# did the user update their email?
			if params[:user][:email] != @user.email
	      		
	      		# if so, does it already exist?
	      		if User.find_by(:email => params[:user][:email])
	        		flash[:message] = "Email is already taken."
	       			
	       			# if yes, bail
					redirect "/users/#{@user.id}"
	      		end

      		# rinse and repeat for updating username
	    	elsif params[:user][:username] != @user.username
	      		if User.find_by(:username => params[:user][:username])
	        		flash[:message] = "Username is already taken."
	        		
					redirect "/users/#{@user.id}"
	      		end
	    	end

			if @user.update(params[:user])
	      		flash[:message] = "Profile updated."
	    	else
	      		flash[:message] = "Something went wrong. Profile not updated."
	    	end

    	# if this is an admin, treat it more like a change to their account status
    	else
			# check for certificate_ids array
			if !params[:user].keys.include?("certificate_ids")
				params[:user][:certificate_ids] = []
			end
			@user = User.find(params[:id])
			@user.update(params[:user])
		end

		redirect "/users/#{@user.id}"
	end
end