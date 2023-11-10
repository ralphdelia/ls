require "sinatra"
require "sinatra/reloader"
require 'tilt/erubis'
require 'yaml'

before do
  @users = YAML.load_file("users.yaml")
end

helpers do
  def comma_format(arr)
    arr.join(', ')
  end

  def count_interests(users)
    interests = users.reduce(0) { |acc, (k, v)| acc + v[:interests].size }
    "There are #{users.size} users with a total of #{interests} interests."
  end

end

get '/' do 
  redirect '/list' 
end

get '/list' do 
  @names = @users.map { |k, _| k.to_s } 

  erb :list
end

get '/user/:name' do
  @name = params[:name]
  @user_info = @users[@name.to_sym]

  @email = @user_info[:email]
  @interests = @user_info[:interests]

  @other_users = @users.keys.select do |k|
    k if k != @name.to_sym 
  end

  erb :user
end
