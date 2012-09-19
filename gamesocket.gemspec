$:.push File.expand_path("../lib", __FILE__)
require 'gamesocket/version'

Gem::Specification.new do |s|
  s.name = "gamesocket"
  s.version = GameSocket::VERSION
  s.summary = "GameSocket, a more comfortable UDPSocket."
  s.description = %q{GameSocket is ideally used as the bottom layer of server-client communication in, say, multiplayer games.}
  s.author = "funkensturm."
  s.homepage = "http://github.com/funkensturm/gamesocket"

  files = `git ls-files`.split("\n")

  s.test_files = `git ls-files -- {test,spec}/*`.split("\n")

  s.require_paths = ["lib"]

  s.add_dependency 'msgpack', ['~> 0.4.7']
  s.add_development_dependency 'rspec', ['~> 2.11.0']
  s.add_development_dependency 'guard-rspec', ['~> 1.2.1']
  s.add_development_dependency 'rb-fsevent', ['~> 0.9.1']
end