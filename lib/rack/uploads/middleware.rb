module Rack
  class Uploads

    def initialize(app, options={})
      @app = app
      @session_authorized = options[:session_authorized] || true
      @nginx = options[:nginx] || [{ :tmp_path => "_tmp_path", :filename => "_file_name" }]
    end

    def call(env)
      req = Rack::Request.new(env)
      if req.post? && req.form_data?
        return not_authorized unless @session_authorized == true || (@session_authorized.respond_to?(:call) && @session_authorized.call(req) == true)
        uploads = []
        req.params.each do |key,param|
          if param_file = file(req, key)
            uploads << param_file
            req.params[key] = param_file
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

    def multipart?(req)
      req.media_type == "multipart/form-data"
    end

    def file(req, key)
      param = req.params[key]
      return UploadedFile.new(key, param) if param.instance_of?(Hash) && param[:tempfile]
      @nginx.each do |nginx|
        if key =~ %r{^(.+)#{nginx[:tmp_path]}$}
          tmp_path = param
          filename = req.params["#{$1}#{nginx[:filename]}"]
          return UploadedNginxFile.new($1, {:filename => filename, :temp_path => tmp_path}) if ::File.exist?(tmp_path) && filename
        end
      end
      nil
    end

    def invalid_request
      [400, {}, 'Invalid Request']
    end

    def not_authorized
      [403, {}, 'Not Authorized']
    end

  end
end
