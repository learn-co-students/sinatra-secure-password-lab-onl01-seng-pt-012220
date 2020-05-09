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
    #your code here
    username = params[:username]
    password = params[:password]
    
    if username == '' || password == ''
      redirect '/failure'
    else
      user = User.create(params)
      redirect '/login'
    end
  end

  get '/account' do
    if logged_in?
      @user = User.find(session[:user_id])
      erb :account
    else
      redirect '/login'
    end
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    ##your code here
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/account'
      
    else
      redirect 'failure'
      
    end
  end

  get "/failure" do
    erb :failure
  end
  
  get "/deposit" do
    erb :deposit
  end
  
  post "/deposit" do
     new_balance = (current_user.balance + (params[:amount]).to_f).round(2)
    current_user.update(balance: new_balance)
    redirect '/account'
  end

  get "/withdraw" do
    erb :withdraw
  end

  post "/withdraw" do
    if  current_user.balance >= (params[:amount]).to_f
      begin
        new_balance = (current_user.balance - (params[:amount]).to_f).round(2)
        current_user.update(balance: new_balance)
        redirect '/account'
      rescue
        erb :withdraw,  locals: {
          error_message: "You do not have enough fund for this transaction, try a lower amount."
        }
      end
    else
      erb :withdraw
    end
  end

  get "/logout" do
    session.clear
    redirect "/"
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
