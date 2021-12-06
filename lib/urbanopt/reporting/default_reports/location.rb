# *********************************************************************************
# URBANopt™, Copyright (c) 2019-2021, Alliance for Sustainable Energy, LLC, and other
# contributors. All rights reserved.

# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:

# Redistributions of source code must retain the above copyright notice, this list
# of conditions and the following disclaimer.

# Redistributions in binary form must reproduce the above copyright notice, this
# list of conditions and the following disclaimer in the documentation and/or other
# materials provided with the distribution.

# Neither the name of the copyright holder nor the names of its contributors may be
# used to endorse or promote products derived from this software without specific
# prior written permission.

# Redistribution of this software, without modification, must refer to the software
# by the same designation. Redistribution of a modified version of this software
# (i) may not refer to the modified version by the same designation, or by any
# confusingly similar designation, and (ii) must refer to the underlying software
# originally provided by Alliance as “URBANopt”. Except to comply with the foregoing,
# the term “URBANopt”, or any confusingly similar designation may not be used to
# refer to any modified version of this software or any modified version of the
# underlying software originally provided by Alliance without the prior written
# consent of Alliance.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.
# *********************************************************************************

require_relative 'validator'
require 'json-schema'
require 'json'

module URBANopt
  module Reporting
    module DefaultReports
      ##
      # Location include all location information.
      ##
      class Location
        attr_accessor :latitude_deg, :longitude_deg, :surface_elevation_ft, :weather_filename #:nodoc:

        ##
        # Location class initialize location attributes: +:latitude_deg+ , +:longitude_deg+ , +:surface_elevation_ft+ , +:weather_filename+
        ##
        # [parameters:]
        # +hash+ - _Hash_ - A hash which may contain a deserialized location.
        ##
        def initialize(hash = {})
          hash.delete_if { |k, v| v.nil? }
          hash = defaults.merge(hash)

          @latitude_deg = hash[:latitude_deg]
          @longitude_deg = hash[:longitude_deg]
          @surface_elevation_ft = hash[:surface_elevation_ft]
          @weather_filename = hash[:weather_filename]

          # initialize class variables @@validator and @@schema
          @@validator ||= Validator.new
          @@schema ||= @@validator.schema
        end

        ##
        # Convert to a Hash equivalent for JSON serialization.
        ##
        # - Exclude attributes with nil values.
        # - Validate location hash properties against schema.
        ##
        def to_hash
          result = {}
          result[:latitude_deg] = @latitude_deg if @latitude_deg
          result[:longitude_deg] = @longitude_deg if @longitude_deg
          result[:surface_elevation_ft] = @surface_elevation_ft if @surface_elevation_ft
          result[:weather_filename] = @weather_filename if @weather_filename

          # validate location properties against schema
          if @@validator.validate(@@schema[:definitions][:Location][:properties], result).any?
            raise "end_uses properties does not match schema: #{@@validator.validate(@@schema[:definitions][:Location][:properties], result)}"
          end

          return result
        end

        ##
        # Assign default values if values does not exist
        ##
        def defaults
          hash = {}
          hash[:latitude_deg] = nil
          hash[:longitude_deg] = nil
          hash[:surface_elevation_ft] = nil
          hash[:weather_filename] = nil

          return hash
        end
      end
    end
  end
end
