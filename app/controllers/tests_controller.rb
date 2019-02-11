class TestsController < ApplicationController

	get '/tests' do
		if !logged_in?
			flash[:message] = "Requires login."
			redirect '/login'
		end
		@tests = Test.all

		erb :'/tests/index'
	end

	get '/tests/new' do
		if !logged_in?
            flash[:message] = "Requires login and administrator privelages."
            redirect '/login'
        end

        if !current_user.is_admin
            flash[:message] = "Requires administrator privelages."
            redirect '/login'
        end

		@certificates = Certificate.all

		erb :'/tests/new'
	end

	get '/tests/:id/succeed' do
		current_user.tests << Test.find(params[:id])

		# user passed the test, now to see if they earned a new certificate
		flash[:message] = "Congratulations, you passed!"
		certificates = Certificate.all
		certificates.each do |cert|
			
			# only do the following if the user isn't certified already in cert
			if !current_user.certificates.include?(cert)
				requisites = true
				cert.tests.each do |t|
					if !current_user.tests.include?(t)
						requisites = false
					end
				end
				if requisites && !current_user.certificates.include?(cert)
					current_user.certificates << cert
					flash[:message] = "#{flash[:message]} <br> #{cert.name} certificate has been awarded to you!"
				end
			end
		end

		redirect '/certificates'
	end

	get '/tests/failed' do
		flash[:message] = "Test failed. Please try again later."

		redirect '/certificates'
	end

	get '/tests/:id/take' do
		if !logged_in?
            flash[:message] = "Requires login and administrator privelages."
            redirect '/login'
        end

		@test = Test.find(params[:id])

		erb :'/tests/take'
	end

	post '/tests' do
		# check to see if certificate_ids is empty
		if !params[:test].keys.include?("certificate_ids")
			params[:test][:certificate_ids] = []
		end

		# check to see if a new certificate name was given
		if !params[:certificate][:name].empty?
			new_certificate = Certificate.find_or_create_by(params[:certificate])
			params[:test][:certificate_ids] << new_certificate.id
		end

		new_test = Test.new(params[:test])
		params[:questions].each do |question|
			if !question[:text].empty?
				new_q = Question.new(:text => question[:text])
				question[:answers].each do |answer|
					if !answer[:text].empty?
						new_a = Answer.create(answer)
						new_q.answers << new_a
					end
				end
				new_q.save  
				new_test.questions << new_q
			end
		end

		# make sure answers are set to false and not nil
		Answer.all.each do |a|
			if a.is_correct.nil?
				a.is_correct = false
			end
		end
		new_test.save
		
		flash[:message] = "New test has been created: #{new_test.name}"
		redirect '/tests'
	end

	get '/tests/:id' do
		if !logged_in?
            flash[:message] = "Requires login and administrator privelages."
            redirect '/login'
        end
        
		@test = Test.find(params[:id])

		erb :'/tests/show'
	end

	patch '/tests/:id' do
		current_test = Test.find(params[:id])
		current_test.update(:name => params[:test][:name])

		# deal with certificates first
		# if user entered a new certificate name, create it
		if !params[:certificate][:name].empty?
			cert = Certificate.create_or_find_by(params[:certificate])
			current_test.certificates << cert
		end
		
		# next, go through certificate_ids, see if they've been updated
		if !params[:test].keys.include?("certificate_ids")
			params[:test][:certificate_ids] = []
		end

		# set the test certificate id's
		current_test.certificate_ids = params[:test][:certificate_ids]

		# deal with question data now
		# check for new question params
		if !params[:new][:text].empty?
			q = Question.new(:text => params[:new][:text])
			params[:new][:answers].each do |answer|
				if !answer[:text].empty?
					a = Answer.create(answer)
					q.answers << a
				end
			end
			q.save
			current_test.questions << q
		end

		# check existing questions
		params[:questions].each do |id, q_values|
			q = Question.find(id)

			# if field was emptied, delete the record
			if q_values[:text].empty?
				
				# delete the associate answers so they don't clog up the db
				q.answers.each do |a|
					a.delete
				end
				q.delete
			else
				if !params[:answers][q.id.to_s][:text].empty?
					new_a = Answer.create(params[:answers][q.id.to_s])
					q.answers << new_a
				end
				q_values[:answers].each do |id, ans_values|
					a = Answer.find(id)
					if ans_values[:text].empty?
						a.destroy
					else
						if !ans_values.keys.include?("is_correct")
							a[:is_correct] = false
						end
						a.update(ans_values)
					end
				end
				q.update(:text => q_values[:text])
			end
		end
		flash[:message] = "#{current_test.name} has been successfully updated."

		redirect "/tests/#{params[:id]}"
	end

	get '/tests/:id/edit' do
		if !logged_in?
            flash[:message] = "Requires login and administrator privelages."
            redirect '/login'
        end
        
		if !current_user.is_admin
			flash[:message] = "Requires adminstrator privelages."
			redirect '/tests'
		end
		@test = Test.find(params[:id])
		@certificates = Certificate.all

		erb :'/tests/edit'
	end

	post '/tests/:id/check' do
		passed = true
		params[:questions].each do |id, answers|
			original_question = Question.find(id)
			original_question.answers.each do |a|
				if params[:questions][id][a.id.to_s][:is_correct] != a.is_correct.to_s
					passed = false
				end
			end
		end
		if passed
			redirect "/tests/#{params[:id]}/succeed"
		else
			flash[:message] = "Test failed, please try again later."
			redirect '/tests/failed'
		end
	end

	delete '/tests/:id' do
		if !logged_in?
            flash[:message] = "Requires login and administrator privelages."
            redirect '/login'
        end
        
		if !current_user.is_admin
			flash[:message] = "Requires adminstrator privelages."
			redirect '/tests'
		end

		@test = Test.find(params[:id])
		flash[:message] = "Test deleted: #{@test.name}"
		@test.destroy

		redirect '/tests'
	end
end