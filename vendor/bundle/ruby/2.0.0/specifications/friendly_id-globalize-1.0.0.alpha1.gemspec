# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "friendly_id-globalize"
  s.version = "1.0.0.alpha1"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Norman Clarke", "Philip Arndt"]
  s.date = "2013-08-29"
  s.description = "Adds Globalize 3 support to the FriendlyId gem."
  s.email = ["norman@njclarke.com", "p@arndt.io"]
  s.homepage = "http://github.com/norman/friendly_id-globalize"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.0.14"
  s.summary = "Globalize support for FriendlyId."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<friendly_id>, ["< 6.0", ">= 5.0.0.beta4"])
      s.add_development_dependency(%q<minitest>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<globalize3>, [">= 0"])
    else
      s.add_dependency(%q<friendly_id>, ["< 6.0", ">= 5.0.0.beta4"])
      s.add_dependency(%q<minitest>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<globalize3>, [">= 0"])
    end
  else
    s.add_dependency(%q<friendly_id>, ["< 6.0", ">= 5.0.0.beta4"])
    s.add_dependency(%q<minitest>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<globalize3>, [">= 0"])
  end
end
