require "coffee-script-redux-debugger/version"
require "coffee-script-redux-debugger/source_map_comment"
require "sprockets"
require 'sprockets/processing'
require 'sprockets/server'
require 'coffee-script-redux-debugger/coffee_script_redux'

module Sprockets
  class CoffeeScriptReduxDebuggerClass < ::Rails::Railtie
    initializer "coffee.script.redux.debugger", :after => "sprockets.environment" do |app|
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
        [ 200, {'Content-Type' => 'application/javascript'}, [coffee_file] ]
      elsif File.extname(path) == '.map'
        path = path.chomp('.map')

        asset = find_asset(path, :bundle => !body_only?(env))

        coffee_file = File.read(asset.pathname)
        source_map = CoffeeScript.compile(coffee_file, {:format => :map}).gsub("unknown", File.basename(asset.pathname))
        [ 200, {'Content-Type' => 'application/json'}, [source_map] ]
      else
        old_call(env)
      end
    end
  end
end
