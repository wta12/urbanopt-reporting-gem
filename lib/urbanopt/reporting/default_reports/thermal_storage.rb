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
require 'urbanopt/reporting/default_reports/validator'
require 'json-schema'

module URBANopt
  module Reporting
    module DefaultReports
      ##
      # Ice Thermal Storage Systems
      ##
      class ThermalStorage
        ##
        # _Float_ - Total ice storage capacity on central plant loop in kWh
        #
        attr_accessor :its_size_kwh

        # _Float_ - Total ice storage capacity distributed to packaged systems in kWh
        #
        attr_accessor :ptes_size_kwh

        def initialize(hash = {})
          hash.delete_if { |k, v| v.nil? }

          @its_size = hash[:its_size_kwh]
          @ptes_size = hash[:ptes_size_kwh]

          # initialize class variables @@validator and @@schema
          @@validator ||= Validator.new
          @@schema ||= @@validator.schema

          # initialize @@logger
          @@logger ||= URBANopt::Reporting::DefaultReports.logger
        end

        ##
        # Assigns default values if attribute values do not exist.
        ##
        def defaults
          hash = {}
          hash[:its_size_kwh] = nil
          hash[:ptes_size_kwh] = nil

          return hash
        end

        ##
        # Convert to hash equivalent for JSON serialization
        ##
        def to_hash
          result = {}
          result[:its_size_kwh] = @its_size_kwh if @its_size_kwh
          result[:ptes_size_kwh] = @ptes_size_kwh if @ptes_size_kwh

          return result
        end

        ##
        # Add up old and new values
        ##
        def self.add_values(existing_value, new_value) #:nodoc:
          if existing_value && new_value
            existing_value += new_value
          elsif new_value
            existing_value = new_value
          end
          return existing_value
        end

        ##
        # Merge thermal storage
        ##
        def self.merge_thermal_storage(existing_tes, new_tes)
          existing_tes.its_size_kwh = add_values(existing_tes.its_size_kwh, new_tes.its_size_kwh)
          existing_tes.ptes_size_kwh = add_values(existing_tes.ptes_size_kwh, new_tes.ptes_size_kwh)

          return existing_tes
        end
      end
    end
  end
end
