require 'spec_helper'

describe Crux::Builder do
  describe ".parse_attrs" do
    it "reads greasemonkey directives" do
      attrs = Crux::Builder.parse_attrs([ "//@name FooBar", "  //  @description   Does things." ])
      attrs[:name].should == "FooBar"
      attrs[:description].should == "Does things."
    end

    it "handles multiple values on certain keys" do
      attrs = Crux::Builder.parse_attrs([ "//@include foo.int", "//@include bar.int" ])
      attrs[:include].should == [ "foo.int", "bar.int" ]
    end

    it "overwrites value on other keys" do
      attrs = Crux::Builder.parse_attrs([ "//@name Foo", "//@name Quux" ])
      attrs[:name].should == "Quux"
    end
  end

  describe ".build_manifest" do
    it "builds hash" do
      props = {
        :name => "Foo",
        :version => "0.1.0",
        :description => "Unicorns.",
        :include => [ "foo", "bar" ],
        :local_require => [ "vendor/jquery" ],
      }
      manifest = Crux::Builder.build_manifest "myscript.js", props
      manifest.should == {
        :name => "Foo",
        :version => "0.1.0",
        :description => "Unicorns.",
        :content_scripts => [
          { :matches => [ "foo", "bar" ], :js => [ "vendor/jquery", "myscript.js" ] }
        ],
        :permissions => [ "foo", "bar" ]
      }
    end
  end
end
