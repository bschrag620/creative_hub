class CertificatesController < ApplicationController
	get '/certificates' do
		if !logged_in?
			flash[:message] = "Requires login."
			redirect '/login'
		end
		@certificates = Certificate.all

		erb :'/certificates/index'
	end

	get '/certificates/new' do
		if !logged_in?
            flash[:message] = "Requires login and administrator privelages."
            redirect '/login'
        end

        if !current_user.is_admin
            flash[:message] = "Requires administrator privelages."
            redirect '/login'
        end

		@tests = Test.all

		erb :'/certificates/new'
	end

	get '/certificates/:id' do
		if !logged_in?
            flash[:message] = "Requires login and administrator privelages."
            redirect '/login'
        end

		@cert = Certificate.find(params[:id])

		erb :'/certificates/show'
	end

	get '/certificates/:id/edit' do
		if !logged_in?
            flash[:message] = "Requires login and administrator privelages."
            redirect '/login'
        end

		if !current_user.is_admin
			redirect '/tests'
		end
		
		@cert = Certificate.find(params[:id])
		@tests = Test.all

		erb :'/certificates/edit'
	end

	patch '/certificates/:id' do
		@cert = Certificate.find(params[:id])
		@cert.update(params[:certificate])

		redirect "/certificates/#{@cert.id}"
	end

	post '/certificates' do
		new_cert = Certificate.find_or_create_by(params)
		new_cert.equipment = Equipment.find_or_create_by(params[:name])
		redirect "/certificates"
	end

	delete '/certificates/:id' do
		@certificate = Certificate.find(params[:id])

		@certificate.destroy
		redirect '/certificates'
	end

	get '/certificates/:id/apply' do
		if !logged_in?
            flash[:message] = "Requires login and administrator privelages."
            redirect '/login'
        end
        
		@certificate = Certificate.find(params[:id])
		@tests = current_user.tests

		erb :'certificates/apply'
	end
end