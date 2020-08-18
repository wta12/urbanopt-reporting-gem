require 'version'
require 'openstudio/extension'

module URBANopt
  module Reporting
    class Extension < OpenStudio::Extension::Extension
      # Override the base class
      def initialize
        super

        @root_dir = File.absolute_path(File.join(File.dirname(__FILE__), '..'))
      end
    end
  end
end
