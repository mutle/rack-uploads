require File.dirname(__FILE__) + "/spec_helper"

require 'rack/test'
require 'rack/utils'
require 'rack/mock'

describe Rack::Uploads::UploadedFile do

  it "should pass through file attributes" do
    file = Rack::Uploads::UploadedFile.new("foo", {:foo => "bar"})
    file.foo.should == "bar"
    lambda { file.bar }.should raise_error(NoMethodError)
  end

end
