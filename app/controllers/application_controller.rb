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
		user = User.new(:username => params[:username], :password => params[:password])

    if user.save
      account = Account.new
      account.user = user
      account.save
			redirect "/login"
		else
			redirect "/failure"
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
		user = User.find_by(:username => params[:username])
	   
		if user && user.authenticate(params[:password])
		  session[:user_id] = user.id
		  redirect "/account"
		else
		  redirect "/failure"
		end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  post '/deposit' do
    amount = params["deposit"]
    current_user.account.deposit(amount.to_f)
    #  current_user.account.save
    #  Above line is not working, the deposit says successful but the account balance on '/account' remains unchanged.

    redirect '/success'
  end

  post '/withdraw' do
    amount = params["withdraw"]
    
    if current_user.account.valid_withdraw?(amount.to_f)
      current_user.account.withdraw(amount.to_f)
      redirect '/success'
    end
    redirect '/invalid'
  end

  get '/success' do
    erb :success
  end

  get '/invalid' do
    erb :invalid
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
