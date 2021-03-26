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

require_relative  'construction_cost'
require_relative  'program'
require_relative  'location'
require_relative  'reporting_period'
require_relative  'timeseries_csv'
require_relative  'distributed_generation'
require_relative  'power_distribution'
require_relative  'validator'
require_relative  'thermal_storage'

require 'json-schema'
require 'json'
require 'fileutils'

module URBANopt
  module Reporting
    module DefaultReports
      ##
      # FeatureReport generates two types of reports in a simulation_dir.
      # The default_feature_reports measure writes a 'default_feature_reports.json' file containing
      # information on all features in the simulation.  It also writes a 'default_feature_reports.csv'
      # containing timeseries data for all features in the simulation.
      # The DefaultPostProcessor reads these feature reports and aggregates them to create a ScenarioReport.
      ##
      class FeatureReport
        attr_accessor :id, :name, :directory_name, :feature_type, :timesteps_per_hour, :simulation_status,
                      :timeseries_csv, :location, :program, :design_parameters, :construction_costs, :reporting_periods, :distributed_generation, :power_distribution, :thermal_storage # :nodoc:
        ##
        # Each FeatureReport object corresponds to a single Feature.
        ##
        # [parameters:]
        # +hash+ - _Hash_ - A hash which may contain a deserialized feature_report.
        ##
        def initialize(hash = {})
          hash.delete_if { |k, v| v.nil? }
          hash = defaults.merge(hash)

          @id = hash[:id]
          @name = hash[:name]
          @directory_name = hash[:directory_name]
          @feature_type = hash[:feature_type]
          @timesteps_per_hour = hash[:timesteps_per_hour]
          @simulation_status = hash[:simulation_status]
          @timeseries_csv = TimeseriesCSV.new(hash[:timeseries_csv])
          @timeseries_csv.run_dir_name(@directory_name)
          @location = Location.new(hash[:location])
          @program = Program.new(hash[:program])
          # design_parameters to add later
          @construction_costs = []
          hash[:construction_costs].each do |cc|
            @constructiion_costs << ConstructionCost.new(cc)
          end

          @reporting_periods = []
          hash[:reporting_periods].each do |rp|
            @reporting_periods << ReportingPeriod.new(rp)
          end

          @distributed_generation = DistributedGeneration.new(hash[:distributed_generation])

          @power_distribution = PowerDistribution.new(hash[:power_distribution])

          @thermal_storage = ThermalStorage.new(hash[:thermal_storage])

          # initialize class variables @@validator and @@schema
          @@validator ||= Validator.new
          @@schema ||= @@validator.schema

          # initialize feature report file name to be saved.
          @file_name = 'default_feature_report'
        end

        ##
        # Assign default values if values does not exist.
        ##
        def defaults
          hash = {}
          hash[:timeseries_csv] = {}
          hash[:location] = {}
          hash[:program] = {}
          hash[:construction_costs] = []
          hash[:reporting_periods] = []
          hash[:distributed_generation] = {}
          hash[:power_distribution] = {}
          hash[:thermal_storage] = {}
          return hash
        end

        ##
        # Return an Array of FeatureReports for the simulation_dir as multiple Features can be simulated together in a single simulation directory.
        ##
        # - Ensure that +simulation_dir+ include only one feature.
        # - Read in the reports written by measure if they exist.
        ##
        # [parameters:]
        # +simulation_dir+ - _SimulationDirOSW_ - A simulation directory from an OSW simulation, must include 'default_feature_reports' measure.
        ##
        def self.from_simulation_dir(simulation_dir)
          result = []

          # simulation dir can include only one feature
          features = simulation_dir.features
          if features.size != 1
            raise 'FeatureReport cannot support multiple features per OSW'
          end

          # read in the reports written by measure
          default_feature_reports_json = nil
          default_feature_reports_csv = nil

          simulation_status = simulation_dir.simulation_status
          if simulation_status == 'Complete' || simulation_status == 'Failed'

            # read in the scenario reports JSON and CSV
            Dir.glob(File.join(simulation_dir.run_dir, '*_default_feature_reports/')).each do |dir|
              scenario_reports_json_path = File.join(dir, 'default_feature_reports.json')
              if File.exist?(scenario_reports_json_path)
                File.open(scenario_reports_json_path, 'r') do |file|
                  default_feature_reports_json = JSON.parse(file.read, symbolize_names: true)
                end
              end
              scenario_reports_csv_path = File.join(dir, 'default_feature_reports.csv')
              if File.exist?(scenario_reports_csv_path)
                default_feature_reports_csv = scenario_reports_csv_path
              end
            end

          end

          # if we loaded the json
          if default_feature_reports_json # && default_feature_reports_json[:feature_reports]
            # default_feature_reports_json.each do |feature_report|
            # result << FeatureReport.new(feature_report)
            # end
            result << FeatureReport.new(default_feature_reports_json) # should we keep it as an array !? or each each report can only include 1 feature

          else
            # we did not find a report
            features.each do |feature|
              hash = {}
              hash[:id] = feature.id
              hash[:name] = feature.name
              hash[:directory_name] = simulation_dir.run_dir
              hash[:simulation_status] = simulation_status
              result << FeatureReport.new(hash)
            end
          end

          # validate feature_report json against schema
          if @@validator.validate(@@schema[:definitions][:FeatureReport][:properties], default_feature_reports_json).any?
            raise "default_feature_report_json properties does not match schema: #{@@validator.validate(@@schema[:definitions][:FeatureReport][:properties], default_feature_reports_json)}"
          end

          return result
        end

        ##
        # Convert to a Hash equivalent for JSON serialization
        ##
        # - Exclude attributes with nil values.
        # - Validate feature_report hash properties against schema.
        ##
        def to_hash
          result = {}
          result[:id] = @id if @id
          result[:name] = @name if @name
          result[:directory_name] = @directory_name if @directory_name
          result[:feature_type] = @feature_type if @feature_type
          result[:timesteps_per_hour] = @timesteps_per_hour if @timesteps_per_hour
          result[:simulation_status] = @simulation_status if @simulation_status
          result[:timeseries_csv] = @timeseries_csv.to_hash

          result[:location] = @location.to_hash if @location

          result[:program] = @program.to_hash

          result[:construction_costs] = []
          @construction_costs.each { |cc| result[:construction_costs] << cc.to_hash }

          result[:reporting_periods] = []
          @reporting_periods.each { |rp| result[:reporting_periods] << rp.to_hash }

          result[:distributed_generation] = @distributed_generation.to_hash if @distributed_generation

          result[:power_distribution] = @power_distribution.to_hash if @power_distribution

          result[:thermal_storage] = @thermal_storage.to_hash if @thermal_storage

          # validate feature_report properties against schema
          if @@validator.validate(@@schema[:definitions][:FeatureReport][:properties], result).any?
            raise "feature_report properties does not match schema: #{@@validator.validate(@@schema[:definitions][:FeatureReport][:properties], result)}"
          end

          return result
        end

        ##
        # Saves the 'default_feature_report.json' and 'default_feature_report.csv' files
        ##
        # [parameters]:
        # +file_name+ - _String_ - Assign a name to the saved feature results file without an extension
        def save(file_name = 'default_feature_report')
          # reassign the initialize local variable @file_name to the file name input.
          @file_name = file_name

          # save the feature reports csv and json data
          old_timeseries_path = nil
          if !@timeseries_csv.path.nil?
            old_timeseries_path = @timeseries_csv.path
          end

          # define the results_dir_path
          results_dir_path = File.join(@directory_name, 'feature_reports')
          # create feature reports directory
          Dir.mkdir(results_dir_path) unless Dir.exist?(File.join(@directory_name, 'feature_reports'))

          @timeseries_csv.path = File.join(@directory_name, 'feature_reports', file_name + '.csv')
          FileUtils.mkdir_p File.dirname(@timeseries_csv.path)
          @timeseries_csv.save_data

          ## save json rport
          # feature_hash
          feature_hash = to_hash

          json_name_path = File.join(results_dir_path, file_name + '.json')

          File.open(json_name_path, 'w') do |f|
            f.puts JSON.pretty_generate(feature_hash)
            # make sure data is written to the disk one way or the other
            begin
              f.fsync
            rescue StandardError
              f.flush
            end
          end

          if !old_timeseries_path.nil?
            @timeseries_csv.path = old_timeseries_path
          else
            @timeseries_csv.path = File.join(@directory_name, file_name + '.csv')
          end

          return true
        end

        ##
        # Calls the individual functions to save 'default_feature_report.json' and 'default_feature_report.csv'
        # For backward compatibility and ease of use
        ##
        # [parameters]:
        # +file_name+ - _String_ - Assign a name to the saved feature report file without an extension
        def save_feature_report(file_name = 'default_feature_report')
          save_json_report(file_name)
          save_csv_report(file_name)
        end

        ##
        # Saves the 'default_feature_report.json' file to the results directory
        ##
        # [parameters]:
        # +file_name+ - _String_ - Assign a name to the saved feature report file without an extension
        def save_json_report(file_name = 'default_feature_report')
          # reassign the initialize local variable @file_name to the file name input.
          @file_name = file_name

          # define the results_dir_path
          results_dir_path = File.join(@directory_name, 'feature_reports')
          # create feature reports directory
          Dir.mkdir(results_dir_path) unless Dir.exist?(File.join(@directory_name, 'feature_reports'))

          ## save json rport
          # feature_hash
          feature_hash = to_hash

          json_name_path = File.join(results_dir_path, file_name + '.json')

          File.open(json_name_path, 'w') do |f|
            f.puts JSON.pretty_generate(feature_hash)
            # make sure data is written to the disk one way or the other
            begin
              f.fsync
            rescue StandardError
              f.flush
            end
          end
        end

        ##
        # Saves the 'default_feature_report.csv' file to the results directory
        # This method only copies the CSV feature reports from the folder generated by the reporting measure 
        # (<meausure number>_default_feature_reports/) to the new feature_reports/ folder
        ##
        # [parameters]:
        # +file_name+ - _String_ - Assign a name to the saved feature report file without an extension
        def save_csv_report(file_name = 'default_feature_report')
          # reassign the initialize local variable @file_name to the file name input.
          @file_name = file_name

          # define the results_dir_path
          results_dir_path = File.join(@directory_name, 'feature_reports')
          # create feature reports directory
          Dir.mkdir(results_dir_path) unless Dir.exist?(File.join(@directory_name, 'feature_reports'))

          ## copy CSV report to the new feature_reports folder
          # get all folder names in the feature diectory
          directory_folders = Dir.glob "#{@directory_name}/*/"
          # copy the CSV report to the new feature_reports folder
          directory_folders.each do |f|
            if f.include? '_default_feature_reports'
              FileUtils.cp(File.join(f, 'default_feature_reports.csv'), File.join(results_dir_path, @file_name + '.csv'))
            end
          end
        end
      end
    end
  end
end
