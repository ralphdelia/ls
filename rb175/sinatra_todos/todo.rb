require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require 'securerandom'
require "sinatra/content_for"


configure do 
  enable :sessions 
  set :session_secret, SecureRandom.hex(32)
end

before do 
  session[:lists] ||= []
end

get "/" do
  redirect './lists'
end

# view all of the lists
get '/lists' do 
  @lists = session[:lists]
  erb :lists, layout: :layout
end

# render new list form 
get '/lists/new' do 
  erb :new_list, layout: :layout
end 

def error_for_list_name(list_name)
  if !(1..100).cover? list_name.size
    "List name must be between 1 and 100 characters."
  elsif session[:lists].any? {|list| list[:name] == list_name }
    "List name must unique."
  end 
end

def error_for_todo(name)
  if !(1..100).cover? name.size
    "Todo name must be between 1 and 100 characters."
  end
end


# create a new list
post '/lists' do 
  list_name = params[:list_name].strip
  error = error_for_list_name(list_name)
  if error
    session[:error] = error
    erb :new_list, layout: :layout
  else
    session[:lists] << { name: list_name, todos: [] }
    session[:success] = "The list has been created"
    redirect '/lists'
  end
end

get '/lists/:id' do 
  @list_id = params[:id].to_i
  @list = session[:lists][@list_id]


  erb :list, layout: :layout
end
 
get '/lists/:id/edit' do 
  @list_id = params[:id].to_i
  @list = session[:lists][@list_id]

  erb :edit_list, layout: :layout
end

post "/lists/:id" do
  list_name = params[:list_name].strip
  id = params[:id].to_i
  @list = session[:lists][id]

  error = error_for_list_name(list_name)
  if error
    session[:error] = error
    erb :edit_list, layout: :layout
  else
    @list[:name] = list_name
    session[:success] = "The list has been updated"
    redirect "/lists/#{id}"
  end
end

post "/lists/:id/destroy" do
  id = params[:id].to_i
  session[:lists].delete_at(id)
  
  session[:success] = "The list has been deleted"
  redirect "/lists"
end

post "/lists/:list_id/todos" do
  @list_id = params[:list_id].to_i
  @list = session[:lists][@list_id]
  text = params[:todo].strip
  
  error = error_for_todo(text)
  if error 
    session[:error] = error
    erb :list, layout: :layout
  else
    @list[:todos] << {name: text, completed: false}
    session[:success] = "The todo was added."
    redirect "/lists/#{@list_id}"
  end
end

post '/list/:list_id/todos/:todo_id/delete' do 
  @list_id = params[:list_id]
  @todo_id = params[:todo_id]
  


  redirect "/lists/#{list_id}"
end
