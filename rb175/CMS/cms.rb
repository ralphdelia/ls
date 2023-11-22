require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require 'securerandom'
require "sinatra/content_for"
require 'redcarpet'

configure do 
  enable :sessions 
  set :session_secret, SecureRandom.hex(32)
end

root = File.expand_path("..", __FILE__)

get '/' do 
  @files = Dir.glob(root + "/data/*").map {|file| File.basename(file) }

  erb :index, layout: :layout
end

def render_markdown(file)
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  markdown.render(file)
end

get '/:filename' do
  filename = params[:filename]
  file_path = root + "/data/" + filename
  
  @files = Dir.glob(root + "/data/*").map {|file| File.basename(file) }
  unless @files.include?(filename) 
    session[:error] = "#{filename} does not exist"
    redirect '/'
  end
  
  if filename =~ /\.md\z/
    file = File.read(file_path)
    erb render_markdown(file)
  else 
    headers['Content-Type'] = 'text/plain'
    file = File.read(file_path)
  end
end


__END__

usea view helper to render the html
create a new markdwon instance
  pass the file content to the instance


  we are rendering text files from our routes
  we may need to render the file 
    return it from the route


    create method that accepts a file 
    creates a new mark down instance
    it renders the file an returns it

    pass in any files to the method 
    return the results from the route