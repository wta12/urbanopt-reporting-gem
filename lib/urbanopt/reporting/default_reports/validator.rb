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

require 'json'

module URBANopt
  module Reporting
    module DefaultReports
      class Validator
        @@schema = nil

        # Initialize the root directory
        def initialize
          super

          @root_dir = File.absolute_path(File.join(File.dirname(__FILE__), '..', '..', '..', '..'))

          @instance_lock = Mutex.new
          @@schema ||= schema
        end

        # Return the absolute path of the default reports files
        def files_dir
          File.absolute_path(File.join(@root_dir, 'lib/urbanopt/reporting/default_reports/'))
        end

        # return path to schema file
        def schema_file
          File.join(files_dir, 'schema/scenario_schema.json')
        end

        # return schema
        def schema
          @instance_lock.synchronize do
            if @@schema.nil?
              File.open(schema_file, 'r') do |f|
                @@schema = JSON.parse(f.read, symbolize_names: true)
              end
            end
          end

          @@schema
        end

        # get csv headers from csv schema
        def csv_headers
          # read scenario csv schema headers
          scenario_csv_schema = open(File.expand_path('schema/scenario_csv_columns.txt', File.dirname(__FILE__))) # .read()

          scenario_csv_schema_headers = []
          File.readlines(scenario_csv_schema).each do |line|
            l = line.delete("\n")
            a = l.delete("\t")
            scenario_csv_schema_headers << a
          end

          return scenario_csv_schema_headers
        end

        ##
        # validate data against schema
        ##
        # [parameters:]
        # +schema+ - _Hash_ - A hash of the JSON scenario_schema.
        # +data+ - _Hash_ - A hash of the data to be validated against scenario_schema.
        ##
        def validate(schema, data)
          JSON::Validator.fully_validate(schema, data)
        end

        # check if the schema is valid
        def schema_valid?
          metaschema = JSON::Validator.validator_for_name('draft6').metaschema
          JSON::Validator.validate(metaschema, @@schema)
        end

        # return detailed schema validation errors
        def schema_validation_errors
          metaschema = JSON::Validator.validator_for_name('draft6').metaschema
          JSON::Validator.fully_validate(metaschema, @@schema)
        end
      end
    end
  end
end
