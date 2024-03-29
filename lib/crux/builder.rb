require "json"
require "net/http"

module Crux
  class Builder
    def self.build
      project_name = File.basename File.expand_path(".")

      script_file = Dir.glob("*.user.js").first
      project_name = File.basename script_file, ".user.js"

      props = parse_attrs IO.readlines(script_file)

      Dir.mkdir "build"
      Dir.mkdir "build/vendor"

      props[:require].each do |url|
        dest = File.new "build/vendor/#{File.basename url}", "w"
        dest << Net::HTTP.get( URI.parse( url ) )
        dest.close
        props[:local_require] << "vendor/#{File.basename url}"
      end

      manifest_obj = build_manifest script_file, props

      manifest = File.new "build/manifest.json", "w"
      manifest << JSON.generate(manifest_obj)
      manifest.close
    end

    def self.build_manifest(script_file, props)
      {
        :name => props[:name],
        :version => props[:version],
        :description => props[:description],
        :content_scripts => [{
          :matches => props[:include],
          :js => props[:local_require] << script_file,
        }],
        :permissions => props[:include],
      }
    end

    def self.parse_attrs(lines)
      props = { :include => [], :require => [], :local_require => [], :version => "" }
      lines.each do |line|
        if line =~ /\s*\/\/\s*@(\w+)\s+(.*)/
          key = $1.to_sym
          if props[key] && props[key].respond_to?(:push)
            props[key].push $2
          else
            props[key] = $2
          end
        end
      end
      props
    end
  end
end
