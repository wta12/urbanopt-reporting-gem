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
require 'json-schema'

module URBANopt
  module Reporting
    module DefaultReports
      ##
      # Enduse class all enduse energy consumption results.
      ##
      class EndUse
        attr_accessor :heating, :cooling, :interior_lighting, :exterior_lighting, :interior_equipment, :exterior_equipment, :electric_vehicles,
                      :fans, :pumps, :heat_rejection, :humidification, :heat_recovery, :water_systems, :refrigeration, :generators # :nodoc:

        ##
        # EndUse class intialize all enduse atributes: +:heating+ , +:cooling+ , +:interior_lighting+ ,
        # +:exterior_lighting+ , +:interior_equipment+ , +:exterior_equipment+ ,
        # +:fans+ , +:pumps+ , +:heat_rejection+ , +:humidification+ , +:heat_recovery+ , +:water_systems+ , +:refrigeration+ , +:generators+
        ##
        # [parameters:]
        # +hash+ - _Hash_ - A hash which may contain a deserialized end_use.
        ##
        def initialize(hash = {})
          hash.delete_if { |k, v| v.nil? }
          hash = defaults.merge(hash)

          @heating = hash[:heating]
          @cooling = hash[:cooling]
          @interior_lighting = hash[:interior_lighting]
          @exterior_lighting = hash[:exterior_lighting]
          @interior_equipment = hash[:interior_equipment]
          @exterior_equipment = hash[:exterior_equipment]
          @electric_vehicles = hash[:electric_vehicles]
          @fans = hash[:fans]
          @pumps = hash[:pumps]
          @heat_rejection = hash[:heat_rejection]
          @humidification = hash[:humidification]
          @heat_recovery = hash[:heat_recovery]
          @water_systems = hash[:water_systems]
          @refrigeration = hash[:refrigeration]
          @generators = hash[:generators]

          # initialize class variables @@validator and @@schema
          @@validator ||= Validator.new
          @@schema ||= @@validator.schema
        end

        ##
        # Assign default values if values does not exist
        ##
        def defaults
          hash = {}

          hash[:heating] = nil
          hash[:cooling] = nil
          hash[:interior_lighting] = nil
          hash[:exterior_lighting] = nil
          hash[:interior_equipment] = nil
          hash[:exterior_equipment] = nil
          hash[:electric_vehicles] = nil
          hash[:fans] = nil
          hash[:pumps] = nil
          hash[:heat_rejection] = nil
          hash[:humidification] = nil
          hash[:heat_recovery] = nil
          hash[:water_systems] = nil
          hash[:refrigeration] = nil
          hash[:generators] = nil

          return hash
        end

        ##
        # Convert to a Hash equivalent for JSON serialization.
        ##
        # - Exclude attributes with nil values.
        # - Validate end_use hash properties against schema.
        ##
        def to_hash
          result = {}

          result[:heating] = @heating
          result[:cooling] = @cooling
          result[:interior_lighting] = @interior_lighting
          result[:exterior_lighting] = @exterior_lighting
          result[:interior_equipment] = @interior_equipment
          result[:exterior_equipment] = @exterior_equipment
          result[:electric_vehicles] = @electric_vehicles
          result[:fans] = @fans
          result[:pumps] = @pumps
          result[:heat_rejection] = @heat_rejection
          result[:humidification] = @humidification
          result[:heat_recovery] = @heat_recovery
          result[:water_systems] = @water_systems
          result[:refrigeration] = @refrigeration
          result[:generators] = @generators

          # validate end_use properties against schema
          if @@validator.validate(@@schema[:definitions][:EndUse][:properties], result).any?
            raise "end_use properties does not match schema: #{@@validator.validate(@@schema[:definitions][:EndUse][:properties], result)}"
          end

          return result
        end

        ##
        # Adds up +existing_value+ and +new_values+ if not nill.
        ##
        # [parameter:]
        # +existing_value+ - _Float_ - A value corresponding to a EndUse attribute.
        ##
        # +new_value+ - _Float_ - A value corresponding to a EndUse attribute.
        ##
        def add_values(existing_value, new_value)
          if existing_value && new_value
            existing_value += new_value
          elsif new_value
            existing_value = new_value
          end
          return existing_value
        end

        ##
        # Aggregate values of each EndUse attribute.
        ##
        # [Parameters:]
        # +other+ - _EndUse_ - An object of EndUse class.
        ##
        def merge_end_use!(other)
          @heating = add_values(@heating, other.heating)
          @cooling = add_values(@cooling, other.cooling)
          @interior_lighting = add_values(@interior_lighting, other.interior_lighting)
          @exterior_lighting = add_values(@exterior_lighting, other.exterior_lighting)
          @interior_equipment = add_values(@interior_equipment, other.interior_equipment)
          @exterior_equipment = add_values(@exterior_equipment, other.exterior_equipment)
          @electric_vehicles = add_values(@electric_vehicles, other.electric_vehicles)
          @fans = add_values(@fans, other.fans)
          @pumps = add_values(@pumps, other.pumps)
          @heat_rejection = add_values(@heat_rejection, other.heat_rejection)
          @humidification = add_values(@humidification, other.humidification)
          @heat_recovery = add_values(@heat_recovery, other.heat_recovery)
          @water_systems = add_values(@water_systems, other.water_systems)
          @refrigeration = add_values(@refrigeration, other.refrigeration)
          @generators = add_values(@generators, other.generators)

          return self
        end
      end
    end
  end
end
