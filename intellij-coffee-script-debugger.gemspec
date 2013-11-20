# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'intellij-coffee-script-debugger/version'

Gem::Specification.new do |s|
  s.name        = 'intellij-coffee-script-debugger'
  s.version     = IntellijCoffeeScriptDebugger::VERSION
  s.authors     = ['Andrey Vokin']
  s.email       = %w(andrey.vokin@gmail.com)
  s.homepage    = ''
  s.summary     = 'Gem for debugging CoffeeScript in Rails applications'
  s.description = 'Gem for debugging CoffeeScript in Rails applications'

  s.rubyforge_project = 'intellij-coffee-script-debugger'

  s.files = Dir['README.md', 'LICENSE', 'lib/**/*.rb']
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = ['intellij-coffee-script-debugger']
  s.require_paths = ['lib']

  s.add_dependency 'coffee-script'
  s.add_dependency 'sprockets'
  s.add_dependency 'execjs'
end
