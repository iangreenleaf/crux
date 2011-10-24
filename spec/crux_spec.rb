require 'spec_helper'

describe "crux" do
  before do
    File.makedirs sandbox_dir unless File.directory? sandbox_dir
    clean_sandbox
    #TODO jankety
    Dir.chdir sandbox_dir
  end
  after { clean_sandbox }

  describe "manifest file" do
    before do
      FileUtils.cp "#{test_root}/fixtures/test.user.js", sandbox_dir
      require "#{test_root}/../build.rb"
    end
    it "exists in build dir" do
      File.exists?("build/manifest.json").should be_true
    end
  end
end
