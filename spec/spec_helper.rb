require 'json'

require 'crux/builder'

def sandbox_dir
  "#{test_root}/sandbox"
end

def clean_sandbox
  FileUtils.rm_rf Dir.glob sandbox_dir + "/*"
end

def test_root
  @test_root ||= File.expand_path File.dirname(__FILE__)
end

def json_file file
  JSON.load File.open(file)
end

JS_CONTENT = "/* Fake Javascript file */ alert('foo');"
require 'fakeweb'
FakeWeb.allow_net_connect = false
FakeWeb.register_uri :get, %r|.*\.js|, :body => JS_CONTENT
