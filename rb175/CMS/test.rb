names = %w(something.txt something1.txt, something15234523.txt)

names.each do |name|
  matches = /([a-z]+)([0-9]+)/i.match(name)

  if matches
    base_name, version = matches.captures
    version = version.to_i + 1
    p base_name + version.to_s + File.extname(name)
  else
    p File.basename(name, '.*') + "1" + File.extname(name)
  end
end

def next_file_version_name(name)
  matches = /([a-z]+)([0-9]+)/i.match(name)

  if matches
    base_name, version = matches.captures
    version = version.to_i + 1
    base_name + version.to_s + File.extname(name)
  else
    File.basename(name, '.*') + "1" + File.extname(name)
  end
end