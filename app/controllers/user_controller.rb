class UserController < ApplicationController

    get '/' do 
        
        erb :helloworld
    end
end