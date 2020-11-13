# *********************************************************************************
# URBANopt (tm), Copyright (c) 2019-2020, Alliance for Sustainable Energy, LLC, and other
# contributors. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# Redistributions of source code must retain the above copyright notice, this list
# of conditions and the following disclaimer.
#
# Redistributions in binary form must reproduce the above copyright notice, this
# list of conditions and the following disclaimer in the documentation and/or other
# materials provided with the distribution.
#
# Neither the name of the copyright holder nor the names of its contributors may be
# used to endorse or promote products derived from this software without specific
# prior written permission.
#
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

require_relative  'end_use'
require_relative  'validator'
require 'json-schema'

module URBANopt
  module Reporting
    module DefaultReports
      ##
      # Enduses class inlclude results for each fuel type.
      ##
      class EndUses
        attr_accessor :electricity_kwh, :natural_gas_kwh, :propane_kwh, :fuel_oil_kwh, :other_fuels_kwh, :district_cooling_kwh, :district_heating_kwh, :water_qbft # :nodoc:
        ##
        # EndUses class intialize end_uses(fuel type) attributes: +:electricity_kwh+ , +:natural_gas_kwh+ , +:propane_kwh+ , +:fuel_oil_kwh+ , +:other_fuels_kwh+ ,
        # +:district_cooling_kwh+ , +:district_heating_kwh+ , +:water_qbft+
        ##
        # [parameters:]
        # +hash+ - _Hash_ - A hash which may contain a deserialized end_uses.
        ##
        def initialize(hash = {})
          hash.delete_if { |k, v| v.nil? }
          hash = defaults.merge(hash)

          @electricity_kwh = EndUse.new(hash[:electricity_kwh])
          @natural_gas_kwh = EndUse.new(hash[:natural_gas_kwh])
          @propane_kwh = EndUse.new(hash[:propane_kwh])
          @fuel_oil_kwh = EndUse.new(hash[:fuel_oil_kwh])
          @other_fuels_kwh = EndUse.new(hash[:other_fuels_kwh])
          @district_cooling_kwh = EndUse.new(hash[:district_cooling_kwh])
          @district_heating_kwh = EndUse.new(hash[:district_heating_kwh])
          @water_qbft = EndUse.new(hash[:water_qbft])

          # initialize class variables @@validator and @@schema
          @@validator ||= Validator.new
          @@schema ||= @@validator.schema
        end

        ##
        # Converts to a Hash equivalent for JSON serialization.
        ##
        # - Exclude attributes with nil values.
        # - Validate end_uses hash properties against schema.
        ##
        def to_hash
          result = {}

          electricity_kwh_hash = @electricity_kwh.to_hash if @electricity_kwh
          electricity_kwh_hash.delete_if { |k, v| v.nil? }
          result[:electricity_kwh] = electricity_kwh_hash if @electricity_kwh

          natural_gas_kwh_hash = @natural_gas_kwh.to_hash if @natural_gas_kwh
          natural_gas_kwh_hash.delete_if { |k, v| v.nil? }
          result[:natural_gas_kwh] = natural_gas_kwh_hash if @natural_gas_kwh

          propane_kwh_hash = @propane_kwh.to_hash if @propane_kwh
          propane_kwh_hash.delete_if { |k, v| v.nil? }
          result[:propane_kwh] = propane_kwh_hash if @propane_kwh

          fuel_oil_kwh_hash = @fuel_oil_kwh.to_hash if @fuel_oil_kwh
          fuel_oil_kwh_hash.delete_if { |k, v| v.nil? }
          result[:fuel_oil_kwh] = fuel_oil_kwh_hash if @fuel_oil_kwh

          other_fuels_kwh_hash = @other_fuels_kwh.to_hash if @other_fuels_kwh
          other_fuels_kwh_hash.delete_if { |k, v| v.nil? }
          result[:other_fuels_kwh] = other_fuels_kwh_hash if @other_fuels_kwh

          district_cooling_kwh_hash = @district_cooling_kwh.to_hash if @district_cooling_kwh
          district_cooling_kwh_hash.delete_if { |k, v| v.nil? }
          result[:district_cooling_kwh] = district_cooling_kwh_hash if @district_cooling_kwh

          district_heating_kwh_hash = @district_heating_kwh.to_hash if @district_heating_kwh
          district_heating_kwh_hash.delete_if { |k, v| v.nil? }
          result[:district_heating_kwh] = district_heating_kwh_hash if @district_heating_kwh

          water_qbft_hash = @water_qbft.to_hash if @water_qbft
          water_qbft_hash.delete_if { |k, v| v.nil? }
          result[:water_qbft] = water_qbft_hash if @water_qbft

          # validate end_uses properties against schema
          if @@validator.validate(@@schema[:definitions][:EndUses][:properties], result).any?
            raise "end_uses properties does not match schema: #{@@validator.validate(@@schema[:definitions][:EndUses][:properties], result)}"
          end

          return result
        end

        ##
        # Assigns default values if values do not exist.
        ##
        def defaults
          hash = {}
          hash[:electricity_kwh] = EndUse.new.to_hash
          hash[:natural_gas_kwh] = EndUse.new.to_hash
          hash[:propane_kwh] = EndUse.new.to_hash
          hash[:fuel_oil_kwh] = EndUse.new.to_hash
          hash[:other_fuels_kwh] = EndUse.new.to_hash
          hash[:district_cooling_kwh] = EndUse.new.to_hash
          hash[:district_heating_kwh] = EndUse.new.to_hash
          hash[:water_qbft] = EndUse.new.to_hash

          return hash
        end

        ##
        # Aggregates the values of each EndUse attribute.
        ##
        # [Parameters:]
        # +new_end_uses+ - _EndUses_ - An object of EndUses class.
        ##
        def merge_end_uses!(new_end_uses)
          # modify the existing_period by summing up the results ; # sum results only if they exist
          @electricity_kwh.merge_end_use!(new_end_uses.electricity_kwh)
          @natural_gas_kwh.merge_end_use!(new_end_uses.natural_gas_kwh)
          @propane_kwh.merge_end_use!(new_end_uses.propane_kwh)
          @fuel_oil_kwh.merge_end_use!(new_end_uses.fuel_oil_kwh)
          @other_fuels_kwh.merge_end_use!(new_end_uses.other_fuels_kwh)
          @district_cooling_kwh.merge_end_use!(new_end_uses.district_cooling_kwh)
          @district_heating_kwh.merge_end_use!(new_end_uses.district_heating_kwh)
          return self
        end
      end
    end
  end
end
