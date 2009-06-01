module Rack
  class Uploads

    def initialize(app, options={})
      @app = app
      @path = options[:path] || '/uploads'
      @file_params = options[:file_params] || ["file", "Filedata"]
      @session_authorized = options[:session_authorized] || true
    end

    def call(env)
      req = Rack::Request.new(env)
      if req.path_info == @path && req.post?
        return not_authorized unless @session_authorized == true || (@session_authorized.respond_to?(:call) && @session_authorized.call(req) == true)
        uploads = []
        @file_params.each do |file_key|
          if file = req.params[file_key]
            uploads << UploadedFile.new(file_key, file)
          elsif req.params["#{file_key}_name"] && req.params["#{file_key}_path"]
            uploads << UploadedNginxFile.new(file_key, {:filename => req.params["#{file_key}_name"], :temp_path => req.params["#{file_key}_path"] })
          end
        end
        env['rack.uploads'] = uploads if uploads.size > 0
      end
      resp = @app.call(env)
      if uploads && uploads.size > 0
        uploads.each { |upload| upload.cleanup }
      end
      resp
    end

    def invalid_request
      [400, {}, 'Invalid Request']
    end

    def not_authorized
      [403, {}, 'Not Authorized']
    end

  end
end
