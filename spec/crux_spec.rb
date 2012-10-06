require 'spec_helper'

describe "crux" do
  before do
    Dir.mkdir sandbox_dir unless File.directory? sandbox_dir
    clean_sandbox
    #TODO jankety
    @old_wd = Dir.pwd
    Dir.chdir sandbox_dir
  end
  after do
    Dir.chdir @old_wd
    clean_sandbox
  end

  context "regular build" do
    before do
      FileUtils.cp "#{test_root}/fixtures/test.user.js", sandbox_dir
      Crux::Builder.build
    end

    describe "manifest file" do
      it "exists in build dir" do
        File.exists?("build/manifest.json").should be_true
      end
      it "has correct contents" do
        json_file("#{sandbox_dir}/build/manifest.json").should == json_file("#{test_root}/fixtures/manifest.json")
      end
    end

    context "@require urls" do
      it "fetches resources" do
        FakeWeb.last_request.method.should == "GET"
        FakeWeb.last_request.path.should == "/ajax/libs/jquery/1.6.4/jquery.min.js"
      end
      it "creates files in the build dir" do
        File.exists?("build/vendor/jquery.min.js").should be_true
      end
      it "puts content into files" do
        IO.read("build/vendor/jquery.min.js", JS_CONTENT.bytesize + 1).should == JS_CONTENT
      end
    end
  end
end
