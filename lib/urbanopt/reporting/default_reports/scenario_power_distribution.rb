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

require 'json'
require 'json-schema'

module URBANopt
  module Reporting
    module DefaultReports
      ##
      # scenario_power_distribution include eletrical power distribution systems information.
      ##
      class ScenarioPowerDistribution
        attr_accessor :substations, :distribution_lines, :capacitors
        ##
        # ScenarioPowerDistribution class initialize all scenario_power_distribution attributes:
        # +:substations+ , +:distribution_lines+
        ##
        # [parameters:]
        # +hash+ - _Hash_ - A hash which may contain a deserialized power_distribution.
        ##
        def initialize(hash = {})
          hash.delete_if { |k, v| v.nil? }
          hash = defaults.merge(hash)

          @substations = hash[:substations]
          @distribution_lines = hash[:distribution_lines]
          @capacitors = hash[:capacitors]
         
          # initialize class variables @@validator and @@schema
          @@validator ||= Validator.new
          @@schema ||= @@validator.schema
        end

        ##
        # Assigns default values if attribute values do not exist.
        ##
        def defaults
          hash = {}
          hash[:substations] = []
          hash[:distribution_lines] = []
          hash[:capacitors] = []

          return hash
        end

        ##
        # Converts to a Hash equivalent for JSON serialization.
        ##
        # - Exclude attributes with nil values.
        # - Validate power_distribution hash properties against schema.
        ##
        def to_hash
          result = {}
          result[:substations] = @substations if @substations
          result[:distribution_lines] = @distribution_lines if @distribution_lines
          result[:capacitors] = @capacitors if @capacitors

          # validate power_distribution properties against schema
          if @@validator.validate(@@schema[:definitions][:ScenarioPowerDistribution][:properties], result).any?
            raise "scenario_power_distribution properties does not match schema: #{@@validator.validate(@@schema[:definitions][:ScenarioPowerDistribution][:properties], result)}"
          end

          return result
        end

        ##
        # Add a substation
        ## 
        def add_substation(hash = {})
          hash.delete_if { |k, v| v.nil? }
          hash = defaults.merge(hash)
          # field: nominal_voltage
          substation = {}
          substation['nominal_voltage'] = hash[:nominal_voltage]
          @substations << substation
        end

        ##
        # Add a line
        ##
        def add_line(hash = {})
          hash.delete_if { |k, v| v.nil? }
          hash = defaults.merge(hash)
          # fields: length, ampacity, commercial_line_type
          line = {}
          line['length'] = hash[:length]
          line['ampacity'] = hash[:ampacity]
          line['commercial_line_type'] = hash[:commercial_line_type]

          @distribution_lines << line
        end

        ## 
        # Add a capacitor
        ##
        def add_capacitor(hash = {})
          hash.delete_if { |k, v| v.nil? }
          hash = defaults.merge(hash)
          # fields: nominal_capacity
          cap = {}
          cap['nominal_capacity'] = hash[:nominal_capacity]
        end
      end
    end
  end
end
