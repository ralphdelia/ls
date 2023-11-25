require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'securerandom'

configure do
  enable :sessions
  set :session_secret, SecureRandom.hex(32)
end
def data_path
  File.expand_path(File.join('public', 'data'), __dir__)
end
 
get '/' do 
  pattern = File.join(data_path, '*')
  @photos = Dir.glob(pattern).map { |path| '/data/' + File.basename(path)}
  @main_image = @photos.shift
  erb :images, layout: :layout 
end

get '/:photo' do 
  pattern = File.join(data_path, '*')
  all_files = Dir.glob(pattern).map { |path| '/data/' + File.basename(path) }
  @main_image, @photos = all_files.partition do |file|
    file == File.join('/data', params[:photo]) 
  end 
 
  erb :images, layout: :layout
end



post '/uploadphoto' do 
  if params[:img]
    File.open(File.join(data_path, params[:img][:filename]), 'wb') do |file|
      file.write(params[:img][:tempfile].read)
    end
  end
  session[:message] = "#{params[:img]} #{data_path}"
  redirect '/' 

end
