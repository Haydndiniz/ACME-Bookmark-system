
desc "Install the app"
task :install do
    Rake::Task[:installgems].execute
    Rake::Task[:createdb].execute
end

desc "Run the Sinatra app locally"
task :run do
    begin
        File.read("database/database.sqlite")
    rescue
        puts "No database found. Creating now..."
        Rake::Task[:createdb].execute
    end
    require_relative 'app.rb'
    Sinatra::Application.run!
end


#---------------------------Database tasks--------------------------#
desc "Create db"
task :createdb do
  puts "Creating the database"
  `ruby database/createDatabase.rb`
end

desc "Delete temporary files"
task :clean do
  `echo deleting temporary files`
  `rm database/acme_test_db.sqlite`
end

desc "Delete database"
task :deletedb do
  `echo deleting temporary files`
  `rm database/acme_db.sqlite`
end

desc "Create backup of database into csv files"
task :backupdb do
    system('sqlite3 -header -csv database/acme_db.sqlite "select * from tags;" > public/csv/tags.csv')
    system('sqlite3 -header -csv database/acme_db.sqlite "select * from favourites;" > public/csv/favourites.csv')
    system('sqlite3 -header -csv database/acme_db.sqlite "select * from users;" > public/csv/users.csv')
    system('sqlite3 -header -csv database/acme_db.sqlite "select * from feedback;" > public/csv/feedback.csv')
    system('sqlite3 -header -csv database/acme_db.sqlite "select * from bookmarks;" > public/csv/bookmarks.csv')
    system('sqlite3 -header -csv database/acme_db.sqlite "select * from login_history;" > public/csv/login_history.csv')
    system('sqlite3 -header -csv database/acme_db.sqlite "select * from tagged_bookmarks;" > public/csv/tagged_bookmarks.csv')
    system('sqlite3 -header -csv database/acme_db.sqlite "select * from bookmark_history;" > public/csv/bookmark_history.csv')
end

desc "Create test database"
task :createtestdb do
    system('ruby database/createDatabase.rb testdb')
end

desc "Restore the state of the db"
task :wipedb do
  puts "Wiping the database"
  `ruby database/wipeDatabase.rb`
end