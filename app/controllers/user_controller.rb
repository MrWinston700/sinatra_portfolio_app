class UserController < ApplicationController

    get "/signup" do
        if Helper.is_logged_in?(session)
          redirect "/items"
        else
          erb :"user/signup"
        end
          
      end
      
    post "/signup" do 
        if !(params.has_value?(""))
            user = User.create(params)
            session["user_id"] = user.id
            redirect '/login'
        else
            redirect '/signup'
        end
    end
        
    get "/login" do
      if Helper.is_logged_in?(session)
        redirect '/items'
      else
        erb :'/user/login'
      end
    end
      
    post "/login" do
      user = User.find_by(:username => params[:username])
    
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect '/items'
      else
        redirect "/login"
      end
    end
      
    get '/users/:id' do
      @user = User.find_by_id(params[:id])
      if !@user.nil?
        redirect '/items'
      else 
        redirect to '/login'
      end
    end     
      
    get "/logout" do 
      session.clear
      redirect "/"
    end
    
end