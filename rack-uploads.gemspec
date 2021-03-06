# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rack-uploads}
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mutwin Kraus"]
  s.date = %q{2009-10-13}
  s.email = %q{mutle@blogage.de}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "init.rb",
     "lib/rack/uploads.rb",
     "lib/rack/uploads/middleware.rb",
     "lib/rack/uploads/uploaded_file.rb",
     "rack-uploads.gemspec",
     "spec/fixtures/files/test_data.txt",
     "spec/middleware_spec.rb",
     "spec/spec_helper.rb",
     "spec/uploaded_file_spec.rb"
  ]
  s.homepage = %q{http://github.com/mutle/rack-uploads}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Rack Upload handler with Nginx Upload Module support}
  s.test_files = [
    "spec/middleware_spec.rb",
     "spec/spec_helper.rb",
     "spec/uploaded_file_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
