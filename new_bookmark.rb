require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/cookies'
set :bind, '0.0.0.0'
enable :sessions

get '/' do
    erb :new_bookmark
end

@db = SQLite3::Database.new './Database.db'

post '/new_bookmark' do
    insertInto = "INSERT INTO Users(name, link, description) VALUES" (
        params[:name_of_bookmark], params[:link], params[:description]
    );
    puts params
    redirect '/'
end