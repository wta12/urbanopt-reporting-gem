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
require 'json'

module URBANopt
  module Reporting
    module DefaultReports
      ##
      # Program includes all building program related information.
      ##
      class Program
        attr_accessor :site_area_sqft, :floor_area_sqft, :conditioned_area_sqft, :unconditioned_area_sqft, :footprint_area_sqft, :maximum_roof_height_ft,
                      :maximum_number_of_stories, :maximum_number_of_stories_above_ground, :parking_area_sqft, :number_of_parking_spaces,
                      :number_of_parking_spaces_charging, :parking_footprint_area_sqft, :maximum_parking_height_ft, :maximum_number_of_parking_stories,
                      :maximum_number_of_parking_stories_above_ground, :number_of_residential_units, :building_types, :building_type, :maximum_occupancy,
                      :area_sqft, :window_area_sqft, :north_window_area_sqft, :south_window_area_sqft, :east_window_area_sqft, :west_window_area_sqft, :wall_area_sqft, :roof_area_sqft, :equipment_roof_area_sqft,
                      :photovoltaic_roof_area_sqft, :available_roof_area_sqft, :total_roof_area_sqft, :orientation_deg, :aspect_ratio, :total_construction_cost_dollar # :nodoc:

        # Program class initialize building program attributes: +:site_area_sqft+ , +:floor_area_sqft+ , +:conditioned_area_sqft+ , +:unconditioned_area_sqft+ ,
        # +:footprint_area_sqft+ , +:maximum_roof_height_ft, +:maximum_number_of_stories+ , +:maximum_number_of_stories_above_ground+ , +:parking_area_sqft+ ,
        # +:number_of_parking_spaces+ , +:number_of_parking_spaces_charging+ , +:parking_footprint_area_sqft+ , +:maximum_parking_height_ft+ , +:maximum_number_of_parking_stories+ ,
        # +:maximum_number_of_parking_stories_above_ground+ , +:number_of_residential_units+ , +:building_types+ , +:building_type+ , +:maximum_occupancy+ ,
        # +:area_sqft+ , +:window_area_sqft+ , +:north_window_area_sqft+ , +:south_window_area_sqft+ , +:east_window_area_sqft+ , +:west_window_area_sqft+ , +:wall_area_sqft+ , +:roof_area_sqft+ ,
        # +:equipment_roof_area_sqft+ , +:photovoltaic_roof_area_sqft+ , +:available_roof_area_sqft+ , +:total_roof_area_sqft+ , +:orientation_deg+ , +:aspect_ratio+
        ##
        # [parameters:]
        # +hash+ - _Hash_ - A hash which may contain a deserialized program.
        ##
        def initialize(hash = {})
          hash.delete_if { |k, v| v.nil? }
          hash = defaults.merge(hash)

          @site_area_sqft = hash[:site_area_sqft]
          @floor_area_sqft = hash[:floor_area_sqft]
          @conditioned_area_sqft = hash[:conditioned_area_sqft]
          @unconditioned_area_sqft = hash[:unconditioned_area_sqft]
          @footprint_area_sqft = hash[:footprint_area_sqft]
          @maximum_roof_height_ft = hash[:maximum_roof_height_ft]
          @maximum_number_of_stories = hash[:maximum_number_of_stories]
          @maximum_number_of_stories_above_ground = hash[:maximum_number_of_stories_above_ground]
          @parking_area_sqft = hash[:parking_area_sqft]
          @number_of_parking_spaces = hash[:number_of_parking_spaces]
          @number_of_parking_spaces_charging = hash[:number_of_parking_spaces_charging]
          @parking_footprint_area_sqft = hash[:parking_footprint_area_sqft]
          @maximum_parking_height_ft = hash[:maximum_parking_height_ft]
          @maximum_number_of_parking_stories = hash[:maximum_number_of_parking_stories]
          @maximum_number_of_parking_stories_above_ground = hash[:maximum_number_of_parking_stories_above_ground]
          @number_of_residential_units = hash[:number_of_residential_units]
          @building_types = hash[:building_types]
          @window_area_sqft = hash[:window_area_sqft]
          @wall_area_sqft = hash[:wall_area_sqft]
          @roof_area_sqft = hash[:roof_area_sqft]
          @orientation_deg = hash[:orientation_deg]
          @aspect_ratio = hash[:aspect_ratio]
          @total_construction_cost_dollar = hash[:total_construction_cost_dollar]

          # initialize class variables @@validator and @@schema
          @@validator ||= Validator.new
          @@schema ||= @@validator.schema
        end

        ##
        # Assigns default values if values do not exist.
        ##
        def defaults
          hash = {}
          hash[:site_area_sqft] = nil
          hash[:floor_area_sqft] = nil
          hash[:conditioned_area_sqft] = nil
          hash[:unconditioned_area_sqft] = nil
          hash[:footprint_area_sqft] = nil
          hash[:maximum_roof_height_ft] = nil
          hash[:maximum_number_of_stories] = nil
          hash[:maximum_number_of_stories_above_ground] = nil
          hash[:parking_area_sqft] = nil
          hash[:number_of_parking_spaces] = nil
          hash[:number_of_parking_spaces_charging] = nil
          hash[:parking_footprint_area_sqft] = nil
          hash[:maximum_parking_height_ft] = nil
          hash[:maximum_number_of_parking_stories] = nil
          hash[:maximum_number_of_parking_stories_above_ground] = nil
          hash[:number_of_residential_units] = nil
          hash[:building_types] = [{ building_type: nil, maximum_occupancy: nil, floor_area_sqft: nil }]
          hash[:window_area_sqft] = { north_window_area_sqft: nil, south_window_area_sqft: nil, east_window_area_sqft: nil, west_window_area_sqft: nil, total_window_area_sqft: nil }
          hash[:wall_area_sqft] = { north_wall_area_sqft: nil, south_wall_area_sqft: nil, east_wall_area_sqft: nil, west_wall_area_sqft: nil, total_wall_area_sqft: nil }
          hash[:roof_area_sqft] = { equipment_roof_area_sqft: nil, photovoltaic_roof_area_sqft: nil, available_roof_area_sqft: nil, total_roof_area_sqft: nil }
          hash[:orientation_deg] = nil
          hash[:aspect_ratio] = nil
          hash[:total_construction_cost_dollar] = nil
          return hash
        end

        ##
        # Convert to a Hash equivalent for JSON serialization.
        ##
        # - Exclude attributes with nil values.
        # - Validate program hash properties against schema.
        ##
        def to_hash
          result = {}
          result[:site_area_sqft] = @site_area_sqft if @site_area_sqft
          result[:floor_area_sqft] = @floor_area_sqft if @floor_area_sqft
          result[:conditioned_area_sqft] = @conditioned_area_sqft if @conditioned_area_sqft
          result[:unconditioned_area_sqft] = @unconditioned_area_sqft if @unconditioned_area_sqft
          result[:footprint_area_sqft] = @footprint_area_sqft if @footprint_area_sqft
          result[:maximum_roof_height_ft] = @maximum_roof_height_ft if @maximum_roof_height_ft
          result[:maximum_number_of_stories] = @maximum_number_of_stories if @maximum_number_of_stories
          result[:maximum_number_of_stories_above_ground] = @maximum_number_of_stories_above_ground if @maximum_number_of_stories_above_ground
          result[:parking_area_sqft] = @parking_area_sqft if @parking_area_sqft
          result[:number_of_parking_spaces] = @number_of_parking_spaces if @number_of_parking_spaces
          result[:number_of_parking_spaces_charging] = @number_of_parking_spaces_charging if @number_of_parking_spaces_charging
          result[:parking_footprint_area_sqft] = @parking_footprint_area_sqft if @parking_footprint_area_sqft
          result[:maximum_parking_height_ft] = @maximum_parking_height_ft if @maximum_parking_height_ft
          result[:maximum_number_of_parking_stories] = @maximum_number_of_parking_stories if @maximum_number_of_parking_stories
          result[:maximum_number_of_parking_stories_above_ground] = @maximum_number_of_parking_stories_above_ground if @maximum_number_of_parking_stories_above_ground
          result[:number_of_residential_units] = @number_of_residential_units if @number_of_residential_units

          if @building_types.any?
            result[:building_types] = @building_types
            @building_types.each do |bt|
              bt&.delete_if { |k, v| v.nil? }
            end
          end

          # result[:window_area_sqft] = @window_area_sqft if @window_area_sqft
          window_area_sqft_hash = @window_area_sqft if @window_area_sqft
          window_area_sqft_hash.delete_if { |k, v| v.nil? }
          result[:window_area_sqft] = window_area_sqft_hash if @window_area_sqft

          # result[:wall_area_sqft] = @wall_area_sqft if @wall_area_sqft
          wall_area_sqft_hash = @wall_area_sqft if @wall_area_sqft
          wall_area_sqft_hash.delete_if { |k, v| v.nil? }
          result[:wall_area_sqft] = wall_area_sqft_hash if @wall_area_sqft

          # result[:roof_area_sqft] = @roof_area_sqft if @roof_area_sqft
          roof_area_sqft_hash = @roof_area_sqft if @roof_area_sqft
          roof_area_sqft_hash.delete_if { |k, v| v.nil? }
          result[:roof_area_sqft] = roof_area_sqft_hash if @roof_area_sqft

          result[:orientation_deg] = @orientation_deg if @orientation_deg
          result[:aspect_ratio] = @aspect_ratio if @aspect_ratio

          result[:total_construction_cost_dollar] = @total_construction_cost_dollar if @total_construction_cost_dollar

          # validate program properties against schema
          if @@validator.validate(@@schema[:definitions][:Program][:properties], result).any?
            raise "program properties does not match schema: #{@@validator.validate(@@schema[:definitions][:Program][:properties], result)}"
          end

          return result
        end

        ##
        # Return the maximum value from +existing_value+ and +new_value+.
        ##
        # [parameters:]
        # +existing_value+ - _Float_ - A value corresponding to a Program attribute.
        ##
        # +new_value+ - _Float_ - A value corresponding to a Program attribute.
        ##
        def max_value(existing_value, new_value)
          if existing_value && new_value
            [existing_value, new_value].max
          elsif new_value
            existing_value = new_value
          end
          return existing_value
        end

        ##
        # Adds up +existing_value+ and +new_values+ if not nill.
        ##
        # [parameters:]
        # +existing_value+ - _Float_ - A value corresponding to a Program attribute.
        ##
        # +new_value+ - _Float_ - A value corresponding to a Program attribute.
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
        # Merges program objects to each other by summing up values or taking the maximum value of the attributes.
        ##
        # [parameters:]
        # +other+ - _Program_ - An object of Program class.
        ##
        def add_program(other)
          @site_area_sqft = add_values(@site_area_sqft, other.site_area_sqft)

          @floor_area_sqft = add_values(@floor_area_sqft, other.floor_area_sqft)
          @conditioned_area_sqft = add_values(@conditioned_area_sqft, other.conditioned_area_sqft)
          @unconditioned_area_sqft = add_values(@unconditioned_area_sqft, other.unconditioned_area_sqft)
          @footprint_area_sqft = add_values(@footprint_area_sqft, other.footprint_area_sqft)
          @maximum_roof_height_ft = max_value(@maximum_roof_height_ft, other.maximum_roof_height_ft)
          @maximum_number_of_stories = max_value(@maximum_number_of_stories, other.maximum_number_of_stories)
          @maximum_number_of_stories_above_ground = max_value(@maximum_number_of_stories_above_ground, other.maximum_number_of_stories_above_ground)
          @parking_area_sqft = add_values(@parking_area_sqft, other.parking_area_sqft)
          @number_of_parking_spaces = add_values(@number_of_parking_spaces, other.number_of_parking_spaces)
          @number_of_parking_spaces_charging = add_values(@number_of_parking_spaces_charging, other.number_of_parking_spaces_charging)
          @parking_footprint_area_sqft = add_values(@parkig_footprint_area_sqft, other.parking_footprint_area_sqft)
          @maximum_parking_height_ft = max_value(@maximum_parking_height_ft, other.maximum_parking_height_ft)
          @maximum_number_of_parking_stories = max_value(@maximum_number_of_parking_stories, other.maximum_number_of_parking_stories)
          @maximum_number_of_parking_stories_above_ground = max_value(maximum_number_of_parking_stories_above_ground, other.maximum_number_of_parking_stories_above_ground)
          @number_of_residential_units = add_values(@number_of_residential_units, other.number_of_residential_units)
          @total_construction_cost_dollar = add_values(@total_construction_cost_dollar, other.total_construction_cost_dollar)

          @building_types = other.building_types

          @window_area_sqft[:north_window_area_sqft] = add_values(@window_area_sqft[:north_window_area_sqft], other.window_area_sqft[:north_window_area_sqft])
          @window_area_sqft[:south_window_area_sqft] = add_values(@window_area_sqft[:south_window_area_sqft], other.window_area_sqft[:south_window_area_sqft])
          @window_area_sqft[:east_window_area_sqft] = add_values(@window_area_sqft[:east_window_area_sqft], other.window_area_sqft[:east_window_area_sqft])
          @window_area_sqft[:west_window_area_sqft] = add_values(@window_area_sqft[:west_window_area_sqft], other.window_area_sqft[:west_window_area_sqft])
          @window_area_sqft[:total_window_area_sqft] =  add_values(@window_area_sqft[:total_window_area_sqft], other.window_area_sqft[:total_window_area_sqft])

          @wall_area_sqft[:north_wall_area_sqft] = add_values(@wall_area_sqft[:north_wall_area_sqft], other.wall_area_sqft[:north_wall_area_sqft])
          @wall_area_sqft[:south_wall_area_sqft] = add_values(@wall_area_sqft[:south_wall_area_sqft], other.wall_area_sqft[:south_wall_area_sqft])
          @wall_area_sqft[:east_wall_area_sqft] = add_values(@wall_area_sqft[:east_wall_area_sqft], other.wall_area_sqft[:east_wall_area_sqft])
          @wall_area_sqft[:west_wall_area_sqft] = add_values(@wall_area_sqft[:west_wall_area_sqft], other.wall_area_sqft[:west_wall_area_sqft])
          @wall_area_sqft[:total_wall_area_sqft] = add_values(@wall_area_sqft[:total_wall_area_sqft], other.wall_area_sqft[:total_wall_area_sqft])

          @roof_area_sqft[:equipment_roof_area_sqft] = add_values(@roof_area_sqft[:equipment_roof_area_sqft], other.roof_area_sqft[:equipment_roof_area_sqft])
          @roof_area_sqft[:photovoltaic_roof_area_sqft] = add_values(@roof_area_sqft[:photovoltaic_roof_area_sqft], other.roof_area_sqft[:photovoltaic_roof_area_sqft])
          @roof_area_sqft[:available_roof_area_sqft] = add_values(@roof_area_sqft[:available_roof_area_sqft], other.roof_area_sqft[:available_roof_area_sqft])
          @roof_area_sqft[:total_roof_area_sqft] = add_values(@roof_area_sqft[:total_roof_area_sqft], other.roof_area_sqft[:total_roof_area_sqft])
        end
      end
    end
  end
end
