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
      #if statements enable user to edit only one attribute of the given item
      if params[:item].empty?
        redirect "/item/#{item.id}/edit"
      end
      if !(params[:item][:name].empty?)
        @item.name = params[:item][:name]
      end
      if !(params[:item][:description].empty?)
        @item.description = params[:item][:description]
      end
      if !(params[:item][:cost].empty?)
        @item.cost = params[:item][:cost]
      end
      @item.save
      redirect "/item/#{@item.id}"
    end

    get '/item/:id' do 
      redirect '/login' unless Helper.is_logged_in?(session)
      @item = Item.find_by_id(params[:id])
      erb :"item/show"
    end
    #this route enables a user logged in to buy an item that has the status = "selling"
    #it will also update both users profile. If users do not have enough points, they cannot
    #purchase the item and will be redirected to "./views/error/funds"
    get '/item/:id/buy' do
      if Helper.is_logged_in?(session)
        @item = Item.find_by_id(params[:id])
        if @item.status != "bought" && @item.status != "sold"
          @item.status = "sold"
          @sold_item = Item.new 
          @sold_item.name = @item.name
          @sold_item.description = @item.description
          @sold_item.cost = @item.cost 
          @sold_item.status = "bought"
          @user = User.find_by_id(session[:user_id])
          if !(@item.cost > @user.points)
            @user.items << @sold_item
            @user.points = @user.points - @item.cost
            @user.save
            seller = User.find_by_id(@item.user_id)
            seller.points = seller.points + @item.cost
            seller.save
            @item.save
            redirect '/items'
          else
            erb :"error/funds"
          end
        else 
          redirect '/items'
        end
        
      else
        redirect 'login'
      end
    end


  




end