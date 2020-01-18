class ItemController < ApplicationController

    get '/items' do
        if Helper.is_logged_in?(session)
          @items = Item.all
          erb :'/item/items'
        else
          redirect '/user/login'
        end
    end

    get '/item/new' do 
        user = Helper.current_user(session)
        if user.nil?
          redirect '/login'
        else
          erb :'/item/new'
        end
    end

    post '/item' do 
        user = Helper.current_user(session)
        if user.nil?
          redirect to '/login'
        elsif params[:item].empty?
          redirect '/item/new'
        else
            item = Item.create(name: params[:item][:name], description: params[:item][:description], cost: params[:item][:cost], status: "selling")
          #user.items.build({name: params[:item][:name], description: params[:item][:description], cost: params[:item][:cost], status: "selling"})
          #user.save
            user.items << item
            user.save
          
        end
        redirect '/items'
    end
end