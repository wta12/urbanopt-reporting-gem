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

require_relative 'end_uses'
require_relative 'end_use'
require_relative 'date'
require_relative 'validator'

require 'json'
require 'json-schema'

module URBANopt
  module Reporting
    module DefaultReports
      ##
      # ReportingPeriod includes all the results of a specific reporting period.
      ##
      class ReportingPeriod
        attr_accessor :id, :name, :multiplier, :start_date, :end_date, :month, :day_of_month, :year, :total_site_energy_kwh, :total_source_energy_kwh, :site_EUI_kwh_per_m2, :site_EUI_kbtu_per_ft2, :source_EUI_kwh_per_m2, :source_EUI_kbtu_per_ft2,
                      :net_site_energy_kwh, :net_source_energy_kwh, :total_utility_cost_dollar, :net_utility_cost_dollar, :utility_costs_dollar, :electricity_kwh, :natural_gas_kwh, :propane_kwh, :fuel_oil_kwh, :other_fuels_kwh, :district_cooling_kwh,
                      :district_heating_kwh, :water_qbft, :electricity_produced_kwh, :end_uses, :energy_production_kwh, :photovoltaic,
                      :fuel_type, :total_cost_dollar, :usage_cost_dollar, :demand_cost_dollar, :comfort_result, :time_setpoint_not_met_during_occupied_cooling,
                      :time_setpoint_not_met_during_occupied_heating, :time_setpoint_not_met_during_occupied_hours, :hours_out_of_comfort_bounds_PMV, :hours_out_of_comfort_bounds_PPD,
                      :emissions, :future_annual_emissions_mt, :future_hourly_emissions_mt, :historical_annual_emissions_mt, :historical_hourly_emissions_mt,
                      :future_annual_emissions_intensity_kg_per_ft2, :future_hourly_emissions_intensity_kg_per_ft2, :historical_annual_emissions_intensity_kg_per_ft2, :historical_hourly_emissions_intensity_kg_per_ft2  #:nodoc:

        # ReportingPeriod class initializes the reporting period attributes:
        # +:id+ , +:name+ , +:multiplier+ , +:start_date+ , +:end_date+ , +:month+ , +:day_of_month+ , +:year+ , +:total_site_energy_kwh+ , +:total_source_energy_kwh+ , +:site_EUI_kwh_per_m2+, +:site_EUI_kbtu_per_ft2+, +:source_EUI_kwh_per_m2+, +:source_EUI_kbtu_per_ft2+,
        # +:net_site_energy_kwh+ , +:net_source_energy_kwh+ , +:total_utility_cost_dollar , +:net_utility_cost_dollar+ , +:utility_costs_dollar+ , +:electricity_kwh+ , +:natural_gas_kwh+ , +:propane_kwh+ , +:fuel_oil_kwh+ , +:other_fuels_kwh+ , +:district_cooling_kwh+ ,
        # +:district_heating_kwh+ , +:water_qbft+ , +:electricity_produced_kwh+ , +:end_uses+ , +:energy_production_kwh+ , +:photovoltaic_kwh+ ,
        # +:fuel_type+ , +:total_cost_dollar+ , +:usage_cost_dollar+ , +:demand_cost_dollar+ , +:comfort_result+ , +:time_setpoint_not_met_during_occupied_cooling+ ,
        # +:time_setpoint_not_met_during_occupied_heating+ , +:time_setpoint_not_met_during_occupied_hours+ , +:hours_out_of_comfort_bounds_PMV , +:hours_out_of_comfort_bounds_PPD ,
        # +:emissions, +:future_annual_emissions_mt, +:future_hourly_emissions_mt, +:historical_annual_emissions_mt, +:historical_hourly_emissions_mt,
        # +:future_annual_emissions_intensity_kg_per_ft2, +:future_hourly_emissions_intensity_kg_per_ft2, +:historical_annual_emissions_intensity_kg_per_ft2, +:historical_hourly_emissions_intensity_kg_per_ft2 
        ##
        # [parameters:]
        # +hash+ - _Hash_ - A hash which may contain a deserialized reporting_period.
        ##
        def initialize(hash = {})
          hash.delete_if { |k, v| v.nil? }
          hash = defaults.merge(hash)

          @id = hash[:id]
          @name = hash[:name]
          @multiplier = hash[:multiplier]
          @start_date = Date.new(hash[:start_date])
          @end_date = Date.new(hash[:end_date])

          @total_site_energy_kwh = hash[:total_site_energy_kwh]
          @total_source_energy_kwh = hash[:total_source_energy_kwh]
          @site_EUI_kwh_per_m2 = hash[:site_EUI_kwh_per_m2]
          @site_EUI_kbtu_per_ft2 = hash[:site_EUI_kbtu_per_ft2]
          @source_EUI_kwh_per_m2 = hash[:source_EUI_kwh_per_m2]
          @source_EUI_kbtu_per_ft2 = hash[:source_EUI_kbtu_per_ft2]
          @net_site_energy_kwh = hash[:net_site_energy_kwh]
          @net_source_energy_kwh = hash[:net_source_energy_kwh]
          @net_utility_cost_dollar = hash[:net_utility_cost_dollar]
          @total_utility_cost_dollar = hash[:total_utility_cost_dollar]
          @electricity_kwh = hash[:electricity_kwh]
          @natural_gas_kwh = hash[:natural_gas_kwh]
          @propane_kwh = hash[:propane_kwh]
          @fuel_oil_kwh = hash[:fuel_oil_kwh]
          @other_fuels_kwh = hash[:other_fuels_kwh]
          @district_cooling_kwh = hash[:district_cooling_kwh]
          @district_heating_kwh = hash[:district_heating_kwh]
          @water_qbft = hash[:water_qbft]
          @electricity_produced_kwh = hash[:electricity_produced_kwh]
          @end_uses = EndUses.new(hash[:end_uses])

          @energy_production_kwh = hash[:energy_production_kwh]

          @utility_costs_dollar = hash[:utility_costs_dollar]

          @comfort_result = hash[:comfort_result]

          @emissions = hash[:emissions]

          # initialize class variables @@validator and @@schema
          @@validator ||= Validator.new
          @@schema ||= @@validator.schema
        end

        ##
        # Assigns default values if values do not exist.
        ##
        def defaults
          hash = {}

          hash[:id] = nil
          hash[:name] = nil
          hash[:multiplier] = nil
          hash[:start_date] = Date.new.to_hash
          hash[:end_date] = Date.new.to_hash

          hash[:total_site_energy_kwh] = nil
          hash[:total_source_energy_kwh] = nil
          hash[:site_EUI_kwh_per_m2] = nil
          hash[:site_EUI_kbtu_per_ft2] = nil
          hash[:source_EUI_kwh_per_m2] = nil
          hash[:source_EUI_kbtu_per_ft2] = nil
          hash[:net_site_energy_kwh] = nil
          hash[:net_source_energy_kwh] = nil
          hash[:net_utility_cost_dollar] = nil
          hash[:total_utility_cost_dollar] = nil
          hash[:electricity_kwh] = nil
          hash[:natural_gas_kwh] = nil
          hash[:propane_kwh] = nil
          hash[:fuel_oil_kwh] = nil
          hash[:other_fuels_kwh] = nil
          hash[:district_cooling_kwh] = nil
          hash[:district_heating_kwh] = nil

          hash[:electricity_produced_kwh] = nil
          hash[:end_uses] = EndUses.new.to_hash
          hash[:energy_production_kwh] = { electricity_produced: { photovoltaic: nil } }
          hash[:utility_costs_dollar] = [{ fuel_type: nil, total_cost_dollar: nil, usage_cost_dollar: nil, demand_cost_dollar: nil }]
          hash[:comfort_result] = { time_setpoint_not_met_during_occupied_cooling: nil, time_setpoint_not_met_during_occupied_heating: nil,
                                    time_setpoint_not_met_during_occupied_hours: nil, hours_out_of_comfort_bounds_PMV: nil, hours_out_of_comfort_bounds_PPD: nil }
          hash[:emissions] = { future_annual_emissions_mt: nil, future_hourly_emissions_mt: nil, historical_annual_emissions_mt: nil, historical_hourly_emissions_mt: nil,
                                future_annual_emissions_intensity_kg_per_ft2: nil, future_hourly_emissions_kg_per_ft2: nil, historical_annual_emissions_kg_per_ft2: nil, historical_hourly_emissions_kg_per_ft2: nil }

          return hash
        end

        ##
        # Converts to a Hash equivalent for JSON serialization.
        ##
        # - Exclude attributes with nil values.
        # - Validate reporting_period hash properties against schema.
        #
        def to_hash
          result = {}

          result[:id] = @id if @id
          result[:name] = @name if @name
          result[:multiplier] = @multiplier if @multiplier
          result[:start_date] = @start_date.to_hash if @start_date
          result[:end_date] = @end_date.to_hash if @end_date
          result[:total_site_energy_kwh] = @total_site_energy_kwh if @total_site_energy_kwh
          result[:total_source_energy_kwh] = @total_source_energy_kwh if @total_source_energy_kwh
          result[:site_EUI_kwh_per_m2] = @site_EUI_kwh_per_m2 if @site_EUI_kwh_per_m2
          result[:site_EUI_kbtu_per_ft2] = @site_EUI_kbtu_per_ft2 if @site_EUI_kbtu_per_ft2
          result[:source_EUI_kwh_per_m2] = @source_EUI_kwh_per_m2 if @source_EUI_kwh_per_m2
          result[:source_EUI_kbtu_per_ft2] = @source_EUI_kbtu_per_ft2 if @source_EUI_kbtu_per_ft2
          result[:net_site_energy_kwh] = @net_site_energy_kwh if @net_site_energy_kwh
          result[:net_source_energy_kwh] = @net_source_energy_kwh if @net_source_energy_kwh
          result[:net_utility_cost_dollar] = @net_utility_cost_dollar if @net_utility_cost_dollar
          result[:total_utility_cost_dollar] = @total_utility_cost_dollar if @total_utility_cost_dollar
          result[:electricity_kwh] = @electricity_kwh if @electricity_kwh
          result[:natural_gas_kwh] = @natural_gas_kwh if @natural_gas_kwh
          result[:propane_kwh] = @propane_kwh if @propane_kwh
          result[:fuel_oil_kwh] = @fuel_oil_kwh if @fuel_oil_kwh
          result[:other_fuels_kwh] = @other_fuels_kwh if @other_fuels_kwh
          result[:district_cooling_kwh] = @district_cooling_kwh if @district_cooling_kwh
          result[:district_heating_kwh] = @district_heating_kwh if @district_heating_kwh
          result[:water_qbft] = @water_qbft if @water_qbft
          result[:electricity_produced_kwh] = @electricity_produced_kwh if @electricity_produced_kwh
          result[:end_uses] = @end_uses.to_hash if @end_uses

          energy_production_kwh_hash = @energy_production_kwh if @energy_production_kwh
          energy_production_kwh_hash.delete_if { |k, v| v.nil? }
          energy_production_kwh_hash.each do |eph|
            eph.delete_if { |k, v| v.nil? }
          end

          result[:energy_production_kwh] = energy_production_kwh_hash if @energy_production_kwh

          if @utility_costs_dollar.any?
            result[:utility_costs_dollar] = @utility_costs_dollar
            @utility_costs_dollar.each do |uc|
              uc&.delete_if { |k, v| v.nil? }
            end
          end

          comfort_result_hash = @comfort_result if @comfort_result
          comfort_result_hash.delete_if { |k, v| v.nil? }
          result[:comfort_result] = comfort_result_hash if @comfort_result

          emissions_hash = @emissions if @emissions
          emissions_hash.delete_if { |k, v| v.nil? }
          result[:emissions] = emissions_hash if @emissions

          # validates +reporting_period+ properties against schema for reporting period.
          if @@validator.validate(@@schema[:definitions][:ReportingPeriod][:properties], result).any?
            raise "feature_report properties does not match schema: #{@@validator.validate(@@schema[:definitions][:ReportingPeriod][:properties], result)}"
          end

          return result
        end

        ##
        # Adds up +existing_value+ and +new_values+ if not nill.
        ##
        # [parameter:]
        # +existing_value+ - _Float_ - A value corresponding to a ReportingPeriod attribute.
        ##
        # +new_value+ - _Float_ - A value corresponding to a ReportingPeriod attribute.
        ##
        def self.add_values(existing_value, new_value)
          if existing_value && new_value
            existing_value += new_value
          elsif new_value
            existing_value = new_value
          end
          return existing_value
        end

        ##
        # Merges an +existing_period+ with a +new_period+ if not nil.
        ##
        # [Parameters:]
        # +existing_period+ - _ReportingPeriod_ - An object of ReportingPeriod class.
        ##
        # +new_period+ - _ReportingPeriod_ - An object of ReportingPeriod class.
        ##
        def self.merge_reporting_period(existing_period, new_period)
          # modify the existing_period by summing up the results
          existing_period.total_site_energy_kwh = add_values(existing_period.total_site_energy_kwh, new_period.total_site_energy_kwh)
          existing_period.total_source_energy_kwh = add_values(existing_period.total_source_energy_kwh, new_period.total_source_energy_kwh)
          existing_period.net_source_energy_kwh = add_values(existing_period.net_source_energy_kwh, new_period.net_source_energy_kwh)
          existing_period.net_utility_cost_dollar = add_values(existing_period.net_utility_cost_dollar, new_period.net_utility_cost_dollar)
          existing_period.total_utility_cost_dollar = add_values(existing_period.total_utility_cost_dollar, new_period.total_utility_cost_dollar)
          existing_period.electricity_kwh = add_values(existing_period.electricity_kwh, new_period.electricity_kwh)
          existing_period.natural_gas_kwh = add_values(existing_period.natural_gas_kwh, new_period.natural_gas_kwh)
          existing_period.propane_kwh = add_values(existing_period.propane_kwh, new_period.propane_kwh)
          existing_period.fuel_oil_kwh = add_values(existing_period.fuel_oil_kwh, new_period.fuel_oil_kwh)
          existing_period.other_fuels_kwh = add_values(existing_period.other_fuels_kwh, new_period.other_fuels_kwh)
          existing_period.district_cooling_kwh = add_values(existing_period.district_cooling_kwh, new_period.district_cooling_kwh)
          existing_period.district_heating_kwh = add_values(existing_period.district_heating_kwh, new_period.district_heating_kwh)
          existing_period.water_qbft = add_values(existing_period.water_qbft, new_period.water_qbft)
          existing_period.electricity_produced_kwh = add_values(existing_period.electricity_produced_kwh, new_period.electricity_produced_kwh)

          # merge end uses
          new_end_uses = new_period.end_uses
          existing_period.end_uses&.merge_end_uses!(new_end_uses)

          if existing_period.energy_production_kwh && existing_period.energy_production_kwh[:electricity_produced_kwh]
            existing_period.energy_production_kwh[:electricity_produced_kwh][:photovoltaic_kwh] = add_values(existing_period.energy_production_kwh[:electricity_produced][:photovoltaic], new_period.energy_production_kwh[:electricity_produced_kwh][:photovoltaic_kwh])
          end

          existing_period.utility_costs_dollar&.each_with_index do |item, i|
            existing_period.utility_costs_dollar[i][:fuel_type] = existing_period.utility_costs_dollar[i][:fuel_type]
            existing_period.utility_costs_dollar[i][:total_cost] = add_values(existing_period.utility_costs_dollar[i][:total_cost], new_period.utility_costs_dollar[i][:total_cost])
            existing_period.utility_costs_dollar[i][:usage_cost] = add_values(existing_period.utility_costs_dollar[i][:usage_cost], new_period.utility_costs_dollar[i][:usage_cost])
            existing_period.utility_costs_dollar[i][:demand_cost] = add_values(existing_period.utility_costs_dollar[i][:demand_cost], new_period.utility_costs_dollar[i][:demand_cost])
          end

          if existing_period.comfort_result
            existing_period.comfort_result[:time_setpoint_not_met_during_occupied_cooling] = add_values(existing_period.comfort_result[:time_setpoint_not_met_during_occupied_cooling], new_period.comfort_result[:time_setpoint_not_met_during_occupied_cooling])
            existing_period.comfort_result[:time_setpoint_not_met_during_occupied_heating] = add_values(existing_period.comfort_result[:time_setpoint_not_met_during_occupied_heating], new_period.comfort_result[:time_setpoint_not_met_during_occupied_heating])
            existing_period.comfort_result[:time_setpoint_not_met_during_occupied_hours] = add_values(existing_period.comfort_result[:time_setpoint_not_met_during_occupied_hours], new_period.comfort_result[:time_setpoint_not_met_during_occupied_hours])
            existing_period.comfort_result[:hours_out_of_comfort_bounds_PMV] = add_values(existing_period.comfort_result[:hours_out_of_comfort_bounds_PMV], new_period.comfort_result[:hours_out_of_comfort_bounds_PMV])
            existing_period.comfort_result[:hours_out_of_comfort_bounds_PPD] = add_values(existing_period.comfort_result[:hours_out_of_comfort_bounds_PPD], new_period.comfort_result[:hours_out_of_comfort_bounds_PPD])
          end

          if existing_period.emissions
            existing_period.emissions[:future_annual_emissions_mt] = add_values(existing_period.emissions[:future_annual_emissions_mt], new_period.emissions[:future_annual_emissions_mt])
            existing_period.emissions[:future_hourly_emissions_mt] = add_values(existing_period.emissions[:future_hourly_emissions_mt], new_period.emissions[:future_hourly_emissions_mt])
            existing_period.emissions[:historical_annual_emissions_mt] = add_values(existing_period.emissions[:historical_annual_emissions_mt], new_period.emissions[:historical_annual_emissions_mt])
            existing_period.emissions[:historical_hourly_emissions_mt] = add_values(existing_period.emissions[:historical_hourly_emissions_mt], new_period.emissions[:historical_hourly_emissions_mt])

            existing_period.emissions[:future_annual_emissions_intensity_kg_per_ft2] = add_values(existing_period.emissions[:future_annual_emissions_intensity_kg_per_ft2], new_period.emissions[:future_annual_emissions_intensity_kg_per_ft2])
            existing_period.emissions[:future_hourly_emissions_intensity_kg_per_ft2] = add_values(existing_period.emissions[:future_hourly_emissions_intensity_kg_per_ft2], new_period.emissions[:future_hourly_emissions_intensity_kg_per_ft2])
            existing_period.emissions[:historical_annual_emissions_intensity_kg_per_ft2] = add_values(existing_period.emissions[:historical_annual_emissions_intensity_kg_per_ft2], new_period.emissions[:historical_annual_emissions_intensity_kg_per_ft2])
            existing_period.emissions[:historical_hourly_emissions_intensity_kg_per_ft2] = add_values(existing_period.emissions[:historical_hourly_emissions_intensity_kg_per_ft2], new_period.emissions[:historical_hourly_emissions_intensity_kg_per_ft2])
          end

          return existing_period
        end

        ##
        # Merges multiple reporting periods together.
        # - If +existing_periods+ and +new_periods+ ids are equal,
        # modify the existing_periods by merging the new periods results
        # - If existing periods are empty, initialize with new_periods.
        # - Raise an error if the existing periods are not identical with new periods (cannot have different reporting period ids).
        ##
        # [parameters:]
        ##
        # +existing_periods+ - _Array_ - An array of ReportingPeriod objects.
        ##
        # +new_periods+ - _Array_ - An array of ReportingPeriod objects.
        ##
        def self.merge_reporting_periods(existing_periods, new_periods)
          id_list_existing = []
          id_list_new = []
          id_list_existing = existing_periods.collect(&:id)
          id_list_new = new_periods.collect(&:id)

          if id_list_existing == id_list_new

            existing_periods.each_index do |index|
              # if +existing_periods+ and +new_periods+ ids are equal,
              # modify the existing_periods by merging the new periods results
              existing_periods[index] = merge_reporting_period(existing_periods[index], new_periods[index])
            end

          elsif existing_periods.empty?

            # if existing periods are empty, initialize with new_periods
            # the = operator would link existing_periods and new_periods to the same object in memory
            # we want to initialize with a deep clone of new_periods
            existing_periods = Marshal.load(Marshal.dump(new_periods))

          else
            # raise an error if the existing periods are not identical with new periods (cannot have different reporting period ids)
            raise 'cannot merge different reporting periods'

          end

          return existing_periods
        end
      end
    end
  end
end
