require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    erb :index
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    if params[:username]=="" || params[:password]==""
      redirect to '/failure'
    end

    params[:balance] = 0

    user = User.new(:username => params[:username], :password => params[:password], :balance => params[:balance])
    if user.save
			redirect to "/login"
		else
			redirect to "/failure"
		end
  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    @user = User.find_by(username: params[:username])
     if @user && @user.authenticate(params[:password])
       session[:user_id] = @user.id

       redirect to "/account"
     else


       redirect to "/failure"
     end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  get '/account/deposit' do
    erb :deposit
  end

  post '/account/deposit' do
    user = current_user
    old_b = user.balance.to_i
    new_b = params[:amount].to_i
    user.balance = old_b + new_b 
    user.save

    redirect "/account"
    
  end

  get '/account/withdraw' do 
    erb :withdraw
  end

  post '/account/withdraw' do
    user = current_user
    old_b = user.balance.to_i
    new_b = params[:amount].to_i
    if new_b <= old_b
    user.balance = old_b - new_b 
    user.save
    redirect "/account"
    else
      redirect "/failure"
    end
    
    
    
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
