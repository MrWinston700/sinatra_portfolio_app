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
            user.items << item
            user.save
        end
        redirect '/items'
    end
    get '/item/:id/delete' do
      if Helper.is_logged_in?(session)
        @item = Item.find(params[:id])
        if @item.user == Helper.current_user(session)
          @item = Item.find_by_id(params[:id])
          @item.delete
          redirect '/items'
        else
          redirect '/items'
        end
      else
        redirect '/login'
      end
    end
    get '/item/:id/edit' do
      if Helper.is_logged_in?(session)
        @item = Item.find_by_id(params[:id])
        if @item.user == Helper.current_user(session)
          erb :'/item/edit'
        else
          redirect '/login'
        end
      else
        redirect '/login'
      end
    end
    patch '/item/:id' do 
      @item = Item.find_by_id(params[:id])
    
      if params[:item].empty?
        redirect "/item/#{item.id}/edit"
      end
    
      @item.update(params[:item])
      @item.save
      redirect "/item/#{@item.id}"
    end

    get '/item/:id' do 
      redirect '/login' unless Helper.is_logged_in?(session)
      @item = Item.find_by_id(params[:id])
      erb :"item/show"
    end


  




end