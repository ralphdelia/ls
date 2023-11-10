require "sinatra"
require "sinatra/reloader"
require 'tilt/erubis'

# erb pulls from views
get "/" do
  @files = Dir.glob("public/*").map {|file| File.basename(file) }.sort
  @files.reverse! if params[:sort] == "desc"
  erb :template
end

# we load content from files 
# we add the content to the template we pass to erb
  # erb from views


=begin
 have a public folder 
 have 5 files in the public folder

 allow a user to click a file and be taken to it 
 use :filename 

=end
