%w(middleware uploaded_file).each { |f| require File.join(File.dirname(__FILE__), "uploads", f) }
