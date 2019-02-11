class EquipmentController < ApplicationController
	get '/equipment' do
	    if !logged_in?
            flash[:message] = "Requires login."
            redirect '/login'
        end

	    @equipments = Equipment.all
	    erb :'/equipment/index'
 	end

 	post '/equipment' do
 		equip = Equipment.find_or_create_by(:name => params[:name])

 		if params[:certificate_name].empty?
 			params[:certificate_name] = equip.name
 		end

 		equip.certificate = Certificate.find_or_create_by(:name => params[:certificate_name])
        if equip.save
            flash[:message] = "New equipment added: #{equip.name}"
        else
            flash[:message] = "Something went wrong."
        end
        
 		redirect "/equipment/#{equip.id}"
 	end

 	get '/equipment/new' do
 		if !current_user.is_admin
			redirect '/'
	    end

	    @certifs = Certificate.all

	    erb :'/equipment/new'
    end

    get '/equipment/:id' do
        if !logged_in?
            flash[:message] = "Requires login."
            redirect '/login'
        end

    	@equip = Equipment.find(params[:id])

    	erb :'/equipment/show'
    end

    get '/equipment/:id/edit' do
        if !logged_in?
            flash[:message] = "Requires login and admin privelages."
            redirect '/login'
        end

    	if !current_user.is_admin
			redirect '/'
	    end

    	@equip = Equipment.find(params[:id])
    	@certifs = Certificate.all
    	erb :'/equipment/edit'
    end	

    patch '/equipment/:id' do
    	if !current_user.is_admin
			redirect '/'
	    end
    	
    	equip = Equipment.find(params[:id])
    	equip.update(:name => params[:name], :certificate => Certificate.find(params[:certificate_id]))
        flash[:message] = "Equipment updated."

		redirect "/equipment/#{equip.id}"
    end

    delete '/equipment/:id' do
    	if !current_user.is_admin
			redirect '/'
	    end

	    equip = Equipment.find(params[:id])
        flash[:message] = "Equipment deleted: #{equip.name}."
        equip.delete
        
	    redirect '/equipment'
    end

    get '/equipment/in_use' do
        if !logged_in?
            flash[:message] = "Requires login."
            redirect '/login'
        end

    	erb :'/equipment/in_use'
    end

    get '/equipment/:id/use' do
    	if !logged_in?
            flash[:message] = "Requires login."
            redirect '/login'
        end

    	@user = current_user
    	@equip = Equipment.find(params[:id])

        if !@equip.certificate
            flash[:message] = "Equipment lacking certificate. Please contact admin."
            redirect '/equipment'
        end
        
		erb :'/equipment/use'
    end

    get '/equipment/:id/begin' do
        if !logged_in?
            flash[:message] = "Requires login."
            redirect '/login'
        end

    	@equip = Equipment.find(params[:id])
    	@equip.in_use = true
    	@equip.save
    	redirect "/equipment/#{@equip.id}/use"
    end

    get '/equipment/:id/stop' do
        if !logged_in?
            flash[:message] = "Requires login."
            redirect '/login'
        end
        
    	@equip = Equipment.find(params[:id])
    	@equip.in_use = false
    	@equip.save
    	redirect "/equipment/#{@equip.id}/use"
    end
end