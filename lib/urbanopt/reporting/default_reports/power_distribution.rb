# *********************************************************************************
# URBANopt™, Copyright (c) 2019-2022, Alliance for Sustainable Energy, LLC, and other
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
      # power_distributio include eletrical power distribution systems information.
      ##
      class PowerDistribution
        attr_accessor :under_voltage_hours, :over_voltage_hours, :nominal_capacity,
                      :reactance_resistance_ratio, :nominal_voltage, :max_power_kw, :max_reactive_power_kvar # :nodoc:

        ##
        # PowerDistribution class initialize all power_distribution attributes:
        # +:under_voltage_hours+ , +:over_voltage_hours+, +:nominal_capacity+, +:reactance_resistance_ratio+
        ##
        # [parameters:]
        # +hash+ - _Hash_ - A hash which may contain a deserialized power_distribution.
        ##
        def initialize(hash = {})
          hash.delete_if { |k, v| v.nil? }
          hash = defaults.merge(hash)

          @under_voltage_hours = hash[:under_voltage_hours]
          @over_voltage_hours = hash[:over_voltage_hours]
          @nominal_capacity = hash[:nominal_capacity]
          @reactance_resistance_ratio = hash[:reactance_resistance_ratio]
          @nominal_voltage = hash[:nominal_voltage] # in V
          @max_power_kw = hash[:max_power_kw]
          @max_reactive_power_kvar = hash[:max_reactive_power_kvar]
          # initialize class variables @@validator and @@schema
          @@validator ||= Validator.new
          @@schema ||= @@validator.schema
        end

        ##
        # Assigns default values if attribute values do not exist.
        ##
        def defaults
          hash = {}
          hash[:under_voltage_hours] = nil
          hash[:over_voltage_hours] = nil
          hash[:nominal_capacity] = nil
          hash[:reactance_resistance_ratio] = nil
          hash[:nominal_voltage] = nil
          hash[:max_power_kw] = nil
          hash[:max_reactive_power_kvar] = nil

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
          result[:under_voltage_hours] = @under_voltage_hours if @under_voltage_hours
          result[:over_voltage_hours] = @over_voltage_hours if @over_voltage_hours
          result[:nominal_capacity] = @nominal_capacity if @nominal_capacity
          result[:reactance_resistance_ratio] = @reactance_resistance_ratio if @reactance_resistance_ratio
          result[:nominal_voltage] = @nominal_voltage if @nominal_voltage
          result[:max_power_kw] = @max_power_kw if @max_power_kw
          result[:max_reactive_power_kvar] = @max_reactive_power_kvar if @max_reactive_power_kvar

          # validate power_distribution properties against schema
          if @@validator.validate(@@schema[:definitions][:PowerDistribution][:properties], result).any?
            raise "power_distribution properties does not match schema: #{@@validator.validate(@@schema[:definitions][:PowerDistribution][:properties], result)}"
          end

          return result
        end

        ##
        # Merges muliple power distribution results together.
        ##
        # +new_costs+ - _Array_ - An array of ConstructionCost objects.
        def merge_power_distribution
          # method to be developed for any attributes to be aggregated or merged
        end
      end
    end
  end
end
