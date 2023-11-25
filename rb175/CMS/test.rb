require 'bcrypt'
require 'yaml'
require_relative './cms.rb'


x = [:something, :else_something, "ralph"]
p x.any?("ralph")



__END__
path = File.join(parent_path_of_file, 'users.yml')
user = YAML.load_file(path)

p BCrypt::Password.new(user[:else_something]) == "password"

pw = BCrypt::Password.create('password').to_s

user[:else_something] = pw


File.open(path, 'w') do |file|
  file.write(user.to_yaml)
end