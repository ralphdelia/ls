# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'securerandom'
require 'sinatra/content_for'
require 'redcarpet'
require 'fileutils'
require 'yaml'
require 'bcrypt'

configure do
  enable :sessions
  set :session_secret, SecureRandom.hex(32)
end

File.expand_path(__dir__)

def data_path
  if ENV['RACK_ENV'] == 'test'
    File.expand_path('test/data', __dir__)
  else
    File.expand_path('data', __dir__)
  end
end

def parent_path_of_file
  if ENV['RACK_ENV'] == 'test'
    File.expand_path('test', __dir__)
  else
    File.expand_path(__dir__)
  end
end

def return_users
  YAML.load_file(File.join(parent_path_of_file, 'users.yml'))
end

def return_filename_error(filename)
  if filename.strip == ''
    'A name is required'
  elsif File.extname(filename).empty?
    'Please add a file extension.'
  elsif %w[.txt .md].none?(File.extname(filename))
    'We only support .txt and .md files.'
  end
end

def user_not_logged_in?
  session[:username] ? false : true
end

def redirect_to_index
  session[:message] = 'You must be signed in to do that.'
  redirect '/'
end

get '/' do
  pattern = File.join(data_path, '*')
  @files = Dir.glob(pattern).map { |path| File.basename(path) }
  erb :index, layout: :layout
end

post '/photo/upload' do
  if params[:img]
    File.open(File.join('public', 'uploads', params[:img][:filename]), 'wb') do |file|
      file.write(params[:img][:tempfile].read)
    end
    session[:message] = "Reference your file in markdown using '![title](/uploads/#{params[:img][:filename]})'"
    redirect "#{params[:redirect]}/edit"
  end
end

get '/users/signin' do
  erb :signin, layout: :layout
end

get '/new' do
  redirect_to_index if user_not_logged_in?
  erb :new, layout: :layout
end

def authenticate_password?(username, password)
  users = return_users

  if users.key?(username)
    bcrypt_password = BCrypt::Password.new(users[username])
    bcrypt_password == password
  else
    false
  end
end

get '/signup' do
  erb :signup, layout: :layout
end

def save_user_credentials(username, password)
  users_file_path = File.join(parent_path_of_file, 'users.yml')

  users = YAML.load_file(users_file_path)
  users[username] = BCrypt::Password.create(password).to_s

  File.open(users_file_path, 'w') do |file|
    file.write(users.to_yaml)
  end
end

def validate_signup_username(username)
  if return_users.keys.any?(username)
    'That username has already been taken.'
  elsif username == ''
    'Thats not a valid username'
  end
end

post '/signup' do
  username = params[:username].strip
  error = validate_signup_username(username)
  if error
    session[:message] = error
    erb :signup, layout: :layout
  else
    save_user_credentials(username, params[:password])
    session[:message] = 'You have successfully created an account.'
    redirect '/'
  end
end

post '/:filename/duplicate' do
  redirect_to_index if user_not_logged_in?
  filename = params[:filename]
  file_path = File.join(data_path, filename)

  file_copy = filename.sub(/(?=\.[^.]+$)/, '_copy')
  file_copy_path = File.join(data_path, file_copy)

  FileUtils.cp(file_path, file_copy_path)

  redirect '/'
end

post '/users/signin' do
  username = params[:username]
  password = params[:password]

  if authenticate_password?(username, password)
    session[:username] = username
    session[:message] = 'Welcome'
    redirect '/'
  else
    session[:message] = 'Invalid credentials'
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
  redirect_to_index if user_not_logged_in?
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
  redirect_to_index if user_not_logged_in?
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

get '/:filename/edit' do
  redirect_to_index if user_not_logged_in?
  file_path = File.join(data_path, params[:filename])

  @filename = params[:filename]
  @file = File.read(file_path)

  erb :edit, layout: :layout
end

def next_file_version_name(name)
  matches = /([a-z]+)([0-9]+)/i.match(name)

  if matches
    base_name, version = matches.captures
    version = version.to_i + 1
    base_name + version.to_s + File.extname(name)
  else
    "#{File.basename(name, '.*')}1#{File.extname(name)}"
  end
end

post '/:filename' do
  redirect_to_index if user_not_logged_in?

  if params[:save_as] == 'new_file'
    file_name = next_file_version_name(params[:filename])
    file_path = File.join(data_path, file_name)
  else
    file_path = File.join(data_path, params[:filename])
  end
  File.write(file_path, params[:content])

  session[:message] = "#{params[:filename]} has been updated"
  redirect '/'
end


__END__

