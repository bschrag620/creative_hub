require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    set :session_secret, "3lklk2ml23-0op;l"
    enable :sessions
    use Rack::Flash
  end

  get '/' do
    
  	erb :index
  end

  get '/login' do
    if logged_in?
      redirect '/'
    end
    erb :login
  end

  get '/logout' do
    session.clear

    flash[:message] = "Goodbye."
    redirect '/'
  end

  post '/login' do
    user = User.find_by(:email => params[:signin])

    if not user
      user = User.find_by(:username => params[:signin])
    end

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:message] = "Welcome back, #{user.first_name}"
      redirect '/'
    else
      redirect '/login'
    end
  end

  get '/signup' do
    if logged_in?
      redirect '/'
    end
    erb :signup
  end

  post '/signup' do
    if User.find_by(:email => params[:email])
      flash[:message] = "Duplicate email. Please try again."
      redirect '/signup'
    end

    if User.find_by(:username => params[:username])
      flash[:message] = "Duplicae username. Please try again."
      redirect '/signup'
    end

    user = User.new(params)
    if user.save
      session[:user_id] = user.id
      redirect '/'
    else
      flash[:message] ="Something went wrong, please try again."
      redirect '/signup'
    end
  end

  patch '/profile' do
    @user = current_user
    if params[:user][:email] != @user.email
      if User.find_by(:email => params[:user][:email])
        flash[:message] = "Email is already taken."
        redirect '/profile'
      end
    elsif params[:user][:username] != @user.username
      if User.find_by(:username => params[:user][:username])
        flash[:message] = "Username is already taken."
        redirect '/profile'
      end
    end

    if @user.update(params[:user])
      flash[:message] = "Profile updated."
    else
      flash[:message] = "Something went wrong. Profile not updated."
    end
    redirect '/profile'
  end

  helpers do
		def logged_in?
			!!session[:user_id]
		end

		def current_user
			 User.find(session[:user_id])
		end
	end
end