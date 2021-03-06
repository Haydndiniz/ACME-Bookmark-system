before do
   @ids_in_history = Array.new
   @bookmark_list_array = Array.new
   @last_visit = Array.new
    
   query = "SELECT bookmark_id FROM bookmark_history WHERE user_id = ? ORDER BY date ASC"
   @ids_in_history = $db.execute query, session[:user_id]
  
   @bookmark_list_array.clear
   @ids_in_history.each do |id|
       @bookmark_list_array.insert(0, Bookmark.find_by_id(id))
   end
   
   @bookmark_list_history = @bookmark_list_array
 
   $users_signed_in = 0 
   @tags_list = $db.execute "SELECT * FROM tags ORDER BY name ASC"
end

##--------------------Get Methods--------------------#

get '/history' do
  if !session[:logged_in]  
      flash[:warning] = "Please login to continue"
      redirect '/login'
  end
      @search = params[:search]
      erb :history 
end


##--------------------Post Methods--------------------#

#search
post '/history' do
    @search = params[:search].strip
    
    #checks if tags have been input
    if params[:tags].nil?
        @tags = 0
    else
        @tags = params[:tags].strip
    end
    
    @bookmark_list_history = Bookmark.find_by(@search, @tags)
    erb :history
end

post '/add_to_history' do
    @user_id = session[:user_id]
    @visited_bookmark_id = params[:bookmark_id].to_i
    @visit_time = Time.now.strftime("%Y/%m/%d %H:%M:%S").to_s
   
    if !@bookmark_list_array.include? (Bookmark.find_by_id(@visited_bookmark_id))  
        History.new(@user_id, @visited_bookmark_id, @visit_time)
    else
        History.update_date(@visited_bookmark_id, @visit_time)
    end
    
    redirect params[:bookmark_url]
end