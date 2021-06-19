# -*- encoding: utf-8 -*-
# stub: deep_dup 0.0.3 ruby lib

Gem::Specification.new do |s|
  s.name = "deep_dup".freeze
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Oldrich Vetesnik".freeze]
  s.bindir = "exe".freeze
  s.date = "2015-07-02"
  s.email = ["oldrich.vetesnik@gmail.com".freeze]
  s.homepage = "https://github.com/ollie/deep_dup".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.0.3".freeze
  s.summary = "Deep duplicate Ruby objects.".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.10"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.3"])
      s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.10"])
      s.add_development_dependency(%q<rubocop>.freeze, ["~> 0.32"])
      s.add_development_dependency(%q<pry>.freeze, ["~> 0.10"])
      s.add_development_dependency(%q<yard>.freeze, ["~> 0.8"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.4"])
    else
      s.add_dependency(%q<bundler>.freeze, ["~> 1.10"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.3"])
      s.add_dependency(%q<simplecov>.freeze, ["~> 0.10"])
      s.add_dependency(%q<rubocop>.freeze, ["~> 0.32"])
      s.add_dependency(%q<pry>.freeze, ["~> 0.10"])
      s.add_dependency(%q<yard>.freeze, ["~> 0.8"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.4"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.10"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.3"])
    s.add_dependency(%q<simplecov>.freeze, ["~> 0.10"])
    s.add_dependency(%q<rubocop>.freeze, ["~> 0.32"])
    s.add_dependency(%q<pry>.freeze, ["~> 0.10"])
    s.add_dependency(%q<yard>.freeze, ["~> 0.8"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.4"])
  end
end
