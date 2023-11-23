require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require 'securerandom'
require "sinatra/content_for"
require 'redcarpet'
require 'fileutils'

configure do 
  enable :sessions 
  set :session_secret, SecureRandom.hex(32)
end

root = File.expand_path("..", __FILE__)

def data_path
  if ENV["RACK_ENV"] == "test"
    File.expand_path("../test/data", __FILE__)
  else
    File.expand_path("../data", __FILE__)
  end
end

def return_filename_error(filename)
  if filename.strip == ""
    'A name is required'
  elsif File.extname(filename).size < 1
    "Please add a file extension."
  end
end

get '/' do 

  if session[:username]
    pattern = File.join(data_path, "*")
    @files = Dir.glob(pattern).map { |path| File.basename(path) }
    erb :index, layout: :layout
  else 
    pattern = File.join(data_path, "*")
    @files = Dir.glob(pattern).map { |path| File.basename(path) }
    erb :index, layout: :layout 
  end 
end

get '/users/signin' do
  erb :signin, layout: :layout
end

get '/new' do 
  erb :new, layout: :layout
end

post "/users/signin" do
  if params[:username] == "admin" && params[:password] == "secret"
    session[:username] = params[:username]
    session[:message] = "Welcome"
    redirect "/"
  else
    session[:message] = "Invalid credentials"
    status 422
    erb :signin
  end
end

post '/users/signout' do
  session.delete(:username)
  session[:message] = 'You have been signed out'

  redirect '/'
end
 
post '/create' do 
  new_file = params[:new_file].strip
  error = return_filename_error(new_file)

  if error
    session[:message] = error 
    status 422
    erb :new, layout: :layout
  else
    FileUtils.touch(File.join(data_path, new_file))
    session[:message] = "#{new_file} has been created."
    
    redirect '/'
  end
end

post '/:filename/delete' do
  path = File.join(data_path, params[:filename])
  File.delete(path)

  session[:message] = "#{params[:filename]} has been deleted."
  redirect '/'
end

def render_markdown(file)
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  markdown.render(file)
end

def load_file_content(path)
  content = File.read(path)
  case File.extname(path)
  when '.txt'
    headers['Content-Type'] = 'text/plain'
    content
  when '.md'
    erb render_markdown(content)
  end
end

get '/:filename' do
  filename = params[:filename]
  file_path = File.join(data_path, filename)

  if File.exist?(file_path)
    load_file_content(file_path)
  else
    session[:message] = "#{filename} does not exist"
    redirect '/'
  end
end

get "/:filename/edit" do 
  file_path = File.join(data_path, params[:filename])

  @filename = params[:filename]
  @file = File.read(file_path)
  
  erb :edit, layout: :layout
end

post '/:filename' do 
  filename = params[:filename]
  file_path = File.join(data_path, params[:filename])
  
  File.write(file_path, params[:content])

  session[:message] = "#{filename} has been updated"
  redirect '/'
end


__END__

