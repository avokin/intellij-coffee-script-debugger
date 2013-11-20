# encoding: utf-8

require 'execjs'
require 'coffee_script/source'

module CoffeeScript
  module Source
    def self.bundled_path
      File.expand_path('coffee-script.js', File.dirname(__FILE__))
    end

    def self.path
      @path ||= ENV['COFFEESCRIPT_SOURCE_PATH'] || bundled_path
    end

    def self.path=(path)
      @contents = @version = @bare_option = @context = nil
      @path = path
    end

    def self.contents
        @contents ||= "root = {};\n" + File.read(path).encode!('UTF-8', 'UTF-8', :invalid => :replace)
    end

    def self.version
      @version ||= context.eval('CoffeeScript.VERSION')
    end

    def self.bare_option
      @bare_option ||= 'bare'
    end

    def self.context
      @context ||= ExecJS.compile(contents)
    end
  end

  class << self
    def engine
    end

    def engine=(engine)
    end

    def version
      Source.version
    end

    # Compile a Coffee Script file to JavaScript
    # or generate the source maps.
    #
    # @param [String,#read] the source string or IO
    # @param [Hash] options the compiler options
    # @option options [Boolean] bare compile the JavaScript without the top-level function safety wrapper
    # @option options [String] format the output format, either `:map` or `:js`
    #
    def compile(script, options = {})

      script = script.read if script.respond_to?(:read)

      if options.key?(:bare)
      elsif options.key?(:no_wrap)
        options[:bare] = options[:no_wrap]
      else
        options[:bare] = false
      end

      if options[:format] == :map
        options.delete(:format)
        options[:sourceMap] = true
        options[:sourceFiles] = [options[:filename]]

        wrapper = <<-WRAPPER
            (function(script, options) {
              try {
                return CoffeeScript.compile(script, options);
              } catch (err) {
                if (err instanceof SyntaxError && err.location) {
                  throw new SyntaxError([options.filename, err.location.first_line + 1, err.location.first_column + 1].join(":") + ": " + err.message)
                } else {
                  throw err;
                }
              }
            })
        WRAPPER
        Source.context.call(wrapper, script, options)
      else
        Source.context.call("CoffeeScript.compile", script, options)
      end
    end
  end
end
