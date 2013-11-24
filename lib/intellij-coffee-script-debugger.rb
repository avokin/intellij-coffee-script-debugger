require 'intellij-coffee-script-debugger/version'
require 'intellij-coffee-script-debugger/source_map_comment'
require 'sprockets'
require 'sprockets/processing'
require 'sprockets/server'
require 'intellij-coffee-script-debugger/intellij_coffee_script'

module Sprockets
  class IntellijCoffeeScriptDebuggerClass < ::Rails::Railtie
    initializer "intellij.coffee.script.debugger", :after => "sprockets.environment" do |app|
      app.assets.register_postprocessor 'application/javascript', SourceMapComment
    end
  end

  module Server
    alias_method :old_call, :call

    def call(env)
      path = unescape(env['PATH_INFO'].to_s.sub(/^\//, ''))
      # URLs containing a `".."` are rejected for security reasons.
      if forbidden_request?(path)
        return forbidden_response
      end

      if File.extname(path) == '.coffee'
        asset = find_asset(path, :bundle => !body_only?(env), :source => true)
        coffee_file = File.read(asset.pathname)
        [200, {'Content-Type' => 'application/javascript'}, [coffee_file]]
      elsif File.extname(path) == '.map'
        path = path.chomp('.map')
        asset = find_asset(path, :bundle => !body_only?(env))

        if File.extname(asset.pathname) == '.coffee'
          coffee_file = File.read(asset.pathname)
          source_map_result = CoffeeScript.compile(coffee_file, {:format => :map, :filename => File.basename(asset.pathname)})
          source_map = source_map_result["v3SourceMap"]
          [200, {'Content-Type' => 'application/json'}, [source_map]]
        else
          old_call(env)
        end
      else
        old_call(env)
      end
    end
  end
end
