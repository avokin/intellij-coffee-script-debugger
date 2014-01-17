require 'tilt'

module Sprockets
  class SourceMapComment < Tilt::Template
    def prepare
    end

    def evaluate(context, locals, &block)
      if File.extname(file) =~ /\.coffee$/
        "#{data}\n//@ sourceMappingURL=http://localhost:3000/assets/#{context.logical_path}.map"
      else
        data
      end
    end
  end
end