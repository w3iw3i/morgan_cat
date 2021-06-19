# -*- encoding: utf-8 -*-
# stub: exonio 0.5.4 ruby lib

Gem::Specification.new do |s|
  s.name = "exonio".freeze
  s.version = "0.5.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Rafael Izidoro".freeze]
  s.bindir = "exe".freeze
  s.date = "2020-05-29"
  s.description = "This gem implements some useful Excel formulas like PMT, IPMT, NPER, PV, etc...".freeze
  s.email = ["izidoro.rafa@gmail.com".freeze]
  s.homepage = "http://github.com/noverde/exonio".freeze
  s.rubygems_version = "3.0.3".freeze
  s.summary = "Excel usefull formulas written in Ruby".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.11"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_development_dependency(%q<pry-byebug>.freeze, ["~> 3.3.0"])
    else
      s.add_dependency(%q<bundler>.freeze, ["~> 1.11"])
      s.add_dependency(%q<rake>.freeze, ["~> 13.0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_dependency(%q<pry-byebug>.freeze, ["~> 3.3.0"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.11"])
    s.add_dependency(%q<rake>.freeze, ["~> 13.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_dependency(%q<pry-byebug>.freeze, ["~> 3.3.0"])
  end
end
