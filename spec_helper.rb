require 'json'

def sandbox_dir
  "#{test_root}/sandbox"
end

def clean_sandbox
  FileUtils.rm_rf Dir.glob sandbox_dir + "/*"
end

def test_root
  @test_root ||= File.expand_path File.dirname(__FILE__) + "/spec"
end

def json_file file
  JSON.load File.open(file)
end
