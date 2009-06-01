require File.dirname(__FILE__) + "/spec_helper"

require 'rack/test'
require 'rack/utils'
require 'rack/mock'

describe Rack::Uploads do

  include Rack::Test::Methods

  def hello_world
    lambda { |env| 
      req = Rack::Request.new(env)
      if req.path_info == "/uploads" && req.post? && env['rack.uploads']
        [200, {}, "Received Files"]
      else
        [200, {}, "Hello, World!"]
      end
    }
  end


  def user_session
    {"rack.session" => {:user_id => 100}}
  end

  context "file uploads" do

    def app
      @backend ||= Rack::Uploads.new(hello_world)
    end

    it "should receive and store a file upload" do
      post '/uploads', {:file => multipart_fixture("test_data.txt")}
      last_response.status.should == 200
      last_response.body.should == "Received Files"
      File.exist?("/tmp/blogage_upload").should be_true
    end

    it "should receive and store a flash upload" do
      post '/uploads', {'Filedata' => multipart_fixture("test_data.txt")}
      last_response.status.should == 200
      last_response.body.should == "Received Files"
    end

    it "should receive and move a nginx upload" do
      file = multipart_fixture("test_data.txt")
      post '/uploads', nginx_upload_request("file", "test_data.txt")
      last_response.status.should == 200
      last_response.body.should == "Received Files"
    end

    it "should cleanup received nginx uploads" do
      file = multipart_fixture("test_data.txt")
      post '/uploads', nginx_upload_request("file", "test_data.txt")
      File.exist?("/tmp/rack_upload_nginx_tmp").should be_false
    end

  end

  context "authorization" do
    def app
      Rack::Uploads.new(hello_world, {:session_authorized => lambda {  |req| (req.env['rack.session'] && req.env['rack.session'][:user_id] && req.env['rack.session'][:user_id].to_i > 0) || (req.params['flash_token'] && req.params['flash_token'] == '123') }})
    end

    it "should not allow non-post requests" do
      get '/uploads'
      last_response.status.should == 400
      put '/uploads'
      last_response.status.should == 400
      delete '/uploads'
      last_response.status.should == 400
    end

    it "should not allow unauthorized uploads" do
      post '/uploads'
      last_response.status.should == 403
    end

    it "should authorize logged in users to upload" do
      response = post '/uploads', {}, user_session
      last_response.status.should_not == 400
      last_response.status.should_not == 403
    end

    it "should authorize flash uploaders to upload" do
      response = post '/uploads?flash_token=123'
      last_response.status.should_not == 400
      last_response.status.should_not == 403
    end

  end

  private
  def nginx_upload_request(key, name, temp_path="/tmp/rack_upload_nginx_tmp")
    FileUtils.cp multipart_file(name), temp_path
    {"file_path" => temp_path, "#{key}_name" => name, "#{key}_content_type" => "text/plain", "#{key}_size" => File.size(multipart_file(name))}
  end

  def multipart_fixture(name)
    Rack::Test::UploadedFile.new(multipart_file(name))
  end

  def multipart_file(name)
    File.join(File.dirname(__FILE__), "fixtures/files", name)
  end

end

