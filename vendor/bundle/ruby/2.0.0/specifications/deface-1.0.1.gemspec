# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "deface"
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brian D Quinn"]
  s.date = "2014-09-09"
  s.description = "Deface is a library that allows you to customize ERB, Haml and Slim views in a Rails application without editing the underlying view."
  s.email = "brian@spreecommerce.com"
  s.extra_rdoc_files = ["README.markdown", "CHANGELOG.markdown"]
  s.files = ["README.markdown", "CHANGELOG.markdown"]
  s.homepage = "https://github.com/spree/deface"
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.14"
  s.summary = "Deface is a library that allows you to customize ERB, Haml and Slim views in Rails"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, ["~> 1.6.0"])
      s.add_runtime_dependency(%q<rails>, [">= 3.1"])
      s.add_runtime_dependency(%q<colorize>, [">= 0.5.8"])
      s.add_runtime_dependency(%q<polyglot>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 2.11.0"])
      s.add_development_dependency(%q<haml>, [">= 3.1.4"])
      s.add_development_dependency(%q<slim>, ["= 2.0.0"])
      s.add_development_dependency(%q<simplecov>, [">= 0.6.4"])
      s.add_development_dependency(%q<generator_spec>, ["~> 0.8"])
    else
      s.add_dependency(%q<nokogiri>, ["~> 1.6.0"])
      s.add_dependency(%q<rails>, [">= 3.1"])
      s.add_dependency(%q<colorize>, [">= 0.5.8"])
      s.add_dependency(%q<polyglot>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 2.11.0"])
      s.add_dependency(%q<haml>, [">= 3.1.4"])
      s.add_dependency(%q<slim>, ["= 2.0.0"])
      s.add_dependency(%q<simplecov>, [">= 0.6.4"])
      s.add_dependency(%q<generator_spec>, ["~> 0.8"])
    end
  else
    s.add_dependency(%q<nokogiri>, ["~> 1.6.0"])
    s.add_dependency(%q<rails>, [">= 3.1"])
    s.add_dependency(%q<colorize>, [">= 0.5.8"])
    s.add_dependency(%q<polyglot>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 2.11.0"])
    s.add_dependency(%q<haml>, [">= 3.1.4"])
    s.add_dependency(%q<slim>, ["= 2.0.0"])
    s.add_dependency(%q<simplecov>, [">= 0.6.4"])
    s.add_dependency(%q<generator_spec>, ["~> 0.8"])
  end
end
