VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

#get logout request and redirect to index page
get '/logout' do                       
  	session.clear
    $users_signed_in - 1
    flash[:info] = "You have been successfully logged out"
  	redirect '/index'
end


#get login request and redirect to login page
get '/login' do
    redirect '/index' if session[:logged_in]
    erb :login
end

post '/login' do 
    session.clear
    @login = true
 
    
    @username = params[:username].strip
    @pass = params[:password].strip
    @userFound = User.find_user(@username, @pass) 
    
    @username_ok = !@username.nil? && @username != ""
    @pass_ok = !@pass.nil? && @pass != ""
    @all_ok = @username_ok && @pass_ok
       
    if @userFound
    #Gather all user data
    query = "SELECT * FROM users WHERE username = ?;"
    @userInfo = $db.execute query, @username 
    @active = @userInfo[0][6]
    end
        
    if  @active == 1
        session[:logged_in] = true #User now logged in
        session[:admin] = false #User is not an admin until confirmed
        
    #   store user info in session data
        session[:email] = @userInfo[0][5]
        session[:user_id] = @userInfo[0][0]
        session[:username] = @userInfo[0][1]
        session[:first_name] = @userInfo[0][2]
        session[:last_name] = @userInfo[0][3]

        if @userInfo[0][7] == 1
            session[:admin] = true #User is an admin
            flash[:info] = "Welcome to system control"
            redirect'/admin'
        end
       
        flash[:info] = "Successfully signed in as #{session[:username]}"
        redirect '/index'
    else
        flash[:warning] = "Please check your Usename and Password and try again"
        session[:logged_in] = false
        erb :login
    end
    
end
