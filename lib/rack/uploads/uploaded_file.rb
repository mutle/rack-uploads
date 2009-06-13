module Rack
  class Uploads

    class UploadedFile
      attr_reader :key, :file
      def initialize(key, file)
        @key = key
        @file = file
        @cleanup_needed = false
      end

      def temp_path
        @file[:tempfile].path
      end

      def mv(destination)
        FileUtils.mv(temp_path, destination)
        @cleanup_needed = false
      end

      def cp(destination)
        FileUtils.cp(temp_path, destination)
      end

      def rm
        FileUtils.rm(temp_path)
      end

      def size
        ::File.size(temp_path)
      end

      def [](key)
        @file[key]
      end

      def method_missing(meth, *args)
        return @file[meth.to_sym] if @file[meth.to_sym]
        super(meth, *args)
      end

      def cleanup
        rm if @cleanup_needed
      end
    end

    class UploadedNginxFile < UploadedFile
      def initialize(key, file)
        super(key, file)
        @cleanup_needed = true
      end
      def temp_path
        @file[:temp_path]
      end
    end

  end
end
