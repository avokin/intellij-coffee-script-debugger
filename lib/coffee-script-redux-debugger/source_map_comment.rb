require 'tilt'

module Sprockets
  class SourceMapComment < Tilt::Template
    def prepare
    end

    def evaluate(context, locals, &block)
      if File.extname(file) =~ /\.coffee$/
        "#{data}\n//@ sourceMappingURL=#{File.basename(file, ".*")}.map"
      else
        data
      end
    end
  end
end