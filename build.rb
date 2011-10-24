#!/usr/bin/env ruby

require "json"

project_name = File.basename File.expand_path(".")

script_file = Dir.glob("*.user.js").first
project_name = File.basename script_file, ".user.js"
puts project_name

props = {}
IO.readlines(script_file).each do |line|
  if line =~ /\s*\/\/\s*@(\w+)\s+(.*)/
    props[$1.to_sym] = $2 # TODO handle arrays
  end
end

manifest_obj = {
  :name => props[:name],
  :version => "0.1.0", #TODO
  :description => props[:description],
  :content_scripts => [
    {
      :matches => [ props[:include] ],
      :js => [ script_file ],
    },
  ],
  :permissions => [ props[:include] ],
}

Dir.mkdir "build"
manifest = File.new "build/manifest.json", "w"
manifest << JSON.generate(manifest_obj)
manifest.close
