#!/usr/bin/env ruby

require "json"

project_name = File.basename File.expand_path(".")

script_file = Dir.glob("*.user.js").first
project_name = File.basename script_file, ".user.js"
puts project_name

props = { :include => [], :require => [], :local_require => [], :version => "" }

IO.readlines(script_file).each do |line|
  if line =~ /\s*\/\/\s*@(\w+)\s+(.*)/
    key = $1.to_sym
    if props[key] && props[key].respond_to?(:push)
      props[key].push $2
    else
      props[key] = $2
    end
  end
end

Dir.mkdir "build"
Dir.mkdir "build/vendor"

props[:require].each do |url|
  #TODO extra jankety
  `wget --directory-prefix="build/vendor" #{url}`
  props[:local_require] << "vendor/#{File.basename url}"
end

manifest_obj = {
  :name => props[:name],
  :version => props[:version],
  :description => props[:description],
  :content_scripts => [
    {
      :matches => props[:include],
      :js => props[:local_require] << script_file,
    },
  ],
  :permissions => props[:include],
}

manifest = File.new "build/manifest.json", "w"
manifest << JSON.generate(manifest_obj)
manifest.close
