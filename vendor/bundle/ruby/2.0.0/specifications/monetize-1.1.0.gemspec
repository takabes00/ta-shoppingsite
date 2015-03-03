# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "monetize"
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Shane Emmons"]
  s.date = "2014-12-16"
  s.description = "A library for converting various objects into `Money` objects."
  s.email = ["shane@emmons.io"]
  s.homepage = "https://github.com/RubyMoney/monetize"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.14"
  s.summary = "A library for converting various objects into `Money` objects."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<money>, ["~> 6.5.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 3.0.0.beta1"])
    else
      s.add_dependency(%q<money>, ["~> 6.5.0"])
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 3.0.0.beta1"])
    end
  else
    s.add_dependency(%q<money>, ["~> 6.5.0"])
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 3.0.0.beta1"])
  end
end
