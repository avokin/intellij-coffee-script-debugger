# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "coffee-script-redux-debugger/version"

Gem::Specification.new do |s|
  s.name        = "coffee-script-redux-debugger"
  s.version     = CoffeeScriptReduxDebugger::VERSION
  s.authors     = ["Andrey Vokin"]
  s.email       = ["andrey.vokin@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "coffee-script-redux-debugger"

  s.files = Dir["README.md", "LICENSE", "lib/**/*.rb"]
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = ["coffee-script-redux-debugger"]
  s.require_paths = ["lib"]

  s.add_dependency "sprockets"

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
